//
//  UIImageViewExtension.swift
//  TheMovieChallenge
//
//  Created by Ivan Lopez on 25/10/22.
//

import Foundation
import UIKit

public extension UIImageView {
    func loadImage(from urlString: String) {
        ImageLoader.shared.loadImage(from: urlString) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.image = image
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
