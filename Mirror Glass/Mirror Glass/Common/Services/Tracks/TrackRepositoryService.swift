//
//  TrackRepositoryService.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation

class TrackRepositoryService: TrackRepositoryServiceProtocol {
  private let api: TrackAPI
  
  init(api: TrackAPI) {
    self.api = api
  }
}

// MARK: - Methods

extension TrackRepositoryService {
  func search(
    term: String,
    country: String,
    media: ITunesMediaType,
    onSuccess: @escaping SingleResult<[Track]>,
    onFailure: @escaping ErrorResult
  ) {
    api.getTracks(
      term: term,
      country: country,
      media: media,
      onSuccess: onSuccess,
      onFailure: fetchCachedResultsOnNetworkFailure(
        onSuccess: onSuccess,
        onFailure: onFailure
      )
    )
  }
  
  func fetchCachedResultsOnNetworkFailure(
    onSuccess: @escaping SingleResult<[Track]>,
    onFailure: @escaping ErrorResult
  ) -> ErrorResult {
    return { error in
      let tracks = CoreData.stack.viewContext.findAll(TrackEntity.self).compactMap {
        Track.from(entity: $0)
      }
      if !tracks.isEmpty {
        onSuccess(tracks)
      } else {
        onFailure(error)
      }
    }
  }
}
