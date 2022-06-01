//
//  HomeViewModelProtocol.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation

protocol HomeViewModelProtocol {
  var trackCellViewModels: [TrackCellViewModelProtocol] { get }
  
  func fetchTracks(
    onSuccess: @escaping VoidResult,
    onFailure: @escaping ErrorResult
  )
}
