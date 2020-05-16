//
//  TrackListLoader.swift
//  AppetiserCodingExam
//
//  Created by Marielle on 5/8/20.
//

import UIKit
import RxSwift

protocol TrackListLoader {
    func load() -> Observable<[Track]>
    func downloadTrackImage(imageUrl: String) -> Observable<UIImage>
}

public class DefaultTrackListLoader: TrackListLoader {

    //MARK: - Properties
      
    private var localLoader: TrackListLocalLoader
    private var remoteLoader: TrackListRemoteLoader
    private var localDeleter: TrackListLocalDeleter
    private var localSaver: TrackListLocalSaver

    //MARK: - Init
      
    init(localLoader: TrackListLocalLoader,
         remoteLoader: TrackListRemoteLoader,
         localDeleter: TrackListLocalDeleter,
         localSaver: TrackListLocalSaver) {
      self.localLoader = localLoader
      self.remoteLoader = remoteLoader
      self.localDeleter = localDeleter
      self.localSaver = localSaver
    }
    
    //MARK: - Methods
    
    //MARK: Public
    
    /**
    For loading Track List data from either remote or local storage (Will check first if there are data available on the local storage before proceeding with the API call)
    
    - Returns: an Observable of element Array of Tracks
    */
    
    func load() -> Observable<[Track]> {
        localLoader.load()
            .flatMap({ tracks -> Observable<[Track]> in
                if tracks.count > 0 {
                    return Observable.just(tracks)
                } else {
                    return self.remoteLoader.load().flatMap(self.saveToDatabase)
                }
        })
    }
    
    /**
    For downloading Track Image from the given Image Url
     
    - Parameter imageUrl: url string where the image will be downloaded from
    - Returns: an Observable of element UIImage
    */
    func downloadTrackImage(imageUrl: String) -> Observable<UIImage> {
        return remoteLoader.downloadTrackImage(imageUrl: imageUrl)
    }
    
    //MARK: Private
    
    /**
    For saving Track List data from the web service to local storage
    
    - Parameter items: array of the Tracks to be save to Core Data
    - Returns: an Observable of element Array of Tracks
    */
    private func saveToDatabase(items: [Track]) -> Observable<[Track]> {
      return localDeleter.deleteAll()
        .andThen(localSaver.save(list: items))
        .andThen(Observable.just(items))
    }
}
