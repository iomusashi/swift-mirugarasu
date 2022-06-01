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
    parameters: TrackRequestParameters,
    onSuccess: @escaping SingleResult<[Track]>,
    onFailure: @escaping ErrorResult
  ) {
    api.getTracks(
      parameters: parameters,
      onSuccess: persistNetworkModels(onSuccess: onSuccess),
      onFailure: fetchCachedResultsOnNetworkFailure(
        onSuccess: onSuccess,
        onFailure: onFailure
      )
    )
  }
  
  private func persistNetworkModels(
    onSuccess: @escaping SingleResult<[Track]>
  ) -> SingleResult<[Track]> {
    return { tracks in
      let mos = tracks.compactMap { $0.asManagedObject(context: CoreData.stack.saveContext) }
      CoreData.stack.save()
      let persisted = mos.map { Track.from(entity: $0 as! TrackEntity)}
      onSuccess(persisted)
    }
  }
  
  private func fetchCachedResultsOnNetworkFailure(
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
