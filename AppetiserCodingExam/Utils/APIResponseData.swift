//
//  APIResponseData.swift
//  AppetiserCodingExam
//
//  Created by Marielle on 5/8/20.
//
//
import UIKit
import SwiftyJSON

struct ApiResponse {
    var data: AnyObject!
}

struct  ApiError {
    var code: String!
    var message: String!
}

extension ApiResponse: JSONDecodable {
    init?(json: JSON) {
        self.data = json as AnyObject
    }
}
