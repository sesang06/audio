//
//  AudioAPI.swift
//  audio
//
//  Created by 조세상 on 2020/05/17.
//  Copyright © 2020 조세상. All rights reserved.
//

import Foundation
import Moya

enum AudioAPI {
  case configuration
  case list
}

extension AudioAPI: TargetType {

  var baseURL: URL {
    return URL(string: "https://s3-ap-northeast-1.amazonaws.com/connectier-interview")!
  }


  var path: String {
    switch self {
    case .configuration:
      return "/config.json"
    case .list:
      return "/list.json"
    }
  }

  var method: Moya.Method {
    switch self {
    case .configuration:
      return .get
    case .list:
      return .get
    }
  }

  var sampleData: Data {
    return Data()
  }

  var task: Task {
    return .requestPlain
  }

  var headers: [String : String]? {
    return nil
  }


}
