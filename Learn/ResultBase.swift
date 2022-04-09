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

//TODO: make it codable 
//class ResultBase: Decodable {
//  var id : String
//  var name : String
//  var partnerName : String?
//  var partnerIds: [String]?
//  var imageUrl: String
//  var courseIds: [String]?
//
//  init(id: String, name: String, partnerName: String, imageUrl: String) {
//    self.id = id
//    self.name = name
//    self.partnerName = partnerName
//    self.imageUrl = imageUrl
//  }
//
//  enum CodingKeys: String, CodingKey {
//    case id = "id"
//    case name = "name"
//    case imageUrl = "photoUrl"
//    case partnerIds = "partnerIds"
//    case courseIds = "courseIds"
//  }
//}
