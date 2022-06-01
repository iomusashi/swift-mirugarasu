//
//  TabBarViewModel.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation

class TabBarViewModel: TabBarViewModelProtocol {}

// MARK: - Methods

extension TabBarViewModel {}

// MARK: - Getters

extension TabBarViewModel {
  var homeViewModel: HomeViewModelProtocol { HomeViewModel() }
  var favoritesViewModel: FavoritesViewModelProtocol { FavoritesViewModel() }
  var historyViewModel: HistoryViewModelProtocol { HistoryViewModel() }
  var aboutViewModel: AboutViewModelProtocol { AboutViewModel() }
  var searchViewModel: SearchViewModelProtocol { SearchViewModel() }
}
