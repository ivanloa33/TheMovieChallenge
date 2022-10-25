//
//  RemoteMovieLoader.swift
//  TheMovieChallenge
//
//  Created by Ivan Lopez on 25/10/22.
//

import Foundation

final class RemoteMovieLoader: MovieLoader {
    private let url: URL
    private let client: HttpClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = LoadMovieResult
    
    public init(url: URL, client: HttpClient) {
        self.url = url
        self.client = client
    }
    
    func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(RemoteMovieLoader.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try MoviesMapper.map(data, from: response)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }
}

private extension Array where Element == RemoteMovie {
    func toModels() -> [Movie] {
        return map { Movie(id: $0.id,
                           backdropPath: $0.backdrop_path,
                           originalLanguage: $0.original_language,
                           overview: $0.overview,
                           posterPath: $0.poster_path,
                           title: $0.title,
                           voteAverage: $0.vote_average)
        }
    }
}