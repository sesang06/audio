//
//  AudioService.swift
//  audio
//
//  Created by 조세상 on 2020/05/17.
//  Copyright © 2020 조세상. All rights reserved.
//

import RxSwift
import Moya
import RxMoya
import SwiftyJSON

protocol AudioServiceType {
  func list() -> Single<[AudioModel.Audio]>
}


typealias AudioNetworking = MoyaProvider<AudioAPI>

final class AudioService {

  let networking: AudioNetworking

  init(networking: AudioNetworking) {
    self.networking = networking
  }
}

extension AudioService: AudioServiceType {

  func list() -> Single<[AudioModel.Audio]> {
    return self.networking.rx
      .request(.list)
      .mapSwiftyJSON()
      .map { $0.arrayValue.map { AudioModel.Audio(json: $0) } }
  }

}



fileprivate extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
  func mapSwiftyJSON() -> Single<JSON> {
    return self.map { response -> JSON in
      return JSON(response.data)
    }
  }
}
