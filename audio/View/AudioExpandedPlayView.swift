//
//  AudioExpandedPlayView.swift
//  audio
//
//  Created by 조세상 on 2020/05/17.
//  Copyright © 2020 조세상. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class AudioExpandedPlayView: BaseView {

  fileprivate let closeButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "ico_closePlayer"), for: .normal)
    return button
  }()

  fileprivate let rewindButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "ico_prev15secAudio"), for: .normal)
    return button
  }()

  fileprivate let previousButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "ico_prevAudio"), for: .normal)
    return button
  }()

  fileprivate let playOrPauseButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "ico_pauseAudio"), for: .normal)
    return button
  }()

  fileprivate let nextButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "ico_nextAudio"), for: .normal)
    return button
  }()

  fileprivate let skipButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "ico_next15secAudio"), for: .normal)
    return button
  }()

  private let buttonContainer: UIStackView = {
    let view = UIStackView()
    view.axis = .horizontal
    view.distribution = .fillEqually
    return view
  }()

  private let progressView = AudioProgressView()

  private let imageView: UIImageView = {
    let view = UIImageView()
    view.contentMode = .scaleAspectFit
    return view
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    label.textAlignment = .center
    label.numberOfLines = 2
    label.textColor = UIColor.black
    return label
  }()

  private let detailLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    label.textAlignment = .center
    label.numberOfLines = 1
    label.textColor = UIColor.darkGray
    return label
  }()

  private let container: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 16
    return stackView
  }()


  lazy var currentTime = self.progressView.currentTime

  lazy var totalTime = self.progressView.totalTime

  private var isExpanded: Bool = false

  init() {
    super.init(frame: .zero)
    self.backgroundColor = .white
    self.addSubview(self.container)
    self.container.addArrangedSubview(self.imageView)
    self.container.addArrangedSubview(self.titleLabel)
    self.container.addArrangedSubview(self.detailLabel)
    self.addSubview(self.progressView)
    self.addSubview(self.buttonContainer)
    self.buttonContainer.addArrangedSubview(self.rewindButton)
    self.buttonContainer.addArrangedSubview(self.previousButton)
    self.buttonContainer.addArrangedSubview(self.playOrPauseButton)
    self.buttonContainer.addArrangedSubview(self.nextButton)
    self.buttonContainer.addArrangedSubview(self.skipButton)
    self.addSubview(self.closeButton)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  override func makeConstraints() {
    self.container.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(84)
      make.left.equalToSuperview().offset(36)
      make.right.equalToSuperview().offset(-36)
    }
    self.imageView.snp.makeConstraints { make in
      make.width.equalTo(self.imageView.snp.height)
      make.left.right.equalToSuperview()
    }
    self.progressView.snp.makeConstraints { make in
      make.top.equalTo(self.container.snp.bottom).offset(50)
      make.left.equalToSuperview().offset(36)
      make.right.equalToSuperview().offset(-36)
      make.height.equalTo(24)
    }
    self.buttonContainer.snp.makeConstraints { make in
      make.top.equalTo(self.progressView.snp.bottom).offset(30)
      make.left.equalToSuperview().offset(30)
      make.right.equalToSuperview().offset(-30)
      make.height.equalTo(100)
    }
    self.closeButton.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(30)
      make.right.equalToSuperview().offset(-18)
      make.size.equalTo(36)
    }
  }

  func configure(viewModel: AudioItem) {
    self.titleLabel.text = viewModel.title
    self.detailLabel.text = viewModel.description
    self.imageView.image = nil
    self.imageView.kf.cancelDownloadTask()
    self.imageView.kf.setImage(
      with: viewModel.imageURL,
      options: [.transition(.fade(0.2))]
    )
  }



  func configure(isPlaying: Bool) {
    if isPlaying {
      self.playOrPauseButton.setImage(UIImage(named: "ico_pauseAudio"), for: .normal)
    } else {
      self.playOrPauseButton.setImage(UIImage(named: "ico_playAudio"), for: .normal)
    }
  }


}


extension Reactive where Base: AudioExpandedPlayView {

  var closePlayer: ControlEvent<Void> {
    return self.base.closeButton.rx.tap
  }

  var previous: ControlEvent<Void> {
    return self.base.previousButton.rx.tap
  }

  var next: ControlEvent<Void> {
    return self.base.nextButton.rx.tap
  }

  var skip: ControlEvent<Void> {
    return self.base.skipButton.rx.tap
  }

  var rewind: ControlEvent<Void> {
    return self.base.rewindButton.rx.tap
  }

  var playOrPause: ControlEvent<Void> {
    return self.base.playOrPauseButton.rx.tap
  }

}
