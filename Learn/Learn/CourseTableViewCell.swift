//
//  CourseTableViewCell.swift
//  Learn
//
//  Created by Huiting Yu on 10/15/16.
//  Copyright © 2016 Huiting Yu. All rights reserved.
//

import Foundation
import UIKit

class CourseTableViewCell : ResultTableViewCell {
  static let identifier = "CourseTableViewCell"  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override init(style: UITableViewCellStyle, reuseIdentifier: String?){
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
}
