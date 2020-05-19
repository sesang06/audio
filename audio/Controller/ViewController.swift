//
//  ViewController.swift
//  audio
//
//  Created by 조세상 on 2020/05/17.
//  Copyright © 2020 조세상. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation

class ViewController: UIViewController {
  
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
    view.backgroundColor = .clear
    return view
  }()
  
  
  private let viewModel: AudioListViewModel = {
    let networking = AudioNetworking()
    let service = AudioService(networking: networking)
    let downloadService = AudioDownloadService()
    let playService = AudioPlayService()
    let vm = AudioListViewModel(
      service: service,
      downloadService: downloadService,
      playService: playService
    )
    return vm
  }()
  
  private let disposeBag = DisposeBag()
  
  private let playView: AudioPlayView = {
    let view = AudioPlayView()
    view.isHidden = true
    return view
  }()

  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.collectionView.delegate = self
    self.collectionView.register(
      AudioCell.self,
      forCellWithReuseIdentifier: AudioCell.reuseIdentifier
    )
    self.view.addSubview(self.collectionView)
    self.view.addSubview(self.playView)
    self.makeContraints()
    self.bind()
  }
  
  private func makeContraints() {
    self.collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func bind() {
    
    let viewDidLoad = PublishSubject<Void>()
    
    let inputs = AudioListViewModel.Inputs(
      viewDidLoad: viewDidLoad,
      itemSelected: self.collectionView.rx.itemSelected.asObservable(), 
      closePlayer: self.playView.rx.closePlayer.asObservable(),
      previous: self.playView.rx.previous.asObservable(),
      playOrPause: self.playView.rx.playOrPause.asObservable(),
      next: self.playView.rx.next.asObservable(),
      skip: self.playView.rx.skip.asObservable(),
      rewind: self.playView.rx.rewind.asObservable()
    )
    
    let outputs = self.viewModel.transform(inputs: inputs)
    
    outputs.section
      .drive(self.collectionView.rx.items(
        cellIdentifier: AudioCell.reuseIdentifier,
        cellType: AudioCell.self)
      ) { row, element, cell in
        cell.configure(viewModel: element) }
      .disposed(by: self.disposeBag)
    
    outputs.playingModel
      .drive(onNext: { [weak self] model in
        self?.playView.configure(viewModel: model)
      })
      .disposed(by: self.disposeBag)
    
    outputs.currentTime
      .drive(self.playView.currentTime)
      .disposed(by: self.disposeBag)
    
    
    outputs.totalTime
      .drive(self.playView.totalTime)
      .disposed(by: self.disposeBag)
    
    outputs.isPlayerOpened
      .distinctUntilChanged()
      .drive(onNext: { [weak self] isOpened in
        self?.playView.isHidden = !isOpened
        self?.playView.isExpanded = false
      })
      .disposed(by: self.disposeBag)
    
    outputs.isPlaying
      .drive(onNext: { [weak self] isPlaying in
        self?.playView.configure(isPlaying: isPlaying)
      })
      .disposed(by: self.disposeBag)
    
    viewDidLoad.onNext(())
  }
  
  
}


extension ViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let width = collectionView.bounds.width
    return .init(width: width, height: 16+16+80)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}
