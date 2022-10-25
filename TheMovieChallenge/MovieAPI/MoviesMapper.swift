//
//  MoviesMapper.swift
//  TheMovieChallenge
//
//  Created by Ivan Lopez on 25/10/22.
//

import Foundation

internal final class MoviesMapper {
    private struct Results: Decodable {
        let movies: [RemoteMovie]
        
        enum CodingKeys: String, CodingKey {
            case movies = "results"
        }
    }
    
    private static var OK_200: Int { 200 }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteMovie] {
        
        guard response.statusCode == OK_200,
              let results = try? JSONDecoder().decode(Results.self, from: data) else {
            throw RemoteMovieLoader.Error.invalidData
        }
        
        return results.movies
    }
}
