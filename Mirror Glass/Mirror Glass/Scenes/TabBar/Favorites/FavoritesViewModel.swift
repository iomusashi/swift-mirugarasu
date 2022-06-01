//
//  FavoritesViewModel.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation

class FavoritesViewModel: FavoritesViewModelProtocol {
  private var tracks: [Track]
  private let service: TrackRepositoryServiceProtocol
  
  init(
    tracks: [Track] = [],
    service: TrackRepositoryServiceProtocol = App.shared.tracksRepository
  ) {
    self.tracks = tracks
    self.service = service
  }
}

// MARK: - Methods

extension FavoritesViewModel {
  func detailViewModel(at indexPath: IndexPath) -> DetailViewModelProtocol {
    return DetailViewModel(track: tracks[indexPath.item])
  }
  
  func fetchFavorites(onSuccess: @escaping VoidResult) {
    service.fetchFavorites(onSuccess: handleFetchSuccess(onSuccess: onSuccess))
  }
}

// MARK: - Private functions

extension FavoritesViewModel {
  private func handleFetchSuccess(onSuccess: @escaping VoidResult) -> SingleResult<[Track]> {
    return { [weak self] tracks in
      self?.tracks = tracks
      onSuccess()
    }
  }
}

// MARK: - Getters

extension FavoritesViewModel {
  var trackCellViewModels: [TrackCellViewModelProtocol] {
    tracks.map { HomeTrackCellViewModel(track: $0) }
  }
}
