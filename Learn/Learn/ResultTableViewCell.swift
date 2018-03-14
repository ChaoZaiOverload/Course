//
//  ResultTableViewCell.swift
//  Learn
//
//  Created by Huiting Yu on 10/16/16.
//  Copyright © 2016 Huiting Yu. All rights reserved.
//

import Foundation
import UIKit

class ResultTableViewCell : UITableViewCell {
  
  var customImageView : UIImageView?
  var result : ResultBase?
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.contentView.addSubview(self.customImageView!)
    self.customImageView?.clipsToBounds = true
    self.customImageView?.frame = CGRect(origin: CGPoint(x:15,y:1), size: CGSize(width: 53, height: 40))
    
    self.textLabel?.frame.origin = CGPoint(x: 72, y: 5)
    self.detailTextLabel?.frame.origin = CGPoint(x: 72, y: 25.5)
  }
  func updateViews() {
    self.customImageView?.downloadFrom((self.result?.imageUrl)!)
    self.textLabel?.text = self.result?.name
    self.detailTextLabel?.text = self.result?.partnerName
  }
  
  func updateResult(result : ResultBase) {
    self.result = result
    self.updateViews()
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?){
    self.customImageView = UIImageView()
    super.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.customImageView?.image = UIImage(named: "result_placeholder")
    self.textLabel?.text = nil
    self.detailTextLabel?.text = nil
  }
  
}
