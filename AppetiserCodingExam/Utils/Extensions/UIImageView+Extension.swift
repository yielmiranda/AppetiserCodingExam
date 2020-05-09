//
//  UIImageView+Extension.swift
//  AppetiserCodingExam
//
//  Created by Marielle on 5/8/20.
//

import UIKit
import RxSwift

extension UIImageView {
    static var disposeBag = DisposeBag()
    
    func loadImage(imageUrl: String) {
        guard imageUrl != "" else { return }
        
        let imageDownloadService = TrackArtworkAlamofireService()
        imageDownloadService.path = imageUrl
        
        APIManager.shared.performDownloadImageRequest(request: imageDownloadService)
            .subscribe(onNext: { (image) in
                self.image = image
            }, onError: { (error) in
                self.image = UIImage(named: "artworkPlaceholder") ?? nil
        }).disposed(by: UIImageView.disposeBag)
    }
}
