//
//  BaseController.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import UIKit

class BaseController: UIViewController {
  enum CloseButtonPosition {
    case left, right
  }
  
  var preferredCloseButtonPosition: CloseButtonPosition { .left }
  var shouldSetNavBarTransparent: Bool { true }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationTitle()
    setupNavigationItems()
    loadNavigationBarAppearancePreferences()
    view.backgroundColor = R.color.background()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shouldSetNavBarTransparent {
      navigationController?.navigationBar.setTransparent()
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if shouldSetNavBarTransparent {
      navigationController?.navigationBar.setNonTransparent()
    }
  }
  
  func setupNavigationTitle() {
    navigationController?.navigationBar.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor : UIColor.clear
    ]
    navigationController?.navigationBar.isTranslucent = true
  }

  /// A place for adding your custom navigation bar buttons.
  ///
  /// By default, a custom **Back** button will appear on the left side of the navigation bar
  /// if this controller isn't the root of its `navigationController`. On the other hand,
  /// if it's presented modally, we show a **Close** button.
  ///
  /// This method is called inside `viewDidLoad`.
  ///
  func setupNavigationItems() {
    if navigationController?.viewControllers.first != self {
      let backButton = UIBarButtonItem(
        image: UIImage(systemName: "arrow.left"),
        style: .plain,
        target: self,
        action: #selector(backButtonTapped(_:))
      )
      backButton.tintColor = R.color.navTitleColor()!
      navigationItem.leftBarButtonItem = backButton
      
      // Fix for bug where swiping from left to right to go back is gone.
      // The bug is the side effect for setting custom `leftBarButtonItem`.
      navigationController?.interactivePopGestureRecognizer?.delegate = self
    } else if isPresentedModally {
      let button = UIBarButtonItem(
        image: UIImage(systemName: "xmark"),
        style: .plain,
        target: self,
        action: #selector(backButtonTapped(_:))
      )
      button.tintColor = R.color.accentColor()
      if preferredCloseButtonPosition == .left {
        navigationItem.leftBarButtonItem = button
      } else {
        navigationItem.rightBarButtonItem = button
      }
    }
  }
  
  func loadNavigationBarAppearancePreferences() {
    let navigationBarAppearance = UINavigationBarAppearance()
    navigationBarAppearance.configureWithTransparentBackground()
    navigationBarAppearance.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor : UIColor.clear
    ]
    UINavigationBar.appearance().standardAppearance = navigationBarAppearance
    UINavigationBar.appearance().compactAppearance = navigationBarAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
  }
  
  @IBAction
  func backButtonTapped(_ sender: AnyObject) {
    if navigationController?.viewControllers.first != self {
      navigationController?.popViewController(animated: true)
    } else if isPresentedModally {
      dismiss(animated: true, completion: nil)
    }
  }
}

// MARK: - UIGestureRecognizerDelegate

extension BaseController: UIGestureRecognizerDelegate {
  func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer
  ) -> Bool {
    return true
  }
}
