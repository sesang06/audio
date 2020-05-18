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

  struct Configuration {
    let staticUrlPrefix: URL?

    init(json: JSON) {
      self.staticUrlPrefix = json["static_url_prefix"].url
    }
  }

  struct Audio {
    let title: String
    let description: String
    let audioURLPath: String
    let imageURLPath: String
    let updatedAt: Date?
    let userId: Int

    init(json: JSON) {
      self.title = json["title"].stringValue
      self.description = json["description"].stringValue
      self.audioURLPath = json["audio_url"].stringValue
      self.imageURLPath = json["image_url"].stringValue
      let updatedAtRawString = json["updated_at"].stringValue
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
      dateFormatter.timeZone = TimeZone(identifier: "UTC ")
      self.updatedAt = dateFormatter.date(from: updatedAtRawString)
      self.userId = json["user_id"].intValue
    }
  }

}
