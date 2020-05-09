//
//  TrackListAlamofireService.swift
//  AppetiserCodingExam
//
//  Created by Marielle on 5/8/20.
//

import UIKit

public class TrackListAlamofireService: Request {
    var path = "search"
    var method = RequestMethod.GET
    var parameters: [String : AnyObject]!
    
    func load() -> Request {
        self.parameters = [String: AnyObject]()
        self.parameters["term"] = "star" as AnyObject
        self.parameters["country"] = "au" as AnyObject
        self.parameters["media"] = "movie" as AnyObject
        
        return self
    }
}
