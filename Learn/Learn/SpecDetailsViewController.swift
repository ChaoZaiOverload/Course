//
//  SpecDetailsViewController.swift
//  Learn
//
//  Created by Huiting Yu on 10/17/16.
//  Copyright © 2016 Huiting Yu. All rights reserved.
//

import Foundation
import UIKit

class SpecDetailsViewController : DetailsViewController {
  
  
  let specBaseUrl = "https://api.coursera.org/api/onDemandSpecializations.v1/"
  
  override func updateViewsWithData(data : [String:String]) {
    if let desc = data["description"] {
      self.descTextView.text = desc
    }
    
    if let photoUrl = data["logo"] {
      self.imageView.downloadFrom(photoUrl)
    }
  }
  override func getUrl()->String{
    return specBaseUrl + (self.result?.id)! + "?"
  }
  
  override func getFields() -> [String]{
    return ["logo", "description"]
  }
  
}
