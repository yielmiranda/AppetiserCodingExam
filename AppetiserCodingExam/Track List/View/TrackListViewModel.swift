//
//  TrackListViewModel.swift
//  AppetiserCodingExam
//
//  Created by Marielle on 5/8/20.
//

import UIKit
import RxSwift
import RxCocoa

class TrackListViewModel: NSObject {
    
    //MARK: - Properties
    
    let isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var trackListLoader: TrackListLoader!
    let trackList: BehaviorRelay<[Track]> = BehaviorRelay(value: [])
    let trackListServiceError: BehaviorRelay<String> = BehaviorRelay(value: "")
    let shouldReloadTableIndex: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Init
    
    override init() {
        let localLoader = DefaultTrackListLocalLoader()
        let localDeleter = DefaultTrackListLocalDeleter()
        let localSaver = DefaultTrackListLocalSaver()
        let remoteLoader = DefaultTrackListRemoteLoader(apiService: APIManager.shared)
        
        trackListLoader = DefaultTrackListLoader(localLoader: localLoader,
                            remoteLoader: remoteLoader, localDeleter: localDeleter,
                            localSaver: localSaver)
    }
    
    //MARK: - Methods
    
    //MARK: Public
    
    /**
    For loading Track List data from either remote or local storage
    */
    func loadTrackList() {
        guard trackList.value.count == 0 else { return }
        
        isLoading.accept(true)
        
        trackListLoader.load().subscribe(onNext: { (tracks) in
            self.onLoadTrackListSuccess(tracks: tracks)
        }, onError: { (error) in
            self.onLoadTrackListFailure(error: error)
        }).disposed(by: disposeBag)
    }
    
    /**
    For downloading Track Image from the given Image Url or cache (if it's already downloaded)
     
    - Parameter imageUrl: url string where the image will be downloaded from
    - Parameter index: to identify the indexPath of the cell to be reloaded after downloading
    - Returns: a UIImage
    */
    func loadTrackImage(track: Track, index: Int) -> UIImage? {
        let imageUrl = track.artworkUrl100 ?? ""
        if let image = loadTrackImageFromCache(imageUrl: imageUrl) {
            return image
        }
        
        trackListLoader.downloadTrackImage(imageUrl: imageUrl).subscribe(onNext: { (image) in
            self.shouldReloadTableIndex.accept(index)
        }, onError: { (error) in
            
        }).disposed(by: disposeBag)
        
        return nil
    }
    
    //MARK: Private
    
    private func onLoadTrackListSuccess(tracks: [Track]) {
        self.trackList.accept(tracks)
        self.isLoading.accept(false)
    }
    
    private func onLoadTrackListFailure(error: Error) {
        let apiError = error as! APIClientError
        self.trackListServiceError.accept(apiError.debugDescription)
        
        self.isLoading.accept(false)
    }
    
    private func loadTrackImageFromCache(imageUrl: String) -> UIImage? {
        return APIManager.shared.loadImageFromCache(imageUrl: imageUrl)
    }
}
