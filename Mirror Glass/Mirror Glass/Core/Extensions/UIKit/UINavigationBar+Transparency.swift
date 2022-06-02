//
//  UINavigationBar+Transparency.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation
import UIKit

extension UINavigationBar {
  func setTransparent() {
    setBackgroundImage(UIImage(), for: .default)
    shadowImage = UIImage()
    barTintColor = .clear
    isTranslucent = true
  }
  
  func setNonTransparent() {
    setBackgroundImage(nil, for: .default)
    shadowImage = nil
    barTintColor = .white
    isTranslucent = true
  }
  
  func removeShadowImage() {
    shadowImage = UIImage()
  }
  
  func addShadowImage() {
    shadowImage = nil
  }
}
