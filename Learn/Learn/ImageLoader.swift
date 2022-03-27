//
//  ImageLoader.swift
//  Learn
//
//  Created by apple on 2022/3/28.
//  Copyright © 2022 Huiting Yu. All rights reserved.
//

import Foundation
import SDWebImage

protocol ImageManagable {
  func loadImage(url: URL, placeholder: UIImage, completion: @escaping (UIImage?)->Void)
  func loadImage(for imageView: UIImageView, url: URL, placeholder: UIImage)
}

extension ImageManagable {
  func loadImage(for imageView: UIImageView, url: URL, placeholder: UIImage) {
    imageView.image = placeholder
    loadImage(url: url, placeholder: placeholder) { (img) in
      if let img = img {
        imageView.image = img
      } else {
        imageView.image = placeholder
      }
    }
  }
}

class SDImageWorker: ImageManagable {
  func loadImage(url: URL, placeholder: UIImage, completion: @escaping (UIImage?) -> Void) {
    SDWebImageDownloader.shared.downloadImage(with: url) { (img, _, err, finished) in
      completion(img)
    }
    //todo: save downloadToken and persist it in cell, allow cancel when cell gets reused. 
  }
  
  
}

class NativeImageWorker: ImageManagable {
  func loadImage(url: URL, placeholder: UIImage, completion: @escaping (UIImage?) -> Void) {
    URLSession.shared.dataTask(with: url) { (data, _, err) in
      var img: UIImage?
      if let data = data, let image = UIImage(data: data) {
        img = image
      }
      DispatchQueue.main.async {
        completion(img)
      }
    }.resume()
  }
  
  
}
