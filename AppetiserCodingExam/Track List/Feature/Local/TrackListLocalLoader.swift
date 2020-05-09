//
//  TrackListLocalLoader.swift
//  AppetiserCodingExam
//
//  Created by Marielle on 5/8/20.
//

import UIKit
import RxSwift

protocol TrackListLocalLoader {
    func load() -> Observable<[Track]>
}

public class DefaultTrackListLocalLoader: TrackListLocalLoader {
    
    //MARK: - Methods
    
    //MARK: Public

    /**
    For loading Track List data from the local storage

    - Returns: an Observable of element Array of Tracks
    */
    func load() -> Observable<[Track]> {
      return CoreDataManager.fetchEntities(entity: TrackEntity.self)
          .flatMap(transformToTracks)
          .flatMap({ tracks -> Observable<[Track]> in
              return Observable.just(tracks)
        })
      
    }
  
    //MARK: Private
    
    /**
    For converting array of TrackEntity to Track data
    
    - Parameter trackEntities: array of TrackEntity fetched from local storage
    - Returns: an Observable of element Array of Tracks
    */
    private func transformToTracks(trackEntities: [TrackEntity]) -> Observable<[Track]> {
      var tracks = [Track]()
      for entity in trackEntities {
          var track = Track()
          track.trackId = Int(entity.trackId)
          track.trackName = entity.trackName
          track.primaryGenreName = entity.primaryGenreName
          track.currency = entity.currency
          track.trackPrice = entity.trackPrice
          track.artworkUrl100 = entity.artworkUrl
          track.longDescription = entity.longDescription
          
          tracks.append(track)
      }
      
      return Observable.just(tracks)
    }
}
