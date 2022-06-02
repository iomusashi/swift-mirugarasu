//
//  main.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/2/22.
//

import Foundation
import UIKit

let appDelegateClass: AnyClass =
NSClassFromString("TestingAppDelegate") ?? AppDelegate.self

UIApplicationMain(
  CommandLine.argc,
  CommandLine.unsafeArgv,
  nil,
  NSStringFromClass(appDelegateClass)
)
