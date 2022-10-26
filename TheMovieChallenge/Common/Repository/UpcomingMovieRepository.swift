//
//  UpcomingRepository.swift
//  TheMovieChallenge
//
//  Created by Ivan Lopez on 26/10/22.
//

import Foundation

class UpcomingMoviesRepository: MovieLoader {
    typealias Result = (LoadMovieResult) -> Void
    
    let remoteLoader: RemoteMovieLoader? = {
        guard let upcomingURL = EndPointConstants.upcoming.url else {
            return nil
        }
        return RemoteMovieLoader(url: upcomingURL, client: URLSessionHTTPClient())
    }()
    
    let localLoader: LocalMovieLoader? = {
        guard let upcomingURL = EndPointConstants.upcoming.url else {
            return nil
        }
        let codableStore = CodableMovieStore(storeURL: upcomingURL)
        return LocalMovieLoader(store: codableStore)
    }()
    
    func load(completion: @escaping (LoadMovieResult) -> Void) {
        
        localLoader?.load { result in
            switch result {
            case let .success(movies):
                if movies.isEmpty {
                    self.fetchUpcomingMovies(completion: completion)
                } else {
                    completion(.success(movies))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchUpcomingMovies(completion: @escaping Result) {
        remoteLoader?.load(completion: completion)
    }
}
