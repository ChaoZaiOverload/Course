//
//  ViewController.swift
//  Learn
//
//  Created by Huiting Yu on 10/15/16.
//  Copyright © 2016 Huiting Yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {
    
    lazy var operationQueue :OperationQueue = {
        var queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue}()
    
    var searchBar:UISearchBar = UISearchBar()
    var tableView:UITableView = UITableView()
    var dataSource:TableViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(searchBar)
        self.searchBar.frame.size.width = self.view.frame.width-10
        self.searchBar.frame.origin = CGPoint.init(x: 5, y: 5)
        self.searchBar.frame.size.height = 44
        self.searchBar.placeholder = "search for courses..."
        self.searchBar.showsCancelButton = true
        self.searchBar.delegate = self
        
        self.view.addSubview(tableView)
        self.tableView.frame.origin = CGPoint.init(x: 0, y: 54)
        self.tableView.frame.size.width = self.view.frame.width
        self.tableView.frame.size.height = self.view.frame.height - 54
        self.tableView.delegate = self
        self.dataSource = TableViewDataSource(callback: {result in
            switch(result) {
            case .Success:
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                break
            case .Failure(let error):
                print(error)
            }
        })
        self.tableView.dataSource =  self.dataSource
        self.tableView.register(CourseTableViewCell.self, forCellReuseIdentifier: CourseTableViewCell.identifier)
        self.tableView.register(LoadingCell.self, forCellReuseIdentifier: LoadingCell.identifier)
        self.tableView.register(SpecializationTableViewCell.self, forCellReuseIdentifier: SpecializationTableViewCell.identifier)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if let loadingCell = cell as? LoadingCell{
            loadingCell.startAnimation()
            self.dataSource!.loadMore()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.dataSource?.results[indexPath.row] is Course) {
            self.present(CourseDetailsViewController(result: self.dataSource!.results[indexPath.row]), animated: true, completion: nil)
        } else if (self.dataSource?.results[indexPath.row] is Specialization) {
            self.present(SpecDetailsViewController(result: self.dataSource!.results[indexPath.row]), animated: true, completion: nil)
            
        } else {
            
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.dataSource!.newQuery(query: searchBar.text)
    }
    
    
    
    
}

