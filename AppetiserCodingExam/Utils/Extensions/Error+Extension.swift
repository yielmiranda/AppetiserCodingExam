//
//  Error+Extension.swift
//  AppetiserCodingExam
//
//  Created by Marielle on 5/8/20.
//

import UIKit
import SwiftyJSON

enum APIClientError: Error {
    case CouldNotDecodeJSON
    case CouldNotRetrieveImage
    case RequestError(Error)
    case ApiError(ApiError)
}

extension APIClientError: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .CouldNotDecodeJSON:
            return "Could not decode JSON"
        case .CouldNotRetrieveImage:
            return "No image retrieve image from response"
        case let .RequestError(error):
            return error.localizedDescription
        case let .ApiError(error):
            return error.message
        }
    }
    
    var code: String {
        switch self {
        case let .ApiError(error):
            return error.code
        default:
            return ""
        }
    }
}
