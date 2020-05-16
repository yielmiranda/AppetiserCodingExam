//
//  TrackDetailsViewModel.swift
//  AppetiserCodingExam
//
//  Created by Marielle on 5/9/20.
//

import UIKit
import RxSwift
import RxCocoa

class TrackDetailsViewModel: NSObject {
    
    //MARK: - Properties
    
    var trackDetailsLoader: TrackDetailsLoader!
    let track: BehaviorRelay<Track?> = BehaviorRelay(value: nil)
    let trackDetailsFetchError: BehaviorRelay<String> = BehaviorRelay(value: "")
    let trackImage: BehaviorRelay<UIImage> = BehaviorRelay(value: UIImage(named: "artworkPlaceholder")!)
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Init
    
    override init() {
        let localLoader = DefaultTrackDetailsLocalLoader()
        let remoteLoader = DefaultTrackDetailsRemoteLoader(apiService: APIManager.shared)
        
        trackDetailsLoader = DefaultTrackDetailsLoader(localLoader: localLoader, remoteLoader: remoteLoader)
    }
    
    //MARK: - Methods
    
    //MARK: Public
    
    /**
     For loading Track data from local storage (when loading the last screen the user was on)
     
     - Parameter trackId: identifier of the Track
     */
    func loadTrackDetails(trackId: Int) {
        trackDetailsLoader.load(trackId: trackId).subscribe(onNext: { (track) in
            self.onLoadTrackDetailsSuccess(track: track)
        }, onError: { (error) in
            self.onLoadTrackDetailsFailure(error: error)
        }).disposed(by: disposeBag)
    }
    
    /**
    For downloading Track Image from the given Image Url or cache (if it's already downloaded)
     
    - Parameter imageUrl: url string where the image will be downloaded from
    - Returns: a UIImage
    */
    func loadTrackImage(imageUrl: String) -> UIImage {
        if let image = loadTrackImageFromCache(imageUrl: imageUrl) {
            return image
        }
        
        trackDetailsLoader.downloadTrackImage(imageUrl: imageUrl).subscribe(onNext: { (image) in
            self.trackImage.accept(image)
        }, onError: { (error) in
            
        }).disposed(by: disposeBag)
        
        return UIImage(named: "artworkPlaceholder")!
    }
    
    //MARK: Private
    
    private func onLoadTrackDetailsSuccess(track: Track) {
        self.track.accept(track)
    }
    
    private func onLoadTrackDetailsFailure(error: Error) {
        self.trackDetailsFetchError.accept(error.localizedDescription)
    }
    
    private func loadTrackImageFromCache(imageUrl: String) -> UIImage? {
        return APIManager.shared.loadImageFromCache(imageUrl: imageUrl)
    }
}
