//
//  LastVisitLocalSaver.swift
//  AppetiserCodingExam
//
//  Created by Marielle on 5/8/20.
//

import UIKit
import RxSwift

protocol LastVisitLocalSaver {
    func save(visit: LastVisit) -> Completable
}

public class DefaultLastVisitLocalSaver: LastVisitLocalSaver {
    
    //MARK: - Methods
    
    //MARK: Public
    
    /**
    For saving LastVisit data to local storage
    
    - Parameter visit: LastVisit info
    - Returns: a Completable
    */
    func save(visit: LastVisit) -> Completable {
        let entityInfo = EntityInfo(name:"LastVisitEntity",
                                    attributeValues :createLastVisitAttribute(visit: visit))
        
        return CoreDataManager.saveEntity(withEntityInfo: [entityInfo])
    }
    
    //MARK: Private
    
    /**
    For converting LastVisit data to dictionary for saving to Core Data
    
    - Parameter visit: LastVisit object to be saved
    - Returns: a Dictionary consisting of attributes for the entity to be saved
    */
  
    private func createLastVisitAttribute(visit: LastVisit) -> [String: AnyObject] {
        var attributes = [String:AnyObject]()
        attributes["dateLastVisited"] = visit.dateLastVisited as AnyObject
        attributes["screenLastVisited"] = visit.screenLastVisited as AnyObject
        attributes["trackLastVisited"] = visit.trackLastVisited as AnyObject
        
        return attributes
    }
  
  
}
