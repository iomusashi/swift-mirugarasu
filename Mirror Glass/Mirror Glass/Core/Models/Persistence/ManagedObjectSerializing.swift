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
  
  static func unwrap(_ any: Any) -> Any? {
    let mi = Mirror(reflecting: any)
    if any is ModelID<Track> { return (any as! ModelID<Track>).rawValue }
    if any is Track.Kind { return (any as! Track.Kind).rawValue }
    if mi.displayStyle != .optional {
      return any
    }
    if mi.children.count == 0 { return nil }
    let (_, some) = mi.children.first!
    return some
  }
}
