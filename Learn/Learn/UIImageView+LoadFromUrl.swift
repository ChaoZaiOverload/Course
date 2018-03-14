//
//  UIImageView+LoadFromUrl.swift
//  Learn
//
//  Created by Huiting Yu on 10/16/16.
//  Copyright © 2016 Huiting Yu. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadFrom(_ link:String, contentMode mode: UIViewContentMode = .scaleAspectFill) {
    guard
      let url = URL(string: link)
      else {return}
    
    contentMode = mode
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
      guard
        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
        let data = data, error == nil,
        let image = UIImage(data: data)
        else { return }
            DispatchQueue.main.async() { () -> Void in
        self.image = image
      }
    }).resume()
  }
}
