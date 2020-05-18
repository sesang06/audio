//
//  AudioProgressView.swift
//  audio
//
//  Created by 조세상 on 2020/05/18.
//  Copyright © 2020 조세상. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class AudioProgressView: BaseView {

  private let currentLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    label.textAlignment = .center
    label.numberOfLines = 1
    label.textColor = UIColor.lightGray
    return label
  }()

  private let totalLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    label.textAlignment = .center
    label.numberOfLines = 1
    label.textColor = UIColor.lightGray
    return label
  }()


  private let progressView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.blue
    return view
  }()

  private let progressBackgroundView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.lightGray
    return view
  }()


  let currentTime = PublishSubject<TimeInterval>()

  let totalTime = PublishSubject<TimeInterval>()

  private let disposeBag = DisposeBag()

  init() {
    super.init(frame: .zero)
    self.addSubview(self.progressBackgroundView)
    self.progressBackgroundView.addSubview(self.progressView)
    self.addSubview(self.currentLabel)
    self.addSubview(self.totalLabel)
    self.bind()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  override func makeConstraints() {
    self.progressBackgroundView.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
      make.height.equalTo(4)
    }
    self.progressView.snp.makeConstraints { make in
      make.top.left.bottom.equalToSuperview()
      make.width.equalToSuperview().multipliedBy(0)
    }
    self.currentLabel.snp.makeConstraints { make in
      make.top.equalTo(self.progressBackgroundView.snp.bottom).offset(8)
      make.left.equalToSuperview()
    }
    self.totalLabel.snp.makeConstraints { make in
      make.top.equalTo(self.progressBackgroundView.snp.bottom).offset(8)
      make.right.equalToSuperview()
    }
  }

  private func bind() {
    self.currentTime
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] timeInterval in
        self?.currentLabel.text = self?.formatSecondsToString(timeInterval)
      })
      .disposed(by: self.disposeBag)


    self.totalTime
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] timeInterval in
        self?.totalLabel.text = self?.formatSecondsToString(timeInterval)
      })
      .disposed(by: self.disposeBag)

    Observable.combineLatest(self.currentTime, self.totalTime) { $0 / $1 }
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] rate in
        self?.progressView.snp.remakeConstraints { make in
          make.top.left.bottom.equalToSuperview()
          make.width.equalToSuperview().multipliedBy(rate)
        }
      })
      .disposed(by: self.disposeBag)

  }


  private func formatSecondsToString(_ seconds: TimeInterval) -> String {
    if seconds.isNaN {
      return "00:00"
    }
    let Min = Int(seconds / 60)
    let Sec = Int(seconds.truncatingRemainder(dividingBy: 60))
    return String(format: "%02d:%02d", Min, Sec)
  }

}

