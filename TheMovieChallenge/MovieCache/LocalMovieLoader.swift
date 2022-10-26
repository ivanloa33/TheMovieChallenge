//
//  LocalMovieLoader.swift
//  TheMovieChallenge
//
//  Created by Ivan Lopez on 26/10/22.
//

import Foundation

public final class LocalMovieLoader {
    private let store: MovieStore
    public init(store: MovieStore) {
        self.store = store
    }
}

extension LocalMovieLoader {
    public typealias SaveResult = Error?
    
    public func save(_ movies: [Movie], completion: @escaping (SaveResult) -> Void) {
        cache(movies, with: completion)
    }
    
    private func cache(_ movies: [Movie], with completion: @escaping (SaveResult) -> Void ) {
        store.insert(movies) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}

extension LocalMovieLoader: MovieLoader {
    public typealias LoadResult = LoadMovieResult
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .found(movies):
                completion(.success(movies))
            case .empty:
                completion(.success([]))
            }
        }
    }
}
