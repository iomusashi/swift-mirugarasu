//
//  DetailViewModelProtocol.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation

protocol DetailViewModelProtocol {
  var trackViewModel: TrackCellViewModelProtocol { get }
  
  func markLastVisited()
  func trackFavorite(changed: Bool)
}
