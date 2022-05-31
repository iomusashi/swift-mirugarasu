//
//  ContextFetchability.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import CoreData
import Foundation

/*!
 Context fetching utility functions
 */
protocol ContextFetchability {
  func findAll<T: NSManagedObject>(
    _ entityClass: T.Type,
    predicate: NSPredicate?,
    sortDescriptors: [NSSortDescriptor]?
  ) -> [T]
  
  func findFirst<T: NSManagedObject>(
    _ entityClass: T.Type,
    predicate: NSPredicate?
  ) -> T?
  
  func findFirst<T: NSManagedObject>(
    _ entityClass: T.Type,
    withId id: Int64
  ) -> T?
}

extension NSManagedObjectContext: ContextFetchability {
  func findAll<T>(
    _ entityClass: T.Type,
    predicate: NSPredicate? = nil,
    sortDescriptors: [NSSortDescriptor]? = nil
  ) -> [T] where T : NSManagedObject {
    let request = entityClass.fetchRequest() as! NSFetchRequest<T>
    request.predicate = predicate
    request.sortDescriptors = sortDescriptors
    do {
      let result = try fetch(request)
      return result
    } catch {
      return []
    }
  }
  
  func findFirst<T>(
    _ entityClass: T.Type,
    predicate: NSPredicate? = nil
  ) -> T? where T : NSManagedObject {
    let request = entityClass.fetchRequest() as! NSFetchRequest<T>
    request.predicate = predicate
    do {
      let result = try fetch(request)
      return result.first
    } catch {
      return nil
    }
  }
  
  func findFirst<T>(
    _ entityClass: T.Type,
    withId id: Int64
  ) -> T? where T : NSManagedObject {
    let request = entityClass.fetchRequest() as! NSFetchRequest<T>
    request.predicate = NSPredicate(format: "id == %@", id)
    do {
      let result = try fetch(request)
      return result.first
    } catch {
      return nil
    }
  }
}
