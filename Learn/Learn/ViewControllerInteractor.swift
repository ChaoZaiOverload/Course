//
//  ViewControllerInteractor.swift
//  Learn
//
//  Created by Yu, Huiting on 3/14/18.
//  Copyright © 2018 Huiting Yu. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import SwiftyJSON

class ViewControllerInteractor: NSObject {
    private var items: [ResultBase] = []
    private var query : String?
    private var total : Int?
    private var start : Int = 0
    
    let baseUrl = "https://www.coursera.org/api/catalogResults.v2?"
    let default_params: [String: Any] = ["q":"search",
                                         "limit":10,
                                         "fields":"courseId,onDemandSpecializationId,courses.v1(name,photoUrl,partnerIds),onDemandSpecializations.v1(name,logo,courseIds,partnerIds),partners.v1(name)",
                                         "includes": "courseId,onDemandSpecializationId,courses.v1(partnerIds)"] as [String : Any]
    
    @IBOutlet weak var viewController: ViewController?

    fileprivate func loadMore() {
        guard let query = query , self.hasMore(), query.count > 0 else {
            return
        }
        
        var params = default_params
        params.updateValue(query, forKey: "query")
        params.updateValue(String(self.start), forKey: "start")
        Alamofire.request(baseUrl, method: .get, parameters: params).validate().responseJSON { response in
            self.parseReponse(response: response)
            
        }
    }
    
    fileprivate func newQuery(query: String?) {
        self.query = query
        total = nil
        start = 0
        items = []
        self.viewController?.refreshUI()
        
        if let q = query , q != ""{
            loadMore()
        }
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
            
            self.viewController?.refreshUI()
            
        case .failure(let error):
            print("failed with \(error.localizedDescription)")
            self.newQuery(query: nil)
        }
        
    }
    
    private func hasMore() -> Bool {
        if let total = self.total, total < self.start {
            return false
        }
        return true
    }
}

extension ViewControllerInteractor: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultCollectionViewCellIdentifier", for: indexPath) as? ResultCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.updateResult(result: items[indexPath.item])
        return cell
    }
}

extension ViewControllerInteractor: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == items.count - 1 {
            self.loadMore()
        }
    }
}

extension ViewControllerInteractor: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.newQuery(query: searchBar.text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.newQuery(query: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.newQuery(query: nil)
    }
}
