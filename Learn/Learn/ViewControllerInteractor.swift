//
//  ViewControllerInteractor.swift
//  Learn
//
//  Created by Yu, Huiting on 3/14/18.
//  Copyright © 2018 Huiting Yu. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerInteractor {
  private(set) var items: [ResultBase] = []
  
  private var query : String?
  private var total : Int = 0
  private var start : Int = 0
  
  private let networker: CourseNetworkable
  
  weak var viewController: ViewController?
  
  init(courseNetworker: CourseNetworkable) {
    networker = courseNetworker
  }
  
  func query(query: String, isNewQuery: Bool) {
    guard !query.isEmpty else {
      reset()
      return
    }
    if isNewQuery {
      reset()
    }
    self.query = query
    doQuery()
  }
  
  func reset() {
    total = 0
    start = 0
    items = []
    self.viewController?.refreshUI()
  }
  
  private func doQuery() {
    guard let query = query , self.hasMore(), !query.isEmpty else {
      return
    }
    
    networker.query(query, start: start) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        self.start = response.next ?? Int.max
        self.total = response.total ?? 0
        self.items.append(contentsOf: response.results)
        self.viewController?.refreshUI()
      case .failure( _):
        self.reset()
      }
    }
  }
  
  private func hasMore() -> Bool {
    return start < total || total == 0
  }
}

