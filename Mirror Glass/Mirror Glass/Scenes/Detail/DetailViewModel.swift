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
  
  init(track: Track) {
    self.track = track
    self.isEditing = false
  }
}

// MARK: - Methods

extension DetailViewModel {
  func markLastVisited() {
    guard !isEditing else { return }
    isEditing.toggle()
    let mo = track.asManagedObject(context: CoreData.stack.saveContext)
    mo?.setValue(Date.now, forKey: "lastVisited")
    CoreData.stack.save()
    isEditing.toggle()
    return
  }
}

// MARK: - Getters

extension DetailViewModel {
  var trackViewModel: TrackCellViewModelProtocol { DetailTrackCellViewModel(track: track) }
  var longDescription: String { track.longDescription }
}
