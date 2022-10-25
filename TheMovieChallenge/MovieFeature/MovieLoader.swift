//
//  MovieLoader.swift
//  TheMovieChallenge
//
//  Created by Ivan Lopez on 25/10/22.
//

import Foundation

public typealias LoadMovieResult = Result<[Movie], Error>

public protocol MovieLoader {
    func load(completion: @escaping (LoadMovieResult) -> Void)
}
