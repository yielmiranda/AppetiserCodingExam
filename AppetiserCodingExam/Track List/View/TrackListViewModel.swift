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
}
