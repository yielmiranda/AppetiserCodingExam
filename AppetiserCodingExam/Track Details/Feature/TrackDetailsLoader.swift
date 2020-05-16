//
//  TrackDetailsLoader.swift
//  AppetiserCodingExam
//
//  Created by cybilltek on 5/17/20.
//

import UIKit
import RxSwift

protocol TrackDetailsLoader {
    func load(trackId: Int) -> Observable<Track>
    func downloadTrackImage(imageUrl: String) -> Observable<UIImage>
}

public class DefaultTrackDetailsLoader: TrackDetailsLoader {

    //MARK: - Properties
      
    private var localLoader: TrackDetailsLocalLoader
    private var remoteLoader: TrackDetailsRemoteLoader

    //MARK: - Init
      
    init(localLoader: TrackDetailsLocalLoader,
         remoteLoader: TrackDetailsRemoteLoader) {
      self.localLoader = localLoader
      self.remoteLoader = remoteLoader
    }
    
    //MARK: - Methods
    
    //MARK: Public
    
    /**
    For loading Track data from local storage (when loading the last screen the user was on)
    
    - Parameter trackId: identifier of the Track
    - Returns: an Observable of element Track
    */
     func load(trackId: Int) -> Observable<Track> {
        return localLoader.load(trackId: trackId)
    }
    
    /**
     For downloading Track Image from the given Image Url
      
     - Parameter imageUrl: url string where the image will be downloaded from
     - Returns: an Observable of element UIImage
     */
     func downloadTrackImage(imageUrl: String) -> Observable<UIImage> {
        return remoteLoader.downloadTrackImage(imageUrl: imageUrl)
     }
}
