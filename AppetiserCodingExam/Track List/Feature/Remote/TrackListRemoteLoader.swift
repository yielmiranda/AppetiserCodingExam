//
//  TrackListRemoteLoader.swift
//  AppetiserCodingExam
//
//  Created by Marielle on 5/8/20.
//

import UIKit
import RxSwift

protocol TrackListRemoteLoader {
    func load() -> Observable<[Track]>
}

public class DefaultTrackListRemoteLoader: TrackListRemoteLoader {
    
    //MARK: - Properties
      
    var apiService: APIManager
    var parser: TrackListParser
    
    //MARK: - Methods
    
    //MARK: Init

    init(apiService: APIManager) {
        self.apiService = apiService
        self.parser = TrackListParser()
    }
    
    //MARK: Public
    
    /**
    For loading Track List data from remoyte web service

    - Returns: an Observable of element Array of Tracks
    */
    func load() -> Observable<[Track]> {
        return self.apiService
          .perform(request: TrackListAlamofireService().load())
          .flatMap(parser.parse)
    }
}
