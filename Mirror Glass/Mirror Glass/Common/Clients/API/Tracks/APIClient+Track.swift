//
//  APIClient+Track.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation

import Alamofire

extension ApiClient: TrackAPI {
  @discardableResult
  func getTracks(
    term: String = "star",
    country: String = "au",
    media: ITunesMediaType = .movie,
    onSuccess: @escaping SingleResult<[Track]>,
    onFailure: @escaping ErrorResult
  ) -> DataRequest {
    var parameters: Parameters = [:]
    parameters["term"] = term
    parameters["country"] = country
    parameters["media"] = media.rawValue
    
    return request(
      "search",
      parameters: parameters,
      success: decodeModel(
        onSuccess: onSuccess,
        onError: onFailure
      ),
      failure: onFailure
    )
  }
}
