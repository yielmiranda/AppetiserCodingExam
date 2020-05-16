//
//  TrackDetailsLocalLoader.swift
//  AppetiserCodingExam
//
//  Created by Marielle on 5/9/20.
//

import UIKit
import RxSwift

protocol TrackDetailsLocalLoader {
    func load(trackId: Int) -> Observable<Track>
}

public class DefaultTrackDetailsLocalLoader: TrackDetailsLocalLoader {
    
    //MARK: - Methods
    
    //MARK: Public
    
    /**
    For loading Track data from local storage (when loading the last screen the user was on)
    
    - Parameter trackId: identifier of the Track
    - Returns: an Observable of element Track
    */
     func load(trackId: Int) -> Observable<Track> {
        let predicate = NSPredicate(format: "trackId = %d", trackId)
        
        return CoreDataManager.fetchEntities(entity: TrackEntity.self, predicate: predicate)
            .flatMap(transformToTrack)
            .flatMap({ track -> Observable<Track> in
                return Observable.just(track)
          })
    }
  
    //MARK: Private
    
    /**
    For converting TrackEntity to Track data
    
    - Parameter trackEntities: array of TrackEntity fetched from local storage
    - Returns: an Observable of element Track
    */
    private func transformToTrack(trackEntities: [TrackEntity]) -> Observable<Track> {
      let trackEntity = trackEntities.first!
      
      var track = Track()
      track.trackId = Int(trackEntity.trackId)
      track.trackName = trackEntity.trackName
      track.primaryGenreName = trackEntity.primaryGenreName
      track.currency = trackEntity.currency
      track.trackPrice = trackEntity.trackPrice
      track.artworkUrl100 = trackEntity.artworkUrl
      track.longDescription = trackEntity.longDescription
      
      return Observable.just(track)
    }
}
