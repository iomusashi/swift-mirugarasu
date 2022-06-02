//
//  HistoryViewModelProtocol.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation

protocol HistoryViewModelProtocol {
  var trackCellViewModels: [TrackCellViewModelProtocol] { get }
  
  func detailViewModel(at indexPath: IndexPath) -> DetailViewModelProtocol
  func fetchAllLastVisited(onSuccess: @escaping VoidResult)
}
