//
//  AudioCell.swift
//  audio
//
//  Created by 조세상 on 2020/05/17.
//  Copyright © 2020 조세상. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

final class AudioCell: UICollectionViewCell {


  static var reuseIdentifier: String {
    return String(describing: Self.self)
  }

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.black
    label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    label.numberOfLines = 1
    return label
  }()

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.gray
    label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    label.numberOfLines = 1
    return label
  }()

  private let labelContainer: UIStackView = {
    let view = UIStackView()
    view.spacing = 5
    view.axis = .vertical
    view.alignment = .fill
    view.distribution = .fill
    return view
  }()

  private let imageView: UIImageView = {
    let view = UIImageView()
    view.contentMode = .scaleAspectFit
    view.backgroundColor = UIColor.lightGray
    return view
  }()

  private let separator: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.lightGray
    view.alpha = 0.5
    return view
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(self.imageView)
    self.addSubview(self.labelContainer)
    self.addSubview(self.separator)
    self.labelContainer.addArrangedSubview(self.titleLabel)
    self.labelContainer.addArrangedSubview(self.descriptionLabel)
    self.makeContraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func makeContraints() {
    self.imageView.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(16)
      make.centerY.equalToSuperview()
      make.size.equalTo(80)
    }
    self.labelContainer.snp.makeConstraints { make in
      make.left.equalTo(self.imageView.snp.right).offset(16)
      make.top.greaterThanOrEqualToSuperview().offset(16)
      make.bottom.lessThanOrEqualToSuperview().offset(-16)
      make.centerY.equalToSuperview()
      make.right.equalToSuperview().offset(-16)
    }
    self.separator.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(16)
      make.bottom.equalToSuperview()
      make.height.equalTo(1)
      make.right.equalToSuperview().offset(-16)
    }
  }

}

extension AudioCell {
  func configure(viewModel: AudioItem) {
    self.titleLabel.text = viewModel.title
    self.descriptionLabel.text = viewModel.description
    self.imageView.image = nil
    self.imageView.kf.cancelDownloadTask()
    self.imageView.kf.setImage(
      with: viewModel.imageURL,
      options: [.transition(.fade(0.2))]
    )
  }
}
