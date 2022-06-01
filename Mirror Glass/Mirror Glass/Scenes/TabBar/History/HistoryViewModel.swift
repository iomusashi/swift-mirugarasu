//
//  HistoryViewModel.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation

class HistoryViewModel: HistoryViewModelProtocol {
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

extension HistoryViewModel {
  func detailViewModel(at indexPath: IndexPath) -> DetailViewModelProtocol {
    return DetailViewModel(track: tracks[indexPath.item], shouldLogVisits: false)
  }
  
  func fetchAllLastVisited(onSuccess: @escaping VoidResult) {
    service.fetchAllLastVisited(onSuccess: handleFetchSuccess(onSuccess: onSuccess))
  }
}

// MARK: - Private functions

extension HistoryViewModel {
  private func handleFetchSuccess(onSuccess: @escaping VoidResult) -> SingleResult<[Track]> {
    return { [weak self] tracks in
      self?.tracks = tracks
      onSuccess()
    }
  }
}

// MARK: - Getters

extension HistoryViewModel {
  var trackCellViewModels: [TrackCellViewModelProtocol] {
    tracks.map { HomeTrackCellViewModel(track: $0) }
  }
}
