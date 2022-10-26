//
//  LoaderViewController.swift
//  TheMovieChallenge
//
//  Created by Ivan Lopez on 25/10/22.
//

import UIKit

protocol LoaderViewProtocol {
    func dataLoadedSuccessfully(upcomingMovies: [Movie], popularMovies: [Movie])
    func dataLoadedWithError()
}

final class LoaderViewController: UIViewController {
    var presenter: LoaderPresenterProtocol?
    var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension LoaderViewController: LoaderViewProtocol {
    func dataLoadedSuccessfully(upcomingMovies: [Movie], popularMovies: [Movie]) {
        coordinator?.pushHome(upcomingMovies: upcomingMovies, popularMovies: popularMovies)
    }
    
    func dataLoadedWithError() {
        print("fails")
    }
}
