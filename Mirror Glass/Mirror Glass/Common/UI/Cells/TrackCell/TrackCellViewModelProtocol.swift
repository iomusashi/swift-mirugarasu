//
//  TrackCellCellViewModelProtocol.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation

protocol TrackCellViewModelProtocol {
  var onFavoriteStateChanged: BoolResult? { get set }
  
  var trackImageUrl: URL { get }
  var title: String { get }
  var genre: String { get }
  var kind: String { get }
  var shortDescription: String { get }
  var price: String { get }
  var showChevronIcon: Bool { get }
  var showDescription: Bool { get }
  var showFavoriteIcon: Bool { get }
  var isFavorite: Bool { get }
  var descriptionNumberOfLines: Int { get }
  
  func toggleFavorite()
}
