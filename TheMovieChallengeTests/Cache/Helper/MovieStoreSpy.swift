//
//  MovieStoreSpy.swift
//  TheMovieChallengeTests
//
//  Created by Ivan Lopez on 26/10/22.
//

import Foundation
import TheMovieChallenge

class MovieStoreSpy: MovieStore {
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (RetrieveCacheMovieResult) -> Void
    
    enum ReceivedMessage: Equatable {
        case insert([Movie])
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var insertionCompletion = [InsertionCompletion]()
    private var retrievalCompletions = [RetrievalCompletion]()
    
    func insert(_ movies: [Movie], completion: @escaping InsertionCompletion) {
        insertionCompletion.append(completion)
        receivedMessages.append(.insert(movies))
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletion[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletion[index](nil)
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        retrievalCompletions.append(completion)
        receivedMessages.append(.retrieve)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    func completeWithEmptyCache(at index: Int = 0) {
        retrievalCompletions[index](.empty)
    }
    
    func completeRetrieval(with movies: [Movie], at index: Int = 0) {
        retrievalCompletions[index](.found(movies: movies))
    }
}
