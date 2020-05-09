//
//  JSONDecodable.swift
//  AppetiserCodingExam
//
//  Created by Marielle on 5/8/20.
//

import Foundation
import RxSwift
import SwiftyJSON

protocol JSONDecodable {
    init?(json: JSON)
}

func decode<T: JSONDecodable>(json: JSON) -> T? {
    return T(json: json)
}

func decodeObjects<T: JSONDecodable>(json: Observable<JSON>) -> Observable<T> {
    return json.map { json in
        guard let object: T = decode(json: json) else {
            throw APIClientError.CouldNotDecodeJSON
        }
        
        return object
    }
}
