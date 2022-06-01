//
//  UIViewController+Dismiss.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import UIKit

extension UIViewController {
  var isPresentedModally: Bool {
    return presentingViewController != nil ||
    navigationController?.presentingViewController?.presentedViewController === navigationController ||
    tabBarController?.presentingViewController is UITabBarController
  }
}
