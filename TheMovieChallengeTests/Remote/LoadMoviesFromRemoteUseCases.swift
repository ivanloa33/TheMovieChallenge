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
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = anyURL()
        let client = HttpClientSpy()
        var sut: RemoteMovieLoader? = RemoteMovieLoader(url: url, client: client)
        
        var capturedResults = [RemoteMovieLoader.Result]()
        sut?.load { capturedResults.append($0) }
        
        sut = nil
        client.complete(withStatusCode: 200, data: makeItemJSON(movies: []))
        XCTAssertFalse(capturedResults.isEmpty)
    }
    
    // MARK: - End to end tests
    func disbale_test_loadUpcoming() {
        let exp = expectation(description: "Wait for url response")
        let client = URLSessionHTTPClient()
        guard let upcomingURL = EndPointConstants.upcoming.url else {
            return
        }
        let sut = RemoteMovieLoader(url: upcomingURL, client: client)
        sut.load { result in
            switch result {
            case let .success(movies):
                print(movies)
            case let .failure(error):
                print(error)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
    }
    
    func disable_test_loadPopular() {
        let exp = expectation(description: "Wait for url response")
        let client = URLSessionHTTPClient()
        guard let upcomingURL = EndPointConstants.popular.url else {
            return
        }
        let sut = RemoteMovieLoader(url: upcomingURL, client: client)
        sut.load { result in
            switch result {
            case let .success(movies):
                print(movies)
            case let .failure(error):
                print(error)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
    }
    
    // MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteMovieLoader, client: HttpClientSpy) {
        let client = HttpClientSpy()
        let sut = RemoteMovieLoader(url: url, client: client)
        return (sut, client)
    }
    
    private func makeItemJSON(movies: [Movie]) -> Data {
        let json = ["results": movies]
        return try! JSONSerialization.data(withJSONObject: json)
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
}
