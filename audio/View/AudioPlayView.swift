//
//  AudioPlayView.swift
//  audio
//
//  Created by 조세상 on 2020/05/19.
//  Copyright © 2020 조세상. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class AudioPlayView: BaseView {

  var isExpanded: Bool = false {
    didSet {
      if self.isExpanded {
        self.expand()
      } else {
        self.collapse()
      }
    }
  }

  fileprivate let expandedView = AudioExpandedPlayView()

  fileprivate let barView = AudioBarView()

  lazy var currentTime = self.expandedView.currentTime

  lazy var totalTime = self.expandedView.totalTime

  private let disposeBag = DisposeBag()

  init() {
    super.init(frame: .zero)
    self.addSubview(self.expandedView)
    self.addSubview(self.barView)
    self.bind()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func makeConstraints() {
    self.expandedView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    self.barView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    self.snp.makeConstraints { make in
      make.bottom.left.right.equalToSuperview()
      make.height.equalTo(100)
    }
  }

  private func bind() {
    self.barView.rx.backgroundTap
      .subscribe(onNext: { [weak self] _ in
        self?.isExpanded = true
      })
      .disposed(by: self.disposeBag)
  }


  func configure(viewModel: AudioItem) {
    self.expandedView.configure(viewModel: viewModel)
    self.barView.configure(viewModel: viewModel)
  }



  func configure(isPlaying: Bool) {
    self.expandedView.configure(isPlaying: isPlaying)
    self.barView.configure(isPlaying: isPlaying)
  }

  private func expand() {
    self.barView.isHidden = true
    self.expandedView.isHidden = false
    self.snp.remakeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  private func collapse() {
    self.barView.isHidden = false
    self.expandedView.isHidden = true
    self.snp.remakeConstraints { make in
      make.bottom.left.right.equalToSuperview()
      make.height.equalTo(100)
    }
  }

}

extension Reactive where Base: AudioPlayView {

  var closePlayer: ControlEvent<Void> {
    return self.base.expandedView.rx.closePlayer
  }

  var previous: ControlEvent<Void> {
    return self.base.expandedView.rx.previous
  }

  var next: Observable<Void> {
    return Observable.merge(
      self.base.expandedView.rx.next.asObservable(),
      self.base.barView.rx.next.asObservable()
    )
  }

  var skip: ControlEvent<Void> {
    return self.base.expandedView.rx.skip
  }

  var rewind: ControlEvent<Void> {
    return self.base.expandedView.rx.rewind
  }

  var playOrPause: Observable<Void> {
    return Observable.merge(
      self.base.expandedView.rx.playOrPause.asObservable(),
      self.base.barView.rx.playOrPause.asObservable()
    )
  }

}
