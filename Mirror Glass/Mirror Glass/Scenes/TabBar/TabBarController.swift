//
//  TabBarController.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

class TabBarController: UITabBarController {
  var viewModel: TabBarViewModelProtocol!
  var controllers: [UIViewController] = []
  var setupFlag: Bool = false
}

// MARK: - Lifecycle

extension TabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    bind()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupTabItems()
  }
}

// MARK: - Setup

private extension TabBarController {
  func setup() {
    view.backgroundColor = R.color.background()
    viewControllers = []
    setupTabBarAppearance()
    setupTabBarItemAppearance()
  }
  
  func setupTabBarAppearance() {
    let appearance = UITabBarAppearance()
    appearance.backgroundEffect = UIBlurEffect(style: .systemThinMaterial)
    tabBar.standardAppearance = appearance
    tabBar.scrollEdgeAppearance = appearance
    tabBar.isTranslucent = true
  }
  
  func setupTabBarItemAppearance() {
    let appearance = UITabBarItemAppearance()
    appearance.normal.iconColor = R.color.tabInactive()
    appearance.normal.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: R.color.tabInactive()!
    ]
    
    appearance.selected.iconColor = R.color.accentColor()
    appearance.selected.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: R.color.accentColor()!
    ]
    tabBar.standardAppearance.stackedLayoutAppearance = appearance
    tabBar.scrollEdgeAppearance?.stackedLayoutAppearance = appearance
  }
  
  func setupTabItems() {
    guard !setupFlag else { return }
    setupHome()
    setupFavorites()
    setupHistory()
    setupAbout()
    setupTabBar()
    setupFlag = true
  }
  
  func setupHome() {
    let homeController = HomeController()
    homeController.viewModel = viewModel.homeViewModel
    homeController.onSearchButtonTapped = { [weak self] in
      self?.navigateToSearch()
    }
    let homeNav = createNavigation(
      withRoot: homeController,
      title: "Home",
      image: UIImage(systemName: "house.fill")!
    )
    controllers.append(homeNav)
  }
  
  func setupFavorites() {
    let favoritesController = FavoritesController()
    favoritesController.viewModel = viewModel.favoritesViewModel
    let favNav = createNavigation(
      withRoot: favoritesController,
      title: "Favorites",
      image: UIImage(systemName: "heart.fill")!
    )
    controllers.append(favNav)
  }
  
  func setupHistory() {
    let historyController = HistoryController()
    historyController.viewModel = viewModel.historyViewModel
    let hisNav = createNavigation(
      withRoot: historyController,
      title: "History",
      image: UIImage(systemName: "clock.fill")!
    )
    controllers.append(hisNav)
  }
  
  func setupAbout() {
    let aboutController = AboutController()
    aboutController.viewModel = viewModel.aboutViewModel
    let aboutNav = createNavigation(
      withRoot: aboutController,
      title: "About",
      image: UIImage(systemName: "questionmark.circle.fill")!
    )
    controllers.append(aboutNav)
  }
  
  func setupTabBar() {
    setViewControllers(controllers, animated: true)
  }
}

// MARK: - Bindings

private extension TabBarController {
  func bind() {
  }
}

// MARK: - Router

private extension TabBarController {
  func navigateToSearch() {
    let searchController = SearchController()
    searchController.viewModel = viewModel.searchViewModel
    navigationController?.pushViewController(searchController, animated: true)
  }
}

// MARK: - Event Handlers

private extension TabBarController {
//  func handleSomeSuccess() -> VoidResult {
//    return { [weak self] in
//      guard let s = self else { return }
//      // TODO: Do something here
//    }
//  }
}

// MARK: - Helpers

private extension TabBarController {
  func createNavigation(
    withRoot rootViewController: UIViewController,
    title: String,
    image: UIImage
  ) -> UIViewController {
    let nc = UINavigationController(rootViewController: rootViewController)
    nc.tabBarItem.title = title
    nc.tabBarItem.image = image
    nc.navigationBar.prefersLargeTitles = false
    rootViewController.navigationItem.title = title
    return nc
  }
}
