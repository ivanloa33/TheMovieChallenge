//
//  LoaderPresenter.swift
//  TheMovieChallenge
//
//  Created by Ivan Lopez on 25/10/22.
//

import Foundation

protocol LoaderPresenterProtocol {
}

final class LoaderPresenter: LoaderPresenterProtocol {
    private let loaderView: LoaderViewProtocol?
    private let upcomingRepository: MovieLoader = UpcomingMoviesRepository()
    private let popularRepository: MovieLoader = PopularMoviesRepository()
    private var upcomingMovies: [Movie]?
    private var popularMovies: [Movie]?
    
    
    init(loaderView: LoaderViewProtocol) {
        self.loaderView = loaderView
        fetchMovies()
    }
    
    private func fetchMovies() {
        let dispatchGroup = DispatchGroup()
        getUpcomingMovies(dispatchGroup: dispatchGroup)
        getPopularMovies(dispatchGroup: dispatchGroup)
        dispatchGroup.notify(queue: .main) {
            if let upcomingMovies = self.upcomingMovies,
               let popularMovies = self.popularMovies {
                self.loaderView?.dataLoadedSuccessfully(upcomingMovies: upcomingMovies,
                                                   popularMovies: popularMovies)
            }
        }
    }
    
    private func getUpcomingMovies(dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        upcomingRepository.load { result in
            switch result {
            case let .success(upcomingMovies):
                self.upcomingMovies = upcomingMovies
            case let .failure(error):
                print("Displar error: \(error)")
                self.upcomingMovies = nil
            }
            dispatchGroup.leave()
        }
    }
    
    private func getPopularMovies(dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        popularRepository.load { result in
            switch result {
            case let .success(popularMovies):
                self.popularMovies = popularMovies
            case let .failure(error):
                print("Displar error: \(error)")
                self.popularMovies = nil
            }
            dispatchGroup.leave()
        }
    }
}
