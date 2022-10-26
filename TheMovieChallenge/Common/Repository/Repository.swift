//
//  Repository.swift
//  TheMovieChallenge
//
//  Created by Ivan Lopez on 26/10/22.
//

import Foundation

protocol Repository {
    typealias Result = (LoadMovieResult) -> Void
    
    var remoteLoader: RemoteMovieLoader? { get }
    var localLoader: LocalMovieLoader? { get }
    
    func fetchMovies(completion: @escaping Result)
    func saveInCache(movies: [Movie])
}

extension Repository {
    func fetchMovies(completion: @escaping Result) {
        remoteLoader?.load(completion: { result in
            switch result {
            case let .success(movies):
                self.saveInCache(movies: movies)
                completion(.success(movies))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
    
    func saveInCache(movies: [Movie]) {
        localLoader?.save(movies, completion: { error in
            if let error = error {
                print("An error occurred saving in cache with: \(error)")
            } else {
                print("Movies saved successfully")
            }
        })
    }
}
