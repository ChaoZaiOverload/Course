//
//  CourseNetworkerJsonConvertible.swift
//  Learn
//
//  Created by apple on 2022/3/27.
//  Copyright © 2022 Huiting Yu. All rights reserved.
//
// The MIT License (MIT)
//
// Copyright (c) 2016 Naoki Hiroshima
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

fileprivate protocol JsonObjectConvertible {
    subscript(idx: Int) -> Any? { get }
    subscript(key: String) -> Any? { get }
}

fileprivate extension JsonObjectConvertible {
    subscript(idx: Int) -> Any? {
        guard let arr = self as? [Any] else { return nil }
        guard arr.count > idx else { return nil }
        return jsonObject(arr[idx])
    }
    
    subscript(key: String) -> Any? {
        guard let dict = self as? [String: Any] else { return nil }
        return jsonObject(dict[key])
    }
    
    private func jsonObject(_ any: Any?) -> Any? {
        switch any {
        case let n as NSNumber: return String(cString: n.objCType) == "c" ? n.boolValue : any
        case is NSNull: return nil
        default: return any
        }
    }
}

extension Optional: JsonObjectConvertible { }

class CourseNeworkerJsonConvertible: CourseNetworkable {
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
      var partnerNames : [String:String] = [:]
      if let partners = json["linked"]["partners.v1"] as? [[String:Any]] {
        for partner in partners {
          if let pid = partner["id"] as? String , let pname = partner["name"] as? String {
            partnerNames[pid] = pname
          }
        }
      }

      
      if let courses = json["linked"]["courses.v1"] as? [[String:Any]] {
        for c in courses {
          if let cid = c["id"] as? String,
             let cname = c["name"] as? String,
             let cphotoURL = c["photoUrl"] as? String,
             let partnerId = c["partnerIds"][0] as? String {
            let course: Course = Course.init(id: cid, name: cname, partnerName: partnerNames[partnerId]!, imageUrl: cphotoURL)//ignore partnerName
            items.append(course)
          }
        }
      }
      
      if let specs = json["linked"]["onDemandSpecializations.v1"]  as? [[String:Any]] {
        for s in specs {
          if let id = s["id"] as? String,
             let name = s["name"] as? String,
             let photo = s["logo"] as? String,
             let partnerId = s["partnerIds"][0] as? String,
             let partnerName = partnerNames[partnerId],
             let cIds: [String] = (s["courseIds"] as? [Any])?.compactMap({
              if let cid = $0 as? String {
                return cid
              }
              return nil
             }) {
            let spec: Specialization = Specialization.init(id: id, name: name, partnerName: partnerName, imageUrl: photo, courseIds: cIds)
            items.append(spec)
          }
        }
      }
      let next: Int? = Int(json["paging"]["next"] as? String ?? "")
      let total: Int? = json["paging"]["total"] as? Int
      result = Result.success(CourseResponse(results: items, total: total, next: next))
    }.resume()
  }
}
