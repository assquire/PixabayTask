//
//  Hit.swift
//  Pixabay
//
//  Created by Askar on 03.02.2022.
//

import Foundation

struct VideoResponse: Codable {
    var total: Int
    var totalHits: Int
    var hits: [VideoHit]
}

struct VideoHit: Codable {
    var videos: VideoURLS
}

struct VideoURLS: Codable {
    var medium: Medium
}

struct Medium: Codable {
    var url: String
}
