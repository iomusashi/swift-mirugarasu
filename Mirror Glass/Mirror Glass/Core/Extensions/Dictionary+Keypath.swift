//
//  Dictionary+Keypath.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation

/// Access Dictionaries with Key Paths.
///
/// Let's say we have this nested Dictionary...
///
///     let dict = [
///       "parent": [
///         "child": [
///           "name": "joe"
///         ]
///       ]
///     ]
///
/// ...to access the child's name using key paths:
///
///     print(dict[keyPath: "parent.child.name"] ?? "") // joe
///
/// More info on this here: https://oleb.net/blog/2017/01/dictionary-key-paths/.
extension Dictionary {
  subscript(keyPath keyPath: String) -> Any? {
    get {
      guard let keyPath = Dictionary.keyPathKeys(forKeyPath: keyPath) else { return nil }
      return getValue(forKeyPath: keyPath)
    }
    set {
      guard let keyPath = Dictionary.keyPathKeys(forKeyPath: keyPath),
            let newValue = newValue else { return }
      setValue(newValue, forKeyPath: keyPath)
    }
  }
  
  private static func keyPathKeys(forKeyPath: String) -> [Key]? {
    let keys = forKeyPath.components(separatedBy: ".")
      .reversed().compactMap({ $0 as? Key })
    return keys.isEmpty ? nil : keys
  }
  
  // recursively (attempt to) access queried subdictionaries
  // (keyPath will never be empty here; the explicit unwrapping is safe)
  private func getValue(forKeyPath keyPath: [Key]) -> Any? {
    guard let value = self[keyPath.last!] else { return nil }
    return keyPath.count == 1 ? value : (value as? [Key: Any])
      .flatMap { $0.getValue(forKeyPath: Array(keyPath.dropLast())) }
  }
  
  // recursively (attempt to) access the queried subdictionaries to
  // finally replace the "inner value", given that the key path is valid
  private mutating func setValue(_ value: Any, forKeyPath keyPath: [Key]) {
    guard self[keyPath.last!] != nil else { return }
    if keyPath.count == 1 {
      (value as? Value).map { self[keyPath.last!] = $0 }
    } else if var subDict = self[keyPath.last!] as? [Key: Value] {
      subDict.setValue(value, forKeyPath: Array(keyPath.dropLast()))
      (subDict as? Value).map { self[keyPath.last!] = $0 }
    }
  }
}
