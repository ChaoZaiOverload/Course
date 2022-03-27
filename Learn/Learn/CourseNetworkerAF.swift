//
//  CourseNetworkerAF.swift
//  Learn
//
//  Created by apple on 2022/3/27.
//  Copyright © 2022 Huiting Yu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class CourseNetworkerAF: CourseNetworkable {
  func query(_ query: String, start: Int, completion: @escaping (Result<CourseResponse, Error>)->Void) {
    var params = default_params
    params.updateValue(query, forKey: "query")
    params.updateValue(String(start), forKey: "start")
    AF.request(baseUrl, method: HTTPMethod.get, parameters: params).validate().responseJSON { [weak self] (response) in
      self?.parseReponse(response: response, completion: completion)
    }
  }
  private func parseReponse(response: AFDataResponse<Any>, completion: @escaping (Result<CourseResponse, Error>)->Void) {
    print("request url: \(String(describing: response.request))")
    
    
    switch(response.result) {
    case .success(let value):
      let json = JSON(value)
      print("JSON: \(json)")
      var items = [ResultBase]()
      var partnerNames : [String:String] = [:]
      for (_, subJson):(String, JSON) in json["linked"]["partners.v1"] {
        if let pid = subJson["id"].string , let pname = subJson["name"].string {
          partnerNames[pid] = pname
        }
      }
      
      for(_, subJson):(String, JSON) in json["linked"]["courses.v1"] {
        if let cid = subJson["id"].string, let cname = subJson["name"].string, let cphoto = subJson["photoUrl"].string, let partnerId = subJson["partnerIds"].array?[0].string , partnerNames[partnerId] != nil{
          let course: Course = Course.init(id: cid, name: cname, partnerName: partnerNames[partnerId]!, imageUrl: cphoto)
          items.append(course)
        }
      }
      
      for(_, subJson):(String, JSON) in json["linked"]["onDemandSpecializations.v1"] {
        if let id = subJson["id"].string, let name = subJson["name"].string, let photo = subJson["logo"].string, let partnerId = subJson["partnerIds"].array?[0].string , partnerNames[partnerId] != nil, let cIds = subJson["courseIds"].array {
          var courseIds : [String] = []
          for cid:JSON in cIds where cid.string != nil {
            courseIds.append(cid.string!)
          }
          let spec: Specialization = Specialization.init(id: id, name: name, partnerName: partnerNames[partnerId]!, imageUrl: photo, courseIds: courseIds)
          items.append(spec)
        }
      }
      
      let next = Int(json["paging"]["next"].string ?? "")
      completion(Result.success(CourseResponse(results: items, total: json["paging"]["total"].int, next:next)))
      
    case .failure(let error):
      print("failed with \(error.localizedDescription)")
      completion(Result.failure(error))
    }
    
  }
  
}
