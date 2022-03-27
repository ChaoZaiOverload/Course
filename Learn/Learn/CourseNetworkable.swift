//
//  CourseNetworkable.swift
//  Learn
//
//  Created by apple on 2022/3/27.
//  Copyright © 2022 Huiting Yu. All rights reserved.
//

import Foundation

protocol CourseNetworkable {
  var baseUrl: String { get }
  var default_params: [String: Any] { get }
  
  func query(_ query: String, start: Int, completion: @escaping (Result<CourseResponse, Error>)->Void)
}

struct CourseResponse {
  let results: [ResultBase]
  let total: Int?
  let next: Int?
}

extension CourseNetworkable {
  var baseUrl:  String  {
    return "https://www.coursera.org/api/catalogResults.v2?"
  }
  var default_params : [String: Any]  {
    return ["q":"search",
            "limit":10,
            "fields":"courseId,onDemandSpecializationId,courses.v1(name,photoUrl,partnerIds),onDemandSpecializations.v1(name,logo,courseIds,partnerIds),partners.v1(name)",
            "includes": "courseId,onDemandSpecializationId,courses.v1(partnerIds)"] as [String : Any]
  }
}
