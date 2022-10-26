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
    
    func configure(with title: String) {
//        let path = "https://api.themoviedb.org/3/movie/\(movie.id)}/images?api_key=89f0613956f4eb4120fa66670d8617a2&language=en-US"
//        self.poster.loadImage(from: path)
        self.title.text = title
    }
}
