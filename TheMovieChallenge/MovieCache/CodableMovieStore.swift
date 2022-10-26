//
//  CodableMovieStore.swift
//  TheMovieChallenge
//
//  Created by Ivan Lopez on 26/10/22.
//

import Foundation

public class CodableMovieStore: MovieStore {
    private let queue = DispatchQueue.init(label: "\(CodableMovieStore.self)Queue", qos: .userInitiated, attributes: .concurrent)
    private let storeURL: URL
    static var docDirUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    public init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        let url = Self.docDirUrl.appendingPathComponent(storeURL.lastPathComponent)
        queue.async {
            guard let data = try? Data(contentsOf: url) else {
                return completion(.empty)
            }
            
            do {
                let decoder = JSONDecoder()
                let cache = try decoder.decode(Results.self, from: data)
                completion(.found(movies: cache.movies))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func insert(_ movies: [Movie], completion: @escaping InsertionCompletion) {
        let url = Self.docDirUrl.appendingPathComponent(storeURL.lastPathComponent)
        queue.async(flags: .barrier) {
            do {
                let encoder = JSONEncoder()
                let cache = Results(movies: movies)
                let encoded = try encoder.encode(cache)
                try encoded.write(to: url)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
}
