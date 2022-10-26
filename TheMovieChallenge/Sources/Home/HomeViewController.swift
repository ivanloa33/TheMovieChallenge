//
//  ViewController.swift
//  TheMovieChallenge
//
//  Created by Ivan Lopez on 24/10/22.
//

import UIKit

protocol HomeViewProtocol {
    var coordinator: MainCoordinator? { get set }
    var presenter: HomePresenterProtocol? { get set }
}

class HomeViewController: UIViewController, HomeViewProtocol {
    
    @IBOutlet weak var titleSectionOne: UILabel!
    @IBOutlet weak var titleSectionTwo: UILabel!
    @IBOutlet weak var upcomingCollectionView: UICollectionView!
    @IBOutlet weak var popularCollectionView: UICollectionView!
    
    var coordinator: MainCoordinator?
    var presenter: HomePresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViews()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesBackButton = true
        setupTitles()
    }
    
    private func setupCollectionViews() {
        upcomingCollectionView.register(UINib(nibName: MovieCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: MovieCollectionViewCell.reuseIdentifier)
        upcomingCollectionView.dataSource = self
        popularCollectionView.register(UINib(nibName: MovieCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: MovieCollectionViewCell.reuseIdentifier)
        popularCollectionView.dataSource = self
    }
    
    func setupTitles() {
        guard let homeViewModel = presenter?.getViewModel() else { return }
        title = homeViewModel.title
        titleSectionOne.text = homeViewModel.titleSectionOne
        titleSectionTwo.text = homeViewModel.titleSectionTwo
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.getNumberOfItems(tag: collectionView.tag) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.reuseIdentifier, for: indexPath) as? MovieCollectionViewCell,
              let cellViewModel = presenter?.getCellViewModelFromMovie(tag: collectionView.tag, indexPath: indexPath) else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .lightGray
        cell.configure(with: cellViewModel)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 0.75) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
}
