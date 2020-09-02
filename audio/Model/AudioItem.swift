//
//  AudioItem.swift
//  audio
//
//  Created by 조세상 on 2020/05/17.
//  Copyright © 2020 조세상. All rights reserved.
//

import Foundation

struct AudioItem {

  let title: String
  let imageURL: URL?
  let description: String
  let audioURL: URL?

  init(model: AudioModel.Audio) {
    self.title = model.title
    self.description = model.description
    self.imageURL = URL(string: model.imageURLPath)
    self.audioURL = URL(string: model.audioURLPath)
  }
}
