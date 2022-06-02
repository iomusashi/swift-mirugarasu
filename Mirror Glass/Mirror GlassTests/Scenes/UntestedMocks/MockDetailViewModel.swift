//
//  MockDetailViewModel.swift
//  Mirror GlassTests
//
//  Created by インヤキ on 6/2/22.
//

import Foundation

@testable import Mirror_Glass

class MockDetailViewModel: DetailViewModelProtocol {
  var trackViewModel: TrackCellViewModelProtocol { MockTrackCellViewModel() }
  
  var errorToReturn: Error?
}

// MARK: - Methods

extension MockDetailViewModel {
  func markLastVisited() {}
  
  func trackFavorite(changed: Bool) {}
}
