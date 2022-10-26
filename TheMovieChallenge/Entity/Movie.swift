//
//  Movie.swift
//  TheMovieChallenge
//
//  Created by Ivan Lopez on 25/10/22.
//

import Foundation

public struct Movie: Codable, Equatable {
    let id: Int
    let backdropPath: String
    let originalLanguage: String
    let overview: String
    let posterPath: String
    let title: String
    let voteAverage: Float
    
    enum CodingKeys: String, CodingKey {
        case id, overview, title
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
}
