//
//  BaseView.swift
//  audio
//
//  Created by 조세상 on 2020/05/19.
//  Copyright © 2020 조세상. All rights reserved.
//

import UIKit

class BaseView: UIView {

  private(set) var didMakeConstraints = false

  override func updateConstraints() {
    if !self.didMakeConstraints {
      self.makeConstraints()
      self.didMakeConstraints = true
    }
    super.updateConstraints()
  }

  func makeConstraints() {
    // Override point
  }

}
