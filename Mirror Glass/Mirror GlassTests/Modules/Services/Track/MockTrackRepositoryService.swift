//
//  MockTrackRepositoryService.swift
//  Mirror GlassTests
//
//  Created by インヤキ on 6/2/22.
//

import Foundation

@testable import Mirror_Glass

class MockTrackRepositoryService: TrackRepositoryServiceProtocol {
  var errorToReturn: Error?
  
  private let api: MockTrackAPI
  
  private(set) var searchCallCount = 0
  private(set) var fetchFavoritesCallCount = 0
  private(set) var fetchAllLastVisitedCallCount = 0
  
  init(api: MockTrackAPI) {
    self.api = api
  }
  
  func reset() {
    errorToReturn = nil
    searchCallCount = 0
    fetchFavoritesCallCount = 0
    fetchAllLastVisitedCallCount = 0
  }
}

// MARK: - Methods

extension MockTrackRepositoryService {
  func search(
    parameters: TrackRequestParameters,
    onSuccess: @escaping SingleResult<[Track]>,
    onFailure: @escaping ErrorResult
  ) {
    searchCallCount += 1
    api.getTracks(
      parameters: parameters,
      onSuccess: onSuccess,
      onFailure: onFailure
    )
  }
  
  func fetchFavorites(
    onSuccess: @escaping SingleResult<[Track]>
  ) {
    fetchFavoritesCallCount += 1
    onSuccess([Track()])
  }
  
  func fetchAllLastVisited(
    onSuccess: @escaping SingleResult<[Track]>
  ) {
    fetchAllLastVisitedCallCount += 1
    onSuccess([Track()])
  }
}
