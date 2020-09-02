//
//  AudioModel.swift
//  audio
//
//  Created by 조세상 on 2020/05/17.
//  Copyright © 2020 조세상. All rights reserved.
//

import Foundation
import SwiftyJSON


struct AudioModel {

  struct Audio {
    let title: String
    let description: String
    let audioURLPath: String
    let imageURLPath: String

    init(json: JSON) {
      self.title = json["title"].stringValue
      self.description = json["description"].stringValue
      self.audioURLPath = json["audio_url"].stringValue
      self.imageURLPath = json["image_url"].stringValue
    }
  }

}
