//
//  LoadMoviesFromCacheUseCases.swift
//  TheMovieChallengeTests
//
//  Created by Ivan Lopez on 26/10/22.
//

import XCTest
@testable import TheMovieChallenge

class LoadMoviesFromCacheUseCases: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(retrievalError)) {
            store.completeRetrieval(with: retrievalError)
        }
    }
    
    func test_load_deliversNoMoviesOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success([])) {
            store.completeWithEmptyCache()
        }
    }
    
    func test_load_deliversCachedImages() {
        let movies = mockMovies()
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success(movies)) {
            store.completeRetrieval(with: movies)
        }
    }
    
    func test_load_hasNoSideEffectsOnRetrievalError() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        store.completeRetrieval(with: anyNSError())
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        store.completeWithEmptyCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = MovieStoreSpy()
        var sut: LocalMovieLoader? = LocalMovieLoader(store: store)
        
        var receivedResults = [LocalMovieLoader.LoadResult]()
        sut?.load(completion: {receivedResults.append($0)})
        
        sut = nil
        store.completeWithEmptyCache()
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalMovieLoader, store: MovieStoreSpy) {
        let store = MovieStoreSpy()
        let sut = LocalMovieLoader(store: store)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalMovieLoader, toCompleteWith expectedResult: LocalMovieLoader.LoadResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedMovies), .success(expectedMovie)):
                XCTAssertEqual(receivedMovies, expectedMovie, file: file, line: line)
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError)
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }

        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    func uniqueMovie() -> Movie {
        return Movie(id: .random(in: 0..<10),
                     backdropPath: "any",
                     originalLanguage: "any",
                     overview: "any",
                     posterPath: "any",
                     title: "any",
                     voteAverage: 1.0)
    }

    func mockMovies() -> [Movie] {
        [uniqueMovie(), uniqueMovie()]
    }
}
