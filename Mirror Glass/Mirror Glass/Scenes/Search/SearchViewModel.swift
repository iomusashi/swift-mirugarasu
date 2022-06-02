//
//  SearchViewModel.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation

class SearchViewModel: SearchViewModelProtocol {
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

extension SearchViewModel {
  func detailViewModel(at indexPath: IndexPath) -> DetailViewModelProtocol {
    return DetailViewModel(track: tracks[indexPath.item], shouldLogVisits: false)
  }
  
  func fetchTracks(
    query: String,
    onSuccess: @escaping VoidResult,
    onFailure: @escaping ErrorResult
  ) {
    let params = TrackRequestParameters(term: query, cacheResultsToDisk: false)
    service.search(
      parameters: params,
      onSuccess: handleTracks(thenTrigger: onSuccess),
      onFailure: onFailure
    )
  }
}

// MARK: Event Handlers

extension SearchViewModel {
  func handleTracks(thenTrigger onSuccess: @escaping VoidResult) -> SingleResult<[Track]> {
    return { [weak self] tracks in
      self?.tracks = tracks
      onSuccess()
    }
  }
}

// MARK: - Getters

extension SearchViewModel {
  var trackCellViewModels: [TrackCellViewModelProtocol] {
    tracks.map { HomeTrackCellViewModel(track: $0) }
  }
}
