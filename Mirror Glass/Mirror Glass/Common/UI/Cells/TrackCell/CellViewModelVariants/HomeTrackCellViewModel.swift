//
//  HomeTrackCellViewModel.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation

class HomeTrackCellViewModel: TrackCellViewModelProtocol {
  private let track: Track
  
  var onFavoriteStateChanged: BoolResult?
  
  init(track: Track) {
    if let mo = CoreData.stack.viewContext.findFirst(TrackEntity.self, withId: track.id.rawValue) {
      self.track = Track.from(entity: mo)
    } else {
      self.track = track
    }
  }
}

// MARK: - Methods

extension HomeTrackCellViewModel {
  func toggleFavorite() {
    // no op
  }
}

// MARK: - Getters

extension HomeTrackCellViewModel {
  var trackImageUrl: URL { track.artworkUrl }
  var title: String { track.title }
  var genre: String { track.genre }
  var kind: String { track.kind.uppercased() }
  var shortDescription: String { track.longDescription }
  var price: String { "$\(track.price ?? .zero) \(track.currency ?? "")" }
  var showChevronIcon: Bool { true }
  var showFavoriteIcon: Bool { false }
  var isFavorite: Bool { track.isFavorite }
  var showDescription: Bool { true }
  var descriptionNumberOfLines: Int { 2 }
}
