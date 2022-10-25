//
//  RemoteMovie.swift
//  TheMovieChallenge
//
//  Created by Ivan Lopez on 25/10/22.
//

import Foundation

internal struct RemoteMovie: Decodable {
    let id: Int
    let backdrop_path: String
    let original_language: String
    let overview: String
    let poster_path: String
    let title: String
    let vote_average: Float
}
