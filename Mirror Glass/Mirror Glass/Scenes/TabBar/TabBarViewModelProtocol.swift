//
//  TabBarViewModelProtocol.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation

protocol TabBarViewModelProtocol {
  var homeViewModel: HomeViewModelProtocol { get }
  var favoritesViewModel: FavoritesViewModelProtocol { get }
  var historyViewModel: HistoryViewModelProtocol { get }
  var aboutViewModel: AboutViewModelProtocol { get }
  var searchViewModel: SearchViewModelProtocol { get }
}
