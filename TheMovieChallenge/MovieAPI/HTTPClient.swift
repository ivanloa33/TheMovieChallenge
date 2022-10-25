//
//  HTTPClient.swift
//  TheMovieChallenge
//
//  Created by Ivan Lopez on 25/10/22.
//

import Foundation

public typealias HttpClientResult = Result<(Data, HTTPURLResponse), Error>

public protocol HttpClient {
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func get(from url: URL, completion: @escaping (HttpClientResult) -> Void)
}
