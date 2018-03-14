//
//  Specialization.swift
//  Learn
//
//  Created by Huiting Yu on 10/15/16.
//  Copyright © 2016 Huiting Yu. All rights reserved.
//

import Foundation

class Specialization : ResultBase {
  var courseIds : Array<String>  = []
  init(id: String, name: String, partnerName: String, imageUrl: String, courseIds:Array<String>) {
    self.courseIds = courseIds
    super.init(id: id, name: name, partnerName: partnerName, imageUrl: imageUrl)
  }
}
