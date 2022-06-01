//
//  DetailViewModel.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation

class DetailViewModel: DetailViewModelProtocol {
  private var track: Track
  private var isEditing: Bool
  private var shouldLogVisits: Bool
  
  init(track: Track, shouldLogVisits: Bool = true) {
    self.track = track
    self.isEditing = false
    self.shouldLogVisits = shouldLogVisits
  }
}

// MARK: - Methods

extension DetailViewModel {
  func markLastVisited() {
    guard !isEditing, shouldLogVisits else { return }
    isEditing.toggle()
    if let matched = CoreData.stack.saveContext.findFirst(TrackEntity.self, withId: track.id.rawValue) {
      matched.lastVisited = .now
      CoreData.stack.save()
      track = Track.from(entity: matched)
    } else {
      guard let mo = track.asManagedObject(context: CoreData.stack.saveContext) else { return }
      mo.setValue(Date.now, forKey: "lastVisited")
      CoreData.stack.save()
      isEditing.toggle()
    }
    return
  }
  
  func trackFavorite(changed: Bool) {
    self.track.isFavorite = changed
  }
}

// MARK: - Getters

extension DetailViewModel {
  var trackViewModel: TrackCellViewModelProtocol { DetailTrackCellViewModel(track: track) }
  var longDescription: String { track.longDescription }
}
