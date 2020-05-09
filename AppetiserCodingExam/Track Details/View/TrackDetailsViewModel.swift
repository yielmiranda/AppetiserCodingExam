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
    
    var trackDetailsLocalLoader: TrackDetailsLocalLoader!
    let track: BehaviorRelay<Track?> = BehaviorRelay(value: nil)
    let trackDetailsFetchError: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Init
    
    override init() {
        trackDetailsLocalLoader = DefaultTrackDetailsLocalLoader()
    }
    
    //MARK: - Methods
    
    //MARK: Public
    
    /**
     For loading Track data from local storage (when loading the last screen the user was on)
     
     - Parameter trackId: identifier of the Track
     */
    func loadTrackDetails(trackId: Int) {
        trackDetailsLocalLoader.load(trackId: trackId).subscribe(onNext: { (track) in
            self.onLoadTrackDetailsSuccess(track: track)
        }, onError: { (error) in
            self.onLoadTrackDetailsFailure(error: error)
        }).disposed(by: disposeBag)
    }
    
    //MARK: Private
    
    private func onLoadTrackDetailsSuccess(track: Track) {
        self.track.accept(track)
    }
    
    private func onLoadTrackDetailsFailure(error: Error) {
        self.trackDetailsFetchError.accept(error.localizedDescription)
    }
}
