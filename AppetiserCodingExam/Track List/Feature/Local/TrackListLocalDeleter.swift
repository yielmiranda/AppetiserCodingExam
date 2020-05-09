//
//  TrackListLocalDeleter.swift
//  AppetiserCodingExam
//
//  Created by Marielle on 5/8/20.
//

import UIKit
import RxSwift

protocol TrackListLocalDeleter {
    func deleteAll() -> Completable
}

public class DefaultTrackListLocalDeleter: TrackListLocalDeleter {
    
    //MARK: - Methods
    
    /**
    For deleting all existing records in the local storage
    
    - Returns: a Completable
    */
    func deleteAll() -> Completable {
        return CoreDataManager.deleteAllEntities(entity: TrackEntity.self)
    }
}

