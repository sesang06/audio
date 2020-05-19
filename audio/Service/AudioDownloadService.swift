//
//  AudioDownloadService.swift
//  audio
//
//  Created by 조세상 on 2020/05/17.
//  Copyright © 2020 조세상. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

protocol AudioDownloadServiceType {
  func fetch(url: URL?) -> Observable<URL>
}

final class AudioDownloadService: AudioDownloadServiceType {

  func fetch(url: URL?) -> Observable<URL> {
    guard let url = url else {
      return .empty()
    }

    let documentsURL = FileManager.default.urls(
      for: .documentDirectory,
      in: .userDomainMask
      )[0]
    let fileURL = documentsURL.appendingPathComponent(url.lastPathComponent)

    if FileManager.default.fileExists(atPath: fileURL.path) {
      return .just(fileURL)
    }
    return Observable<URL>.create { event -> Disposable in
      let destination: DownloadRequest.Destination = { _, _ in
        return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
      }
      let disposeable = AF.download(
        url,
        to: destination
      ).response { response in
        event.onNext(fileURL)
      }
      return Disposables.create {
        disposeable.cancel()
      }

    }

  }
}
