//
//  AudioPlayService.swift
//  audio
//
//  Created by 조세상 on 2020/05/17.
//  Copyright © 2020 조세상. All rights reserved.
//

import Foundation
import AVFoundation
import RxSwift
import RxCocoa


final class AudioPlayService {

  private let isPlayingTrigger = PublishSubject<Void>()

  private var player: AVAudioPlayer?

  var isPlaying: Observable<Bool> {
    return self.isPlayingTrigger.map {
      self.player?.isPlaying ?? false
    }
  }

  var currentTime: TimeInterval {
    return self.player?.currentTime ?? 0
  }

  var totalTime: TimeInterval {
    return self.player?.duration ?? 0
  }

  func start(url: URL?) {
    if let url = url {
      self.player = try? AVAudioPlayer(contentsOf: url)
      self.player?.prepareToPlay()
      self.isPlayingTrigger.onNext(())
    }
  }

  func pause() {
    self.player?.pause()
    self.isPlayingTrigger.onNext(())
  }

  func skip() {
    self.player?.stop()
    self.player?.currentTime = max(0.0, self.currentTime + 15.0)
    self.player?.play()
  }

  func rewind() {
    self.player?.stop()
    self.player?.currentTime = min(self.totalTime, self.currentTime - 15.0)
    self.player?.play()
  }

  func play() {
    self.player?.play()
    self.isPlayingTrigger.onNext(())
  }

}
