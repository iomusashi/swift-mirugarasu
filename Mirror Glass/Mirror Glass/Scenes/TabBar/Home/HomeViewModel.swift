//
//  HomeViewModel.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation

class HomeViewModel: HomeViewModelProtocol {
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

extension HomeViewModel {
  func detailViewModel(at indexPath: IndexPath) -> DetailViewModelProtocol {
    return DetailViewModel(track: tracks[indexPath.item])
  }
  
  func fetchTracks(
    onSuccess: @escaping VoidResult,
    onFailure: @escaping ErrorResult
  ) {
    service.search(
      parameters: TrackRequestParameters(),
      onSuccess: handleTracks(thenTrigger: onSuccess),
      onFailure: onFailure
    )
  }
}

// MARK: Event Handlers

extension HomeViewModel {
  func handleTracks(thenTrigger onSuccess: @escaping VoidResult) -> SingleResult<[Track]> {
    return { [weak self] tracks in
      self?.tracks = tracks
      onSuccess()
    }
  }
}

// MARK: - Getters

extension HomeViewModel {
  var trackCellViewModels: [TrackCellViewModelProtocol] {
    tracks.map { HomeTrackCellViewModel(track: $0) }
  }
}
