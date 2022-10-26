//
//  MovieStore.swift
//  TheMovieChallenge
//
//  Created by Ivan Lopez on 26/10/22.
//

import Foundation

public enum RetrieveCacheMovieResult {
    case empty
    case found(movies: [Movie])
    case failure(Error)
}

public protocol MovieStore {
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (RetrieveCacheMovieResult) -> Void
    
    func insert(_ movies: [Movie], completion: @escaping InsertionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}
