//
//  TrackDetailsViewController.swift
//  AppetiserCodingExam
//
//  Created by Marielle on 5/8/20.
//

import UIKit
import RxSwift
import RxCocoa

class TrackDetailsViewController: UIViewController {

    //MARK: - Properties
    
    @IBOutlet weak var artworkImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var track: Track!
    
    private var viewModel: TrackDetailsViewModel!
    private var disposeBag: DisposeBag!
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = TrackDetailsViewModel()
        disposeBag = DisposeBag()
        
        setupObservables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if disposeBag == nil {
            disposeBag = DisposeBag()
            setupObservables()
        }
        
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disposeBag = nil
    }
    
    //MARK: - Methods
    
    private func setupView() {
        guard let _ = track.trackName else {
            viewModel.loadTrackDetails(trackId: track.trackId)
            return
        }
        
        artworkImageView.loadImage(imageUrl: track.artworkUrl100)
        
        titleLabel.text = track.trackName
        genreLabel.text = track.primaryGenreName
        priceLabel.text = track.currency + " \(track.trackPrice ?? 0)"
        
        descriptionLabel.text = track.longDescription
    }
    
    private func setupObservables() {
        viewModel.track.subscribe(onNext: { (track) in
            self.setSelectedTrack(track: track)
        }).disposed(by: disposeBag)
        
        viewModel.trackDetailsFetchError.subscribe(onNext: { (error) in
            self.displayError(message: error)
        }).disposed(by: disposeBag)
    }
    
    private func displayError(message: String) {
        guard message != "" else { return }
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setSelectedTrack(track: Track?) {
        guard let selectedTrack = track else { return }
        
        self.track = selectedTrack
        self.setupView()
    }
}
