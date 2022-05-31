//
//  TrackRepositoryServiceProtocol.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation

protocol TrackRepositoryServiceProtocol {
  func search(
    term: String,
    country: String,
    media: ITunesMediaType,
    onSuccess: @escaping SingleResult<[Track]>,
    onFailure: @escaping ErrorResult
  )
}
