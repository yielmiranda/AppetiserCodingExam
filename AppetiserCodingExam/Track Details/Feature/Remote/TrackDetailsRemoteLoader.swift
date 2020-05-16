//
//  TrackDetailsRemoteLoader.swift
//  AppetiserCodingExam
//
//  Created by cybilltek on 5/17/20.
//

import UIKit
import RxSwift

protocol TrackDetailsRemoteLoader {
    func downloadTrackImage(imageUrl: String) -> Observable<UIImage>
}

public class DefaultTrackDetailsRemoteLoader: TrackDetailsRemoteLoader {
    
    //MARK: - Properties
      
    var apiService: APIManager
    
    //MARK: - Methods
    
    //MARK: Init

    init(apiService: APIManager) {
        self.apiService = apiService
    }
    
    //MARK: Public
    
    /**
    For downloading Track Image from the given Image Url
     
    - Parameter imageUrl: url string where the image will be downloaded from
    - Returns: an Observable of element UIImage
    */
    func downloadTrackImage(imageUrl: String) -> Observable<UIImage> {
        return self.apiService
            .performDownloadImageRequest(request: TrackArtworkAlamofireService().load(imageUrl: imageUrl))
    }
}
