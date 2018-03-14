//
//  ResultBase.swift
//  Learn
//
//  Created by Huiting Yu on 10/15/16.
//  Copyright © 2016 Huiting Yu. All rights reserved.
//

import Foundation

class ResultBase : NSObject {
  var id : String
  var name : String
  var partnerName : String
  var imageUrl: String

  init(id: String, name: String, partnerName: String, imageUrl: String) {
    self.id = id
    self.name = name
    self.partnerName = partnerName
    self.imageUrl = imageUrl
  }
}
