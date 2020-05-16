//
//  TrackListTableViewCell.swift
//  AppetiserCodingExam
//
//  Created by Marielle on 5/8/20.
//

import UIKit

class TrackListTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    @IBOutlet weak var artworkImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    //MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Custom
    
    func setupCell(track: Track) {
        titleLabel.text = track.trackName
        genreLabel.text = track.primaryGenreName
        priceLabel.text = track.currency + " \(track.trackPrice ?? 0)"
    }
    
    func setCellImage(image: UIImage?) {
        artworkImageView.image = image ?? UIImage(named: "artworkPlaceholder")!
    }
}
