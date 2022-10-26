//
//  PopularMoviesRepository.swift
//  TheMovieChallenge
//
//  Created by Ivan Lopez on 26/10/22.
//

import Foundation

class PopularMoviesRepository: MovieLoader {
    typealias Result = (LoadMovieResult) -> Void
    
    let remoteLoader: RemoteMovieLoader? = {
        guard let popularURL = EndPointConstants.popular.url else {
            return nil
        }
        return RemoteMovieLoader(url: popularURL, client: URLSessionHTTPClient())
    }()
    
    let localLoader: LocalMovieLoader? = {
        guard let popularURL = EndPointConstants.popular.url else {
            return nil
        }
        let codableStore = CodableMovieStore(storeURL: popularURL)
        return LocalMovieLoader(store: codableStore)
    }()
    
    func load(completion: @escaping (LoadMovieResult) -> Void) {
        localLoader?.load { result in
            switch result {
            case let .success(movies):
                if movies.isEmpty {
                    self.fetchPopularMovies(completion: completion)
                } else {
                    completion(.success(movies))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchPopularMovies(completion: @escaping Result) {
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
    
    private func saveInCache(movies: [Movie]) {
        localLoader?.save(movies, completion: { error in
            if let error = error {
                print("An error occurred saving in cache with: \(error)")
            } else {
                print("Movies saved successfully")
            }
        })
    }
}
