//
//  HttpClientSpy.swift
//  TheMovieChallengeTests
//
//  Created by Ivan Lopez on 26/10/22.
//

import Foundation
import TheMovieChallenge

class HttpClientSpy: HttpClient {
    private var messages = [(url: URL, completion: (HttpClientResult) -> Void)]()
    
    var requestedUrls: [URL] {
        return messages.map { $0.url }
    }
    
    func get(from url: URL, completion: @escaping (HttpClientResult) -> Void) {
        messages.append((url, completion))
    }

    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
    
    func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(url: requestedUrls[index],
                                       statusCode: code,
                                       httpVersion: nil,
                                       headerFields: nil)!
        messages[index].completion(.success((data, response)))
    }
}
