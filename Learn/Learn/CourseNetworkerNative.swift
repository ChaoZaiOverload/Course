//
//  CourseNetworkerNative.swift
//  Learn
//
//  Created by apple on 2022/3/27.
//  Copyright © 2022 Huiting Yu. All rights reserved.
//

import Foundation

class CourseNetworkerNative: CourseNetworkable {
  func query(_ query: String, start: Int, completion: @escaping (Result<CourseResponse, Error>) -> Void) {
    var params = default_params
    params.updateValue(query, forKey: "query")
    params.updateValue(String(start), forKey: "start")
    var components = URLComponents(string: "https://www.coursera.org/api/catalogResults.v2")!
    components.queryItems = params.map({ (key, value) -> URLQueryItem in
      return URLQueryItem(name: key, value: String(describing: value))
    })
    
    let noResultErr = NSError(domain: "", code: 1, userInfo: nil)
    var result: Result<CourseResponse, Error> = Result.failure(noResultErr)
  
    guard let url = components.url else {
      print("can't compose url from \(components)")
      DispatchQueue.main.async {
        completion(result)
      }
      return
    }
    
    URLSession.shared.dataTask(with: url) { (data, _, err) in
      defer {
        DispatchQueue.main.async {
          completion(result)
        }
      }
      guard let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
        return
      }
      print("json:\(json)")
      var items = [ResultBase]()
      // make sure this JSON is in the format we expect
      if let linked = json["linked"] as? [String:Any],
         let courses = linked["courses.v1"] as? [[String:Any]] {
        for c in courses {
          if let cid = c["id"] as? String,
             let cname = c["name"] as? String,
             let cphotoURL = c["photoUrl"] as? String {
            let course: Course = Course.init(id: cid, name: cname, partnerName: "random", imageUrl: cphotoURL)//ignore partnerName
            items.append(course)
          }
        }
      }
      var next: Int?, total: Int?
      if let paging = json["paging"] as? [String:Any],
         let nextStr = paging["next"] as? String,
         let nextI = Int(nextStr) {
        next = nextI
      }
      if let paging = json["paging"] as? [String:Any],
         let totalI = paging["total"] as? Int {
        total = totalI
      }
      result = Result.success(CourseResponse(results: items, total: total, next: next))
    }.resume()
  }
  
}
