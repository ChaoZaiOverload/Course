//
//  TableViewDataSource.swift
//  Learn
//
//  Created by Huiting Yu on 10/15/16.
//  Copyright © 2016 Huiting Yu. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

public enum SearchResult{
  case Success
  case Failure(error: String)
}

class TableViewDataSource : NSObject,UITableViewDataSource {

    
  var results : Array<ResultBase> = []
  var query : String?
  var total : Int?
  var start : Int = 0
  
  typealias SearchCompleteCallback = (_ searchResult: SearchResult) ->()
  var callback : SearchCompleteCallback?
  
  let baseUrl = "https://www.coursera.org/api/catalogResults.v2?"
    let default_params: [String: Any] = ["q":"search",
                        "limit":10,
                        "fields":"courseId,onDemandSpecializationId,courses.v1(name,photoUrl,partnerIds),onDemandSpecializations.v1(name,logo,courseIds,partnerIds),partners.v1(name)",
                        "includes": "courseId,onDemandSpecializationId,courses.v1(partnerIds)"] as [String : Any]
  
    init(callback: @escaping SearchCompleteCallback) {
    self.callback = callback
    super.init()
  }
  
  // table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return results.count + 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell : UITableViewCell? = nil
    if(indexPath.row == results.count) {
        cell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.identifier)
      
    } else if(results[indexPath.row] is Course) {
        cell = tableView.dequeueReusableCell(withIdentifier: CourseTableViewCell.identifier)
        (cell as! CourseTableViewCell).updateResult(result: results[indexPath.row])
    } else if(results[indexPath.row] is Specialization) {
        cell = tableView.dequeueReusableCell(withIdentifier: SpecializationTableViewCell.identifier)
        (cell as! SpecializationTableViewCell).updateResult(result: results[indexPath.row])
    }
    return cell!
  }

  // public functions
  func loadMore() {
    guard let query = query , self.hasMore(), query.count > 0 else {
      return
    }

    var params = default_params
    params.updateValue(self.query!, forKey: "query")
    params.updateValue(String(self.start), forKey: "start")
    Alamofire.request(baseUrl, method: .get, parameters: params).validate().responseJSON { response in
        self.parseReponse(response: response)
        
    }
  }
  
  func newQuery(query: String?) {
    if let q = query , q != ""{
      self.query = q
      self.results.removeAll()
      total = nil
      start = 0
      loadMore()
    } else {
      self.resetQuery()
    }
  }
  
  // private functions
  private func resetQuery() {
    self.query = nil
    self.results.removeAll()
    self.total = nil
    self.start = 0
    self.callback!(SearchResult.Success)
  }
  
  
  private func parseReponse(response: DataResponse<Any>) {
    print("request url: \(response.request)")
    
    
    switch(response.result) {
    case .success(let value):
      let json = JSON(value)
      print("JSON: \(json)")
      
      var partnerNames : [String:String] = [:]
      for (_, subJson):(String, JSON) in json["linked"]["partners.v1"] {
        if let pid = subJson["id"].string , let pname = subJson["name"].string {
          partnerNames[pid] = pname
        }
      }
      
      for(_, subJson):(String, JSON) in json["linked"]["courses.v1"] {
        if let cid = subJson["id"].string, let cname = subJson["name"].string, let cphoto = subJson["photoUrl"].string, let partnerId = subJson["partnerIds"].array?[0].string , partnerNames[partnerId] != nil{
          let course: Course = Course.init(id: cid, name: cname, partnerName: partnerNames[partnerId]!, imageUrl: cphoto)
          results.append(course)
        }
      }
      
      for(_, subJson):(String, JSON) in json["linked"]["onDemandSpecializations.v1"] {
        if let id = subJson["id"].string, let name = subJson["name"].string, let photo = subJson["logo"].string, let partnerId = subJson["partnerIds"].array?[0].string , partnerNames[partnerId] != nil, let cIds = subJson["courseIds"].array {
          var courseIds : [String] = []
          for cid:JSON in cIds where cid.string != nil {
            courseIds.append(cid.string!)
          }
          let spec: Specialization = Specialization.init(id: id, name: name, partnerName: partnerNames[partnerId]!, imageUrl: photo, courseIds: courseIds)
          results.append(spec)
        }
      }
      
      if let next = json["paging"]["next"].string, let nextInt = Int(next) {
        self.start = nextInt
      } else {
        self.start = Int.max
      }
      
      if let total = json["paging"]["total"].int {
        self.total = total
      } else {
        self.total = 0
      }
      
      self.callback!(SearchResult.Success)
      
    case .failure(let error):
        self.callback!(SearchResult.Failure(error: error.localizedDescription))
    }
  
  }

  private func hasMore() -> Bool {
    if let total = self.total, total < self.start {
      return false
    }
    return true
  }
}
