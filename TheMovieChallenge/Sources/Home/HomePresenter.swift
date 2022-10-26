//
//  HomePresenter.swift
//  TheMovieChallenge
//
//  Created by Ivan Lopez on 25/10/22.
//

import Foundation

protocol HomePresenterProtocol {
    func getNumberOfItems(tag: Int) -> Int
    func getTitleFromMovie(tag: Int, indexPath: IndexPath) -> String?
    func getViewModel() -> HomeViewModel
}

final class HomePresenter {
    private let upcomingMovies: [Movie]!
    private let popularMovies: [Movie]!
    private let homeView: HomeViewProtocol?
    private let viewModel: HomeViewModel!
    
    init(homeView: HomeViewProtocol, upcomingMovies: [Movie], popularMovies: [Movie]) {
        self.upcomingMovies = upcomingMovies
        self.popularMovies = popularMovies
        self.homeView = homeView
        viewModel = HomeViewModel(title: "eMovie",
                                  titleSectionOne: "Próximos estrenos",
                                  titleSectionTwo: "Tendencia",
                                  titleSectionThree: "",
                                  upcomigTitles: upcomingMovies.map { $0.title},
                                  popularTitles: popularMovies.map { $0.title})
    }
}

extension HomePresenter: HomePresenterProtocol {
    func getViewModel() -> HomeViewModel {
        viewModel
    }
    
    func getTitleFromMovie(tag: Int, indexPath: IndexPath) -> String? {
        if tag == 0 {
            return viewModel.upcomigTitles[indexPath.row]
        } else if tag == 1 {
            return viewModel.popularTitles[indexPath.row]
        } else {
            return nil
        }
    }
    
    func getNumberOfItems(tag: Int) -> Int {
        if tag == 0 {
            return upcomingMovies.count
        } else if tag == 1 {
            return popularMovies.count
        }
        return 0
    }
}
