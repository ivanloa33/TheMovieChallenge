//
//  MainCoordinator.swift
//  TheMovieChallenge
//
//  Created by Ivan Lopez on 25/10/22.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

final class MainCoordinator: Coordinator {
    private let sb = UIStoryboard.init(name: "Main", bundle: nil)
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loaderViewController = sb.instantiateViewController(withIdentifier: "LoaderViewController") as! LoaderViewController
        loaderViewController.presenter = LoaderPresenter(loaderView: loaderViewController)
        loaderViewController.coordinator = self
        navigationController.pushViewController(loaderViewController, animated: true)
    }
    
    func pushHome(upcomingMovies:[Movie], popularMovies: [Movie]) {
        let homeViewController = sb.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeViewController.presenter = HomePresenter(homeView: homeViewController,
                                                     upcomingMovies: upcomingMovies,
                                                     popularMovies: popularMovies)
        homeViewController.coordinator = self
        navigationController.pushViewController(homeViewController, animated: true)
    }
}
