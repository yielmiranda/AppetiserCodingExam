//
//  TrackListTableViewController.swift
//  AppetiserCodingExam
//
//  Created by Marielle on 5/8/20.
//

import UIKit
import RxSwift
import RxCocoa

class TrackListTableViewController: UITableViewController {

    //MARK: - Properties
    
    private var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: TrackListViewModel!
    private var disposeBag: DisposeBag!
    
    private var selectedTrack: Track!
    
    var dateLastVisited: NSDate! //for the date indicated on the header of the table view
    
    //MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = TrackListViewModel()
        disposeBag = DisposeBag()
        
        setupActivityIndicator()
        setupTableView()
        setupObservables()
        
        viewModel.loadTrackList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if disposeBag == nil {
            disposeBag = DisposeBag()
            setupObservables()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disposeBag = nil
    }
    
    //MARK: - Custom
    
    func shouldShowTrackDetailsScreen(trackId: Int) {
        selectedTrack = Track()
        selectedTrack.trackId = trackId
        
        performSegue(withIdentifier: "showDetails", sender: nil)
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .darkGray
        activityIndicator.center = self.view.center
        
        self.view.addSubview(activityIndicator)
    }
    
    private func setupTableView() {
        let nibClass = UINib(nibName: "TrackListTableViewCell", bundle: .main)
        tableView.register(nibClass, forCellReuseIdentifier: "trackCell")
        
        tableView.estimatedRowHeight = 124
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupObservables() {
        viewModel.isLoading.asObservable().subscribe(onNext: { (loading) in
            self.setActivityIndicator(visibility: loading)
        }).disposed(by: disposeBag)
        
        viewModel.trackListServiceError.subscribe(onNext: { (error) in
            self.displayError(message: error)
        }).disposed(by: disposeBag)
        
        viewModel.trackList.subscribe(onNext: { (tracks) in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.shouldReloadTableIndex.subscribe(onNext: { (index) in
            self.reloadTable(index: index)
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            self.didSelectTrack(trackIndex: indexPath.row)
        }).disposed(by: disposeBag)
    }
    
    private func setActivityIndicator(visibility: Bool) {
        if visibility {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    private func displayError(message: String) {
        guard message != "" else { return }
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func reloadTable(index: Int) {
        guard self.viewModel.trackList.value.count > 0 else { return }
        
        self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }
    
    private func didSelectTrack(trackIndex: Int) {
        selectedTrack = viewModel.trackList.value[trackIndex]
        performSegue(withIdentifier: "showDetails", sender: nil)
        
        self.tableView.deselectRow(at: IndexPath(row: trackIndex, section: 0), animated: true)
    }

    //MARK: - UITableView
    
    //MARK: Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.trackList.value.count
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath) as! TrackListTableViewCell
        let track = viewModel.trackList.value[indexPath.row]
        
        cell.setupCell(track: track)
        cell.setCellImage(image: viewModel.loadTrackImage(track: track, index: indexPath.row))
        
        return cell
    }
    
    //MARK: Delegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let _ = self.dateLastVisited else { return 0 }
        
        return 30
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy HH:mm"
        let formattedDate = dateFormatter.string(from: self.dateLastVisited as Date)
        
        return "Last Viewed: \(formattedDate)"
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? TrackDetailsViewController else { return }
        
        destinationVC.track = selectedTrack
    }
}
