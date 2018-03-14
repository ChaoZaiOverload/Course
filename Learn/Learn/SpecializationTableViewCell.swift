//
//  SpecializationTableViewCell.swift
//  Learn
//
//  Created by Huiting Yu on 10/15/16.
//  Copyright © 2016 Huiting Yu. All rights reserved.
//

import Foundation
import UIKit

class SpecializationTableViewCell : ResultTableViewCell {
  static let identifier = "SpecializationTableViewCell"
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override init(style: UITableViewCellStyle, reuseIdentifier: String?){
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  override func updateResult(result: ResultBase) {
    super.updateResult(result: result)
    let courseCnt = (result as! Specialization).courseIds.count
    self.detailTextLabel?.text =  (result as! Specialization).partnerName + " with " + String(courseCnt) + " courses"
  }
}
