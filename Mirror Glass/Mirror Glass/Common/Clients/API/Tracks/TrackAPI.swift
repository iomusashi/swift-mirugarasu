//
//  TrackAPI.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation
import Alamofire

/// https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/Searching.html
enum ITunesMediaType: String, Codable {
  case movie, podcast, music
}

protocol TrackAPI {
  @discardableResult
  func getTracks(
    parameters: TrackRequestParameters,
    onSuccess: @escaping SingleResult<[Track]>,
    onFailure: @escaping ErrorResult
  ) -> DataRequest
}
