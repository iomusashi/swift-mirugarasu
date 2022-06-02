//
//  MockHomeViewModel.swift
//  Mirror GlassTests
//
//  Created by インヤキ on 6/2/22.
//

import Foundation

@testable import Mirror_Glass

class MockHomeViewModel: HomeViewModelProtocol {
  var errorToReturn: Error?

  private(set) var detailViewModelCallCount: Int = 0
  private(set) var fetchTracksCallCount: Int = 0
}

// MARK: - Methods

extension MockHomeViewModel {
  func detailViewModel(at indexPath: IndexPath) -> DetailViewModelProtocol {
    detailViewModelCallCount += 1
    return MockDetailViewModel()
  }
  
  func fetchTracks(onSuccess: @escaping VoidResult, onFailure: @escaping ErrorResult) {
    fetchTracksCallCount += 1
    if let e = errorToReturn {
      onFailure(e)
    } else {
      onSuccess()
    }
  }
}

// MARK: - Getters
extension MockHomeViewModel {
  var trackCellViewModels: [TrackCellViewModelProtocol] { [] }
}
