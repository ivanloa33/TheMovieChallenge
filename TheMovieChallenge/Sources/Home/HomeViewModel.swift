//
//  HomeViewModel.swift
//  TheMovieChallenge
//
//  Created by Ivan Lopez on 26/10/22.
//

import Foundation

struct HomeViewModel {
    let title: String
    let titleSectionOne: String
    let titleSectionTwo: String
    let titleSectionThree: String
    let upcomigMoviesViewModel: [MovieCellViewModel]
    let popularMoviesViewModel: [MovieCellViewModel]
}
