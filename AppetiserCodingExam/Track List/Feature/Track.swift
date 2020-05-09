//
//  Track.swift
//  AppetiserCodingExam
//
//  Created by Marielle on 5/8/20.
//

import UIKit

struct Track: Codable {
    var trackId: Int!
    var trackName: String!
    var artworkUrl100: String!
    var trackPrice: Double!
    var currency: String!
    var primaryGenreName: String!
    var longDescription: String!
    
    enum CodingKeys: String, CodingKey {
        case trackId
        case trackName
        case artworkUrl100
        case trackPrice
        case currency
        case primaryGenreName
        case longDescription
    }
}
