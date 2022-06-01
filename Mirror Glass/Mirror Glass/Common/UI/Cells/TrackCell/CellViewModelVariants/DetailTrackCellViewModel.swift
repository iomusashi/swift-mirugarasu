//
//  DetailTrackCellViewModel.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation

class DetailTrackCellViewModel: TrackCellViewModelProtocol {
  private let track: Track
  
  init(track: Track) {
    self.track = track
  }
}

// MARK: - Methods

extension DetailTrackCellViewModel {
}

// MARK: - Getters

extension DetailTrackCellViewModel {
  var trackImageUrl: URL { track.artworkUrl }
  var title: String { track.title }
  var genre: String { track.genre }
  var kind: String { track.kind.uppercased() }
  var shortDescription: String { track.longDescription }
  var price: String { "$\(track.price ?? .zero) \(track.currency ?? "")" }
  var showChevronIcon: Bool { false }
  var showShortDescription: Bool { false }
  var showLongDescription: Bool { true }
  var descriptionNumberOfLines: Int { 0 }
}
