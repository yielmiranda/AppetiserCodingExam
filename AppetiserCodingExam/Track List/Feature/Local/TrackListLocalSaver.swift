//
//  TrackListLocalSaver.swift
//  AppetiserCodingExam
//
//  Created by Marielle on 5/8/20.
//

import UIKit
import RxSwift

protocol TrackListLocalSaver {
    func save(list:[Track]) -> Completable
}

public class DefaultTrackListLocalSaver: TrackListLocalSaver {
  
    //MARK: - Methods
    
    //MARK: Public
    
    /**
    For saving array of Tracks to local storage
    
    - Parameter list: array of Track fetched from remote web service
    - Returns: a Completable
    */
    func save(list: [Track]) -> Completable {
        var entities = [EntityInfo]()
        for track in list {
          let entityInfo = EntityInfo(name:"TrackEntity",
                                      attributeValues :createTrackAttribute(track: track))
          entities.append(entityInfo)
        }
        
        return CoreDataManager.saveEntity(withEntityInfo: entities)
    }
    
    //MARK: Private
    
    /**
    For converting Track data to dictionary for saving to Core Data
    
    - Parameter track: Track object to be saved
    - Returns: a Dictionary consisting of attributes for the entity to be saved
    */
    private func createTrackAttribute(track: Track) -> [String: AnyObject] {
        var attributes = [String:AnyObject]()
        attributes["trackId"] = track.trackId as AnyObject
        attributes["trackName"] = track.trackName as AnyObject
        attributes["primaryGenreName"] = track.primaryGenreName as AnyObject
        attributes["currency"] = track.currency as AnyObject
        attributes["trackPrice"] = track.trackId as AnyObject
        attributes["artworkUrl"] = track.artworkUrl100 as AnyObject
        attributes["longDescription"] = track.longDescription as AnyObject
        
        return attributes
    }
  
  
}
