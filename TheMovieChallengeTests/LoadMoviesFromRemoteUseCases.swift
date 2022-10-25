//
//  LoadMoviesFromRemoteUseCases.swift
//  LoadMoviesFromRemoteUseCases
//
//  Created by Ivan Lopez on 24/10/22.
//

import XCTest
@testable import TheMovieChallenge

class LoadMoviesFromRemoteUseCases: XCTestCase {
    
    func test_init_doesntRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedUrls.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
        sut.load() { _ in }
        
        XCTAssertEqual(client.requestedUrls, [url])
    }

    func test_loadTwice_requestsDataFromURL() {
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
        sut.load() { _ in }
        sut.load() { _ in }
        
        XCTAssertEqual(client.requestedUrls, [url, url])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteMovieLoader, client: HttpClientSpy) {
        let client = HttpClientSpy()
        let sut = RemoteMovieLoader(url: url, client: client)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteMovieLoader, toCompleteWith expectedResult: RemoteMovieLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as RemoteMovieLoader.Error), .failure(expectedError as RemoteMovieLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func failure(_ error: RemoteMovieLoader.Error) -> RemoteMovieLoader.Result {
        .failure(error)
    }
    
    private func anyURL() -> URL {
        URL(string: "https://anyURL.com")!
    }
}

private class HttpClientSpy: HttpClient {
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
}
