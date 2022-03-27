//
//  ViewController.swift
//  Learn
//
//  Created by Huiting Yu on 10/15/16.
//  Copyright © 2016 Huiting Yu. All rights reserved.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {
  
  private lazy var searchBar = UISearchBar()
  private lazy var flowLayout: UICollectionViewFlowLayout = {
    let f = UICollectionViewFlowLayout()
//    let spacing: CGFloat = 8
//    let width = (UIScreen.main.bounds.size.width - spacing) / 2
//    f.itemSize = CGSize(width: width, height: width)
    f.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: 50)
    return f
  }()
  
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
  private lazy var interactor = ViewControllerInteractor(courseNetworker: CourseNeworkerJsonConvertible())
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.viewController = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    view.backgroundColor = .white
    searchBar.delegate = self
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .white
    collectionView.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: "ResultCollectionViewCellIdentifier")
    view.addSubview(searchBar)
    view.addSubview(collectionView)
    searchBar.snp.makeConstraints { (make) in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.left.right.equalToSuperview()
      make.height.equalTo(44)
    }
    collectionView.snp.makeConstraints { (make) in
      make.top.equalTo(searchBar.snp.bottom)
      make.right.left.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  func refreshUI() {
    collectionView.reloadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}

extension ViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    interactor.query(query: searchBar.text ?? "", isNewQuery: true)
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    interactor.query(query: searchBar.text ?? "", isNewQuery: true)
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    interactor.reset()
  }
}


extension ViewController: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return interactor.items.count
  }
  
  // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultCollectionViewCellIdentifier", for: indexPath) as? ResultCollectionViewCell else {
      return UICollectionViewCell()
    }
    cell.updateResult(result: interactor.items[indexPath.item])
    return cell
  }
}

extension ViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if indexPath.item == interactor.items.count - 1 {
      interactor.query(query: searchBar.text ?? "", isNewQuery: false)
    }
  }
}


