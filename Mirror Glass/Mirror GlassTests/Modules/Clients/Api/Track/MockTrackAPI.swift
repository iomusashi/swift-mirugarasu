//
//  MockTrackAPI.swift
//  Mirror GlassTests
//
//  Created by インヤキ on 6/2/22.
//

import Foundation
import Alamofire

@testable import Mirror_Glass

class MockTrackAPI: TrackAPI {
  var errorToReturn: Error?
  
  private(set) var getTracksCallCount = 0
  
  func reset() {
    getTracksCallCount = 0
    errorToReturn = nil
  }
}

extension MockTrackAPI {
  func getTracks(
    parameters: TrackRequestParameters,
    onSuccess: @escaping SingleResult<[Track]>,
    onFailure: @escaping ErrorResult
  ) -> DataRequest {
    getTracksCallCount += 1
    if let e = errorToReturn {
      onFailure(e)
    } else {
      onSuccess([Track()])
    }
    return try! Session.default.request(String.mock.asURLRequest())
  }
}
