//
//  ManagedObjectSerializing.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import CoreData
import Foundation

/*!
 Serializes an `APIModel` into an NSManagedObject equivalent by reflection using the `Mirror` API
 */
protocol ManagedObjectSerializing {
  static var entityName: String { get }
  func asManagedObject(context: NSManagedObjectContext) -> NSManagedObject?
}

extension ManagedObjectSerializing {
  static var entityName: String {
    return String(
      format: "%@Entity",
      String(describing: Self.self)
    )
  }
  
  func asManagedObject(context: NSManagedObjectContext) -> NSManagedObject? {
    let entityName = type(of: self).entityName
    
    guard
      let entityDescription = NSEntityDescription.entity(
        forEntityName: entityName,
        in: context
      )
    else { return nil }
    
    let mo = NSManagedObject(entity: entityDescription, insertInto: context)
    let mirror = Mirror(reflecting: self)
    
    guard mirror.displayStyle == Mirror.DisplayStyle.struct else { return nil }
    for case let (key?, value) in mirror.children {
      guard let unwrapped = Self.unwrap(value) else { continue }
      mo.setValue(unwrapped, forKey: key)
    }
    return mo
  }
  
  static func unwrap(_ any: Any) -> Any? {
    let mi = Mirror(reflecting: any)
    if mi.displayStyle != .optional {
      return any
    }
    if mi.children.count == 0 { return nil }
    let (_, some) = mi.children.first!
    return some
  }
}
