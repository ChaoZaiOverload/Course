//
//  CourseDetailsViewController.swift
//  Learn
//
//  Created by Huiting Yu on 10/17/16.
//  Copyright © 2016 Huiting Yu. All rights reserved.
//

import Foundation
import UIKit

class CourseDetailsViewController : DetailsViewController {
  
  
  let courseBaseUrl = "https://api.coursera.org/api/courses.v1/"
  //let specBaseUrl = "https://api.coursera.org/api/onDemandSpecializations.v1/"
  //let specFields = "logo,description"
  
  override func updateViewsWithData(data : [String:String]) {
    if let desc = data["description"] {
      self.descTextView.text = desc
    }
    
    if let photoUrl = data["photoUrl"] {
      self.imageView.downloadFrom(photoUrl)
    }
  }
  override func getUrl()->String{
    return courseBaseUrl + (self.result?.id)! + "?"
  }
  
  override func getFields() -> [String]{
    return ["photoUrl", "description"]
  }
  
}
