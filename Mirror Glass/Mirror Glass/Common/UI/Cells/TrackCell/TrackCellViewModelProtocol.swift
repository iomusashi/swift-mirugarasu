//
//  TrackCellCellViewModelProtocol.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation

protocol TrackCellViewModelProtocol {
  var trackImageUrl: URL { get }
  var title: String { get }
  var genre: String { get }
  var kind: String { get }
  var shortDescription: String { get }
  var price: String { get }
  var showChevronIcon: Bool { get }
  var showShortDescription: Bool { get }
  var showLongDescription: Bool { get }
  var descriptionNumberOfLines: Int { get }
}
