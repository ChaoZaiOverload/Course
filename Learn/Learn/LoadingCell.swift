//
//  LoadingCell.swift
//  Learn
//
//  Created by Huiting Yu on 10/15/16.
//  Copyright © 2016 Huiting Yu. All rights reserved.
//

import Foundation
import UIKit

class LoadingCell : UITableViewCell {
  var indicatorView : UIActivityIndicatorView = UIActivityIndicatorView()
  static let identifier = "LoadingCell"
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.contentView.addSubview(indicatorView)
    indicatorView.frame.origin = CGPoint.init(x: self.contentView.frame.size.width/2, y: self.contentView.frame.size.height/2)
  }
  
  func startAnimation() {
    self.indicatorView.startAnimating()
  }
  
  func stopAnimation() {
    self.indicatorView.stopAnimating()
  }

}
