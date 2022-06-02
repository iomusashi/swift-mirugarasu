//
//  CoreData.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import CoreData
import Foundation

protocol PersistentStack {
  
  static var stack: CoreData { get }
  
  var persistentContainerName: String { get }
  var persistentContainer: NSPersistentContainer { get }
  var saveContext: NSManagedObjectContext { get }
  
  func save()
}

class CoreData: PersistentStack {
  
  static var stack: CoreData = {
    return CoreData()
  }()
  
  var persistentContainerName: String {
    return "mirrorglass.0.0.3"
  }
  
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: persistentContainerName)
    container.loadPersistentStores(completionHandler: { description, error in
      if let error = error as NSError? {
        print("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  /// Context to query objects
  lazy var viewContext: NSManagedObjectContext = {
    return persistentContainer.viewContext
  }()
  
  /// Context to save objects
  lazy var saveContext: NSManagedObjectContext = {
    return persistentContainer.newBackgroundContext()
  }()
  
  // MARK: – Core Data Saving support
  func save() {
    guard saveContext.hasChanges else {
      fatalError()
      return
    }
    do {
      try saveContext.save()
    } catch {
      guard let error = error as NSError? else { return }
      print("Unresolved error \(error), \(error.userInfo)")
      fatalError()
    }
  }
}
