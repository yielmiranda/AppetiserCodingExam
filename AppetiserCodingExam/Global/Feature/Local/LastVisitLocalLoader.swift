//
//  LastVisitLocalLoader.swift
//  AppetiserCodingExam
//
//  Created by Marielle on 5/8/20.
//

import UIKit
import RxSwift

protocol LastVisitLocalLoader {
    func load() -> Observable<[LastVisit]>
}

public class DefaultLastVisitLocalLoader: LastVisitLocalLoader {
    
    //MARK: - Methods

    //MARK: Public
    
    /**
    For loading Last Visit data from the local storage to identify what screen to display the next time the user opens the app

    - Returns: an Observable of element Array of Last Visits
    */
    func load() -> Observable<[LastVisit]> {
      let sortDescriptor = NSSortDescriptor(key: "dateLastVisited", ascending: true)
      let sortDescriptors = [sortDescriptor]
      
      return CoreDataManager.fetchEntities(entity: LastVisitEntity.self,
                              sortDescriptors: sortDescriptors)
          .flatMap(transformToLastVisits)
          .flatMap({ lastVisits -> Observable<[LastVisit]> in
              return Observable.just(lastVisits)
        })
    }
    
    //MARK: - Private
    
    /**
    For converting array of LastVisitEntity to LastVisit data
    
    - Parameter lastVisitEntities: array of LastVisitEntity fetched from local storage
    - Returns: an Observable of element Array of LastVisits
    */
    private func transformToLastVisits(lastVisitEntities: [LastVisitEntity]) -> Observable<[LastVisit]> {
      var lastVisits = [LastVisit]()
      for entity in lastVisitEntities {
          var lastVisit = LastVisit()
          lastVisit.dateLastVisited = entity.dateLastVisited as NSDate?
          lastVisit.screenLastVisited = entity.screenLastVisited
          lastVisit.trackLastVisited = Int(entity.trackLastVisited)
          
          lastVisits.append(lastVisit)
      }
      
      return Observable.just(lastVisits)
    }
}
