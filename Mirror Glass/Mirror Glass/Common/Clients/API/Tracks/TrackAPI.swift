//
//  TrackAPI.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation
import Alamofire

/// https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/Searching.html
enum ITunesMediaType: String {
  case movie, podcast, music
}

protocol TrackAPI {
  @discardableResult
  func getTracks(
    term: String,
    country: String,
    media: ITunesMediaType,
    onSuccess: @escaping SingleResult<[Track]>,
    onFailure: @escaping ErrorResult
  ) -> DataRequest
}
