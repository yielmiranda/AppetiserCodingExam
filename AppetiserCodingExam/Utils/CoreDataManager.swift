//
//  CoreDataManager.swift
//  AppetiserCodingExam
//
//  Created by Marielle on 5/8/20.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa

struct EntityInfo {
  var name = ""
  var attributeValues = [String: AnyObject]()
}

final class CoreDataManager: NSObject {
  
  //MARK: - Properties
  
  static var persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    let container = NSPersistentContainer(name: "AppetiserCodingExam")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        
        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  static var managedObjectContext: NSManagedObjectContext {
    get {
      return self.persistentContainer.viewContext
    }
  }
  
  //MARK: - Methods
  
  //MARK: Saving
  
  static func saveContext() -> Completable {
    return Completable.create { (completable) -> Disposable in
      let context = persistentContainer.viewContext
      if context.hasChanges {
        do {
          try context.save()
          completable(.completed)
        } catch let error {
          completable(.error(error))
        }
      }
      
      return Disposables.create()
    }
  }
    
  static func saveEntity(withEntityInfo infos: [EntityInfo]) -> Completable {
    return Completable.create { (completable) -> Disposable in
      do {
        for info in infos {
          let entity = NSEntityDescription.insertNewObject(forEntityName: info.name, into: managedObjectContext)
          
          for key in info.attributeValues.keys {
            entity.setValue(info.attributeValues[key], forKey: key)
          }
          try managedObjectContext.save()
        }
        completable(.completed)
      } catch let error {
        completable(.error(error))
      }
      
      return Disposables.create()
    }
  }
  
  //MARK: Fetching
  
    static func fetchEntities<T: NSManagedObject>(entity: T.Type, sortDescriptors: [NSSortDescriptor]? = nil, predicate: NSPredicate? = nil) -> Observable<[T]> {
    return Observable.create({ (observer) -> Disposable in
        let entityName = String(describing: entity)
        let request = NSFetchRequest<T>(entityName: entityName)
        
        if let sortDescriptors = sortDescriptors {
            request.sortDescriptors = sortDescriptors
        }
        
        if let predicate = predicate {
            request.predicate = predicate
        }
          
        do {
          observer.onNext(try managedObjectContext.fetch(request))
          observer.onCompleted()
        } catch {
          observer.onError(error)
        }
        
        return Disposables.create()
    })
  }
  
  //MARK: Deleting
    
  static func delete(entity: NSManagedObject) {
    managedObjectContext.delete(entity)
  }
  
  static func deleteAllEntities<T: NSManagedObject>(entity: T.Type) -> Completable {
    
    return fetchEntities(entity: entity)
      .map({ (entities) -> [T] in
          for entity in entities {
            managedObjectContext.delete(entity)
          }
        try managedObjectContext.save()
        return entities
      })
      .ignoreElements()
  }
}
