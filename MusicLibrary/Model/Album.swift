//
//  Album.swift
//  MusicLibrary
//
//  Created by Afiq Ramli on 20/07/2018.
//  Copyright © 2018 Afiq Ramli. All rights reserved.
//

import Foundation

struct Album {
    
    var title: String
    var artist: String
    var genre: String
    var coverUrl: String
    var year: String
    
}

extension Album: CustomStringConvertible {
    var description: String {
        return "title: \(title)" +
            " artist: \(artist)" +
            " genre: \(genre)" +
            " coverUrl: \(coverUrl)" +
        " year: \(year)"
    }
}

typealias AlbumData = (title: String, value: String)

extension Album {
    
    var tableRepresentation: [AlbumData] {
        return [
            ("Artist", artist),
            ("Album", title),
            ("Genre", genre),
            ("Year", year)
        ]
    }
}
