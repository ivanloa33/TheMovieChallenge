//
//  EndPointConstants.swift
//  TheMovieChallenge
//
//  Created by Ivan Lopez on 25/10/22.
//

import Foundation

public enum EndPointConstants: EndPointProtocol {
    case popular
    case upcoming

    private var apiKey: String {
        "89f0613956f4eb4120fa66670d8617a2"
    }
    
    var scheme: String {
        "https"
    }

    var host: String {
        "api.themoviedb.org"
    }

    var path: String {
        let path = "/3/movie"
        switch self {
        case .popular:
            return path.appending("/popular")
        case .upcoming:
            return path.appending("/upcoming")
        }
    }

    var params: [URLQueryItem] {
        return [.init(name: "api_key", value: apiKey),
                .init(name: "language", value: "en-US"),
                .init(name: "page", value: "1")]
    }
}
