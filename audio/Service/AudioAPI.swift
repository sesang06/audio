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
  case list
}

extension AudioAPI: TargetType {

  var baseURL: URL {
    return URL(string: "https://raw.githubusercontent.com/sesang06/audio/master")!
  }


  var path: String {
    switch self {
    case .list:
      return "/list.json"
    }
  }

  var method: Moya.Method {
    switch self {
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
