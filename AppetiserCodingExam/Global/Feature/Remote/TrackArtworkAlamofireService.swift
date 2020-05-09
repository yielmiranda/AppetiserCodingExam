//
//  TrackArtworkAlamofireService.swift
//  AppetiserCodingExam
//
//  Created by Marielle on 5/8/20.
//

import UIKit

public class TrackArtworkAlamofireService: Request {
    var path = ""
    var method = RequestMethod.GET
    
    func load(imageUrl: String) -> Request {
        self.path = imageUrl
        
        return self
    }
}
