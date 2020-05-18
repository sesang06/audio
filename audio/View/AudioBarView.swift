//
//  AudioBarView.swift
//  audio
//
//  Created by 조세상 on 2020/05/18.
//  Copyright © 2020 조세상. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

final class AudioBarView: BaseView {

  fileprivate let playOrPauseButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "ico_pauseAudio_small"), for: .normal)
    return button
  }()

  fileprivate let nextButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "ico_nextAudio_small"), for: .normal)
    return button
  }()


  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    label.textAlignment = .left
    label.numberOfLines = 1
    label.textColor = UIColor.black
    return label
  }()

  private let detailLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    label.textAlignment = .left
    label.numberOfLines = 1
    label.textColor = UIColor.darkGray
    return label
  }()

  private let container: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 4
    return stackView
  }()

  private let buttonContainer: UIStackView = {
    let view = UIStackView()
    view.axis = .horizontal
    view.distribution = .fillEqually
    return view
  }()

  private let imageView: UIImageView = {
    let view = UIImageView()
    view.contentMode = .scaleAspectFit
    return view
  }()


  fileprivate let control = UIControl()

  init() {
    super.init(frame: .zero)
    self.addSubview(self.container)
    self.addSubview(self.imageView)
    self.container.addArrangedSubview(self.titleLabel)
    self.container.addArrangedSubview(self.detailLabel)
    self.addSubview(self.control)
    self.container.isUserInteractionEnabled = false
    self.addSubview(self.buttonContainer)
    self.buttonContainer.addArrangedSubview(self.playOrPauseButton)
    self.buttonContainer.addArrangedSubview(self.nextButton)
    self.backgroundColor = UIColor.lightGray
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  override func makeConstraints() {
    self.imageView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.left.equalToSuperview().offset(10)
      make.bottom.equalToSuperview().offset(-10)
      make.width.equalTo(self.imageView.snp.height)
    }
    self.container.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.left.equalTo(self.imageView.snp.right).offset(10)
      make.bottom.equalToSuperview().offset(-10)
    }
    self.buttonContainer.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.left.equalTo(self.container.snp.right).offset(10)
      make.right.equalToSuperview().offset(-10)
      make.bottom.equalToSuperview().offset(-10)
      make.width.equalTo(100)
    }
    self.control.snp.makeConstraints { make in
      make.edges.equalToSuperview()
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
      self.playOrPauseButton.setImage(UIImage(named: "ico_pauseAudio_small"), for: .normal)
    } else {
      self.playOrPauseButton.setImage(UIImage(named: "ico_playAudio_small"), for: .normal)
    }
  }
  
}

extension Reactive where Base: AudioBarView {

  var next: ControlEvent<Void> {
    return self.base.nextButton.rx.tap
  }

  var playOrPause: ControlEvent<Void> {
    return self.base.playOrPauseButton.rx.tap
  }

  var backgroundTap: ControlEvent<Void> {
    return self.base.control.rx.controlEvent(.touchUpInside)
  }

}
