//
//  DetailsViewController.swift
//  Learn
//
//  Created by Huiting Yu on 10/16/16.
//  Copyright © 2016 Huiting Yu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

class DetailsViewController: UIViewController {
  var nameLabel: UILabel = UILabel()
  var imageView : UIImageView = UIImageView()
  var descTextView: UITextView = UITextView()
  var backBtn : UIButton = UIButton()
  var result : ResultBase?

  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init(result : ResultBase) {
    self.result = result
    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.yellow
    
    self.view.addSubview(backBtn)
    backBtn.frame =  CGRect(origin: CGPoint(x: 10, y: 10), size: CGSize(width: 100, height: 40))
    backBtn.setTitle("Back", for: [])
    backBtn.titleLabel?.textColor = UIColor.blue
    
    backBtn.backgroundColor = UIColor.green
    backBtn.addTarget(self, action: #selector(DetailsViewController.back(btn:)), for: UIControlEvents.touchUpInside)
    
    let width = self.view.frame.size.width
    self.view.addSubview(nameLabel)
    nameLabel.frame = CGRect(origin: CGPoint(x: 110, y: 0), size: CGSize(width: 250, height: 40))
    nameLabel.text = result?.name
    
    self.view.addSubview(imageView)
    imageView.frame = CGRect(origin: CGPoint(x: 0, y: 150), size: CGSize(width: width, height: 200))
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    
    self.view.addSubview(descTextView)
    descTextView.frame = CGRect(origin: CGPoint(x: 0, y: 350), size: CGSize(width: width, height: 350))
  }
  
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.requestData()
  }
  
  
  private func requestData() {

    let fields: [String] = self.getFields()
    var fieldStr = ""
    for item in fields {
      fieldStr = fieldStr + item + ","
    }
    fieldStr = String(fieldStr[...fieldStr.index(before: fieldStr.endIndex)])
    Alamofire.request(self.getUrl() + "fields=" + fieldStr).validate().responseJSON { [weak self] (response) in
      print(response.request)
        self?.parseResponse(response: response)
    }
  }
  
  
  private func parseResponse(response: DataResponse<Any>){
    switch(response.result) {
    case .failure(let error) :
      print(error)
    case .success(let value) :
      let json = JSON(value)
      var dict : [String:String] = [:]
      for key in self.getFields() {
        if let obj = json["elements"].array?[0][key].string {
          dict.updateValue(obj, forKey: key)
        }
      }
      DispatchQueue.main.async { [weak self] in
        self?.updateViewsWithData(data: dict)
      }
      
    }
  }

  @objc private func back(btn: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
  func updateViewsWithData(data : [String:String]) {
    fatalError("updateViewsWithData() has not been implemented")

  }
  func getUrl()->String{
    fatalError("getUrl() has not been implemented")

  }
  
  func getFields() -> [String]{
    fatalError("getFields() has not been implemented")
  }
  

}
