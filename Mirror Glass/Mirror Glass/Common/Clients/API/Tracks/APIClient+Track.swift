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
    parameters: TrackRequestParameters,
    onSuccess: @escaping SingleResult<[Track]>,
    onFailure: @escaping ErrorResult
  ) -> DataRequest {
    let params: Parameters = [
      "term": parameters.term,
      "country": parameters.country,
      "media": parameters.media.rawValue
    ]
    
    return request(
      "search",
      parameters: params,
      success: decodeModel(
        onSuccess: onSuccess,
        onError: onFailure
      ),
      failure: onFailure
    )
  }
}
