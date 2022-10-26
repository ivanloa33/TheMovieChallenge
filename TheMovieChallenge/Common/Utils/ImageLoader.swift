//
//  ImageLoader.swift
//  TheMovieChallenge
//
//  Created by Ivan Lopez on 25/10/22.
//

import UIKit

enum ImageLoaderError: Error {
    case noData
    case fetchingImage
}

final class ImageLoader {
    public static let shared = ImageLoader()
    private var loadedImages = NSCache<NSURL, UIImage>()
    private init() {}

    public func loadImage(from urlString: String, completion: @escaping (Result<UIImage, ImageLoaderError>) -> Void) {
        if let url = NSURL(string: urlString) , let image = loadedImages.object(forKey: url) {
            completion(.success(image))
            return
        }
        DispatchQueue.global().async {
            guard let url = URL(string: urlString), let data = try? Data(contentsOf: url ) else {
                completion(.failure(.noData))
                return
            }
            guard let image = UIImage(data: data) else {
                completion(.failure(.fetchingImage))
                return
            }
            if let nsurl = NSURL(string: urlString) {
                self.loadedImages.setObject(image, forKey: nsurl)
            }
            completion(.success(image))
        }
    }
}
