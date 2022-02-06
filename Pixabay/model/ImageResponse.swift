//
//  Image.swift
//  Pixabay
//
//  Created by Askar on 03.02.2022.
//

import Foundation

struct ImageResponse: Codable {
    var total: Int
    var totalHits: Int
    var hits: [ImageHit]
}

struct ImageHit: Codable {
    var previewURL: String
    var largeImageURL: String
}
