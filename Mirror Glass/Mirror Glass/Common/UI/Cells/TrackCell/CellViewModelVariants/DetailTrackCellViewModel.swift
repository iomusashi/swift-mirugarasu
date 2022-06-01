//
//  DetailTrackCellViewModel.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation

class DetailTrackCellViewModel: TrackCellViewModelProtocol {
  private var track: Track
  
  var onFavoriteStateChanged: BoolResult?
  
  init(track: Track) {
    self.track = track
  }
}

// MARK: - Methods

extension DetailTrackCellViewModel {
  func toggleFavorite() {
    if let matched = CoreData.stack.saveContext.findFirst(TrackEntity.self, withId: track.id.rawValue) {
      matched.isFavorite.toggle()
      CoreData.stack.save()
      track = Track.from(entity: matched)
      onFavoriteStateChanged?(track.isFavorite)
    } else {
      guard let mo = track.asManagedObject(context: CoreData.stack.saveContext) else { return }
      let toggled = !track.isFavorite
      mo.setValue(toggled, forKey: "isFavorite")
      CoreData.stack.save()
      track = Track.from(entity: mo as! TrackEntity)
      onFavoriteStateChanged?(track.isFavorite)
    }
  }
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
  var showFavoriteIcon: Bool { true }
  var isFavorite: Bool { track.isFavorite }
  var showDescription: Bool { true }
  var descriptionNumberOfLines: Int { 0 }
}
