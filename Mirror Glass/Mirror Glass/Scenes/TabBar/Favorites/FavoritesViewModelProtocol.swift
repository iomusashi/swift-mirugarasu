//
//  FavoritesViewModelProtocol.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation

protocol FavoritesViewModelProtocol {
  var trackCellViewModels: [TrackCellViewModelProtocol] { get }
  
  func detailViewModel(at indexPath: IndexPath) -> DetailViewModelProtocol
  func fetchFavorites(onSuccess: @escaping VoidResult)
}
