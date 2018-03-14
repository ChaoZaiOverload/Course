//
//  Course.swift
//  Learn
//
//  Created by Huiting Yu on 10/15/16.
//  Copyright © 2016 Huiting Yu. All rights reserved.
//

import Foundation

class Course : ResultBase {
  override init(id: String, name: String, partnerName: String, imageUrl: String) {
    super.init(id: id, name: name, partnerName: partnerName, imageUrl: imageUrl)
  }
}
