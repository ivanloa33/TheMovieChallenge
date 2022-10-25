//
//  EndPointConstants.swift
//  TheMovieChallenge
//
//  Created by Ivan Lopez on 25/10/22.
//

import Foundation

public enum EndPointConstants: EndPointProtocol {
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
        switch self {
        case .upcoming:
            return "/3/movie/upcoming"
        }
    }

    var params: [URLQueryItem] {
        var params: [URLQueryItem] = [.init(name: "api_key", value: apiKey)]
        switch self {
        case .upcoming:
            params.append(.init(name: "language", value: "en-US"))
            params.append(.init(name: "page", value: "1"))
            return params
        }
    }
}
