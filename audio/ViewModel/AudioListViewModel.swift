//
//  AudioListViewModel.swift
//  audio
//
//  Created by 조세상 on 2020/05/17.
//  Copyright © 2020 조세상. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class AudioListViewModel {
  
  struct Inputs {
    let viewDidLoad: Observable<Void>
    let itemSelected: Observable<IndexPath>
    let closePlayer: Observable<Void>
    let previous: Observable<Void>
    let playOrPause: Observable<Void>
    let next: Observable<Void>
    let skip: Observable<Void>
    let rewind: Observable<Void>
  }
  
  struct Outputs {
    let section: Driver<[AudioItem]>
    let playingModel: Driver<AudioItem>
    let currentTime: Driver<TimeInterval>
    let totalTime: Driver<TimeInterval>
    let isPlaying: Driver<Bool>
    let isPlayerOpened: Driver<Bool>
  }
  
  private let service: AudioServiceType
  
  private let downloadService: AudioDownloadServiceType
  
  private let playService: AudioPlayServiceType
  
  
  init(
    service: AudioServiceType,
    downloadService: AudioDownloadServiceType,
    playService: AudioPlayServiceType
  ) {
    self.service = service
    self.downloadService = downloadService
    self.playService = playService
  }
  
  fileprivate enum Action {
    case itemSelect
    case previous
    case next
  }
  
  
  func transform(inputs: Inputs) -> Outputs {
    
    weak var weakSelf = self
    
    
    let models = inputs.viewDidLoad
      .flatMapLatest { _ in weakSelf?.service.list().asObservable() ?? .empty() }
    
    let section =
      models
        .map { models -> [AudioItem] in
          return models.map {
            return AudioItem(model: $0)
          } }
    
    
    let previous = inputs.previous.map { (0, Action.previous) }
    
    let next = inputs.next.map { (0, Action.next) }
    
    let select = inputs.itemSelected.map { ($0.item, Action.itemSelect) }
    
    
    let playingIndex = Observable.merge(
      previous,
      next,
      select
    ).scan((0, Action.itemSelect)) { lastAction, nextAction in
      switch nextAction.1 {
      case .itemSelect:
        return (nextAction.0, .itemSelect)
      case .next:
        return (lastAction.0 + 1, .next)
      case .previous:
        return (lastAction.0 - 1, .previous)
      }
    }
    .map { $0.0 }
    
    let selectedAudio = playingIndex
      .withLatestFrom(section) { index, section -> AudioItem in
        var loopingIndex = index % section.count
        if loopingIndex < 0 {
          loopingIndex += section.count
        }
        return section[loopingIndex]
    }
    
    let fetchAudio = selectedAudio
      .flatMapLatest { model -> Observable<URL> in return
        weakSelf?.downloadService.fetch(url: model.audioURL) ?? .empty() }
      .map {
        weakSelf?.playService.start(url: $0)
        weakSelf?.playService.play()
        return
    }
    .share()
    
    let playingModel = Observable.zip(
      selectedAudio,
      fetchAudio
    )
      .map { $0.0 }
      .share()
    
    let rewind = inputs.rewind
      .flatMap { _ -> Observable<Void> in .just(self.playService.rewind()) }
    
    let skip = inputs.skip
      .flatMap { [weak self] _ -> Observable<Void> in
        guard let self = self else { return .empty() }
        self.playService.skip()
        return .just(()) }
    
    let playOrPause = inputs.playOrPause
      .withLatestFrom(self.playService.isPlaying)
      .flatMapLatest { isPlaying -> Observable<Void> in
        if isPlaying {
          weakSelf?.playService.pause()
        } else {
          weakSelf?.playService.play()
        }
        return .just(())
    }
    
    let currentTimeTrigger = Observable.merge(
      fetchAudio,
      rewind,
      skip,
      playOrPause
    )
    
    let currentTime = currentTimeTrigger
      .flatMapLatest { _ -> Observable<TimeInterval> in
        return Observable<Int>
          .interval(.seconds(1), scheduler: MainScheduler.instance)
          .startWith(-1)
          .map { _ in weakSelf?.playService.currentTime ?? 0 }
    }
    
    let totalTime = fetchAudio
      .map { _ in weakSelf?.playService.totalTime ?? 0 }
    
    
    let isPlayerClosed = inputs.closePlayer
      .map { _ in weakSelf?.playService.pause() }
    
    let isPlayerOpened = Observable.merge(
      isPlayerClosed.map { _ in false },
      playingModel.map { _ in true }
    )
    
    return .init(
      section: section.asDriver(onErrorDriveWith: .empty()),
      playingModel: playingModel.asDriver(onErrorDriveWith: .empty()),
      currentTime: currentTime.asDriver(onErrorDriveWith: .empty()),
      totalTime: totalTime.asDriver(onErrorDriveWith: .empty()),
      isPlaying: self.playService.isPlaying.asDriver(onErrorDriveWith: .empty()),
      isPlayerOpened: isPlayerOpened.asDriver(onErrorDriveWith: .empty())
    )
  }
}
