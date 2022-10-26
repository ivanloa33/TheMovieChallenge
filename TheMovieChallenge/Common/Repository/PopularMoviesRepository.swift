//
//  PopularMoviesRepository.swift
//  TheMovieChallenge
//
//  Created by Ivan Lopez on 26/10/22.
//

import Foundation

class PopularMoviesRepository: Repository, MovieLoader {
    
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
        localLoader?.load {[weak self] result in
            switch result {
            case let .success(movies):
                if movies.isEmpty {
                    self?.fetchMovies(completion: completion)
                } else {
                    completion(.success(movies))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
