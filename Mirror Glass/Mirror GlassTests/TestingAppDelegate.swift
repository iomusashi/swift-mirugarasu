//
//  TestingAppDelegate.swift
//  Mirror GlassTests
//
//  Created by インヤキ on 6/2/22.
//

import Foundation
import UIKit

@testable import Mirror_Glass

@objc(TestingAppDelegate)
class TestingAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
    [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    print("<< Launching with testing app delegate")
    
    App.shared.bootstrap(with: application, launchOptions: launchOptions)
    
    return true
  }
}
