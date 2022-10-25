//
//  MoviesMapper.swift
//  TheMovieChallenge
//
//  Created by Ivan Lopez on 25/10/22.
//

import Foundation

internal final class MoviesMapper {
    private struct Root: Decodable {
        let movies: [RemoteMovie]
    }
    
    private static var OK_200: Int { 200 }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteMovie] {
        
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteMovieLoader.Error.invalidData
        }
        
        return root.movies
    }
}
