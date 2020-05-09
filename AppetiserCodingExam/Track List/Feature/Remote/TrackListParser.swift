//
//  TrackListParser.swift
//  AppetiserCodingExam
//
//  Created by Marielle on 5/8/20.
//

import UIKit
import RxSwift
import Alamofire
import SwiftyJSON

//Sturctured according to the data format of the response from the web servie
struct TrackData: Codable {
    var results: [Track]
    var resultCount: Int
      
    enum CodingKeys: String, CodingKey {
        case results
        case resultCount
    }
}
    
public class TrackListParser {
    func parse(json: JSON) -> Observable<[Track]> {
      if let apiResponse = ApiResponse(json: json) {
        if let dataJson = apiResponse.data as? JSON {
          let jsonDecoder = JSONDecoder()
          do {
            let data = try jsonDecoder.decode(TrackData.self, from: dataJson.rawData())
            return Observable.just(data.results)
          } catch _ {
            return Observable.error(APIClientError.CouldNotDecodeJSON)
          }
        }
      }
      
      return Observable.error(APIClientError.CouldNotDecodeJSON)
    }
}
