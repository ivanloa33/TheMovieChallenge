//
//  MovieCollectionViewCell.swift
//  TheMovieChallenge
//
//  Created by Ivan Lopez on 25/10/22.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    static let nibName = String(describing: MovieCollectionViewCell.self)
    static let reuseIdentifier = "movieCell"
    
    func configure(with viewModel: MovieCellViewModel) {
        let path = "https://image.tmdb.org/t/p/w500\(viewModel.poster)"
        self.poster.loadImage(from: path)
        self.title.text = viewModel.title
    }
}

struct MovieCellViewModel {
    let title: String
    let poster: String
}
