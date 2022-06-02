//
//  MockTrackCellViewModel.swift
//  Mirror GlassTests
//
//  Created by インヤキ on 6/2/22.
//

import Foundation

@testable import Mirror_Glass

class MockTrackCellViewModel: TrackCellViewModelProtocol {
  var onFavoriteStateChanged: BoolResult?
}

// MARK: - Methods

extension MockTrackCellViewModel {
  func toggleFavorite() {}
}

// MARK: - Getter

extension MockTrackCellViewModel {
  var trackImageUrl: URL { URL(string: "https://example.org")! }
  var title: String { "" }
  var genre: String { "" }
  var kind: String { "" }
  var shortDescription: String { "" }
  var price: String { "" }
  var showChevronIcon: Bool { false }
  var showDescription: Bool { false }
  var showFavoriteIcon: Bool { false }
  var isFavorite: Bool { false }
  var descriptionNumberOfLines: Int { 0 }
}
