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
    var loaderView: LoaderViewProtocol?
    var upcomingMovies: [Movie]?
    var popularMovies: [Movie]?
    
    let upcomingLoader: RemoteMovieLoader? = {
        guard let upcomingURL = EndPointConstants.upcoming.url else {
            return nil
        }
        return RemoteMovieLoader(url: upcomingURL, client: URLSessionHTTPClient())
    }()
    
    let popularLoader: RemoteMovieLoader? = {
        guard let popularURL = EndPointConstants.popular.url else {
            return nil
        }
        return RemoteMovieLoader(url: popularURL, client: URLSessionHTTPClient())
    }()
    
    init(loaderView: LoaderViewProtocol) {
        self.loaderView = loaderView
        fetchData()
    }
    
    private func fetchData() {
        let dispatchGroup = DispatchGroup()
        fetchUpcomingMovies(dispatchGroup: dispatchGroup)
        fetchPopularMovies(dispatchGroup: dispatchGroup)
        dispatchGroup.notify(queue: .main) { [self] in
            if let upcomingMovies = upcomingMovies,
               let popularMovies = popularMovies {
                self.loaderView?.dataLoadedSuccessfully(upcomingMovies: upcomingMovies,
                                                        popularMovies: popularMovies)
            } else {
                self.loaderView?.dataLoadedWithError()
            }
        }
    }
    
    private func fetchUpcomingMovies(dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        upcomingLoader?.load { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(movies):
                self.upcomingMovies = movies
            case let .failure(error):
                print(error)
            }
            dispatchGroup.leave()
        }
    }
    
    private func fetchPopularMovies(dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        popularLoader?.load { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(movies):
                self.popularMovies = movies
            case let .failure(error):
                print(error)
            }
            dispatchGroup.leave()
        }
    }
}
