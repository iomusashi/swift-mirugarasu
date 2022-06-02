//
//  SearchViewModelProtocol.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation

protocol SearchViewModelProtocol {
  var trackCellViewModels: [TrackCellViewModelProtocol] { get }
  
  func detailViewModel(at indexPath: IndexPath) -> DetailViewModelProtocol
  func fetchTracks(
    query: String,
    onSuccess: @escaping VoidResult,
    onFailure: @escaping ErrorResult
  )
}
