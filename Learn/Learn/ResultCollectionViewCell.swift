//
//  ResultCollectionViewCell.swift
//  Learn
//
//  Created by Yu, Huiting on 3/14/18.
//  Copyright © 2018 Huiting Yu. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ResultCollectionViewCell: UICollectionViewCell {
  private var imageManager = NativeImageWorker()
  
  private lazy var imageView = UIImageView()
  private lazy var titleLabel = UILabel()
  private lazy var detailLabel = UILabel()
  private lazy var stackView: UIStackView = {
    let v = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
    v.alignment = .leading
    v.axis = .vertical
    v.spacing = 2
    return v
  }()
  
  private var result: ResultBase?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(imageView)
    contentView.addSubview(stackView)
    
    imageView.snp.makeConstraints { (make) in
      make.left.equalToSuperview().offset(5)
      make.height.width.equalTo(40)
      make.centerY.equalToSuperview()
    }
    stackView.snp.makeConstraints { (make) in
      make.left.equalTo(imageView.snp.right).offset(8)
      make.right.lessThanOrEqualToSuperview()
      make.top.bottom.equalToSuperview().inset(5)
    }
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func updateViews() {
//    if let imageUrl = self.result?.imageUrl {
//      self.imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "result_placeholder"))
//    }
    self.imageView.image = UIImage(named: "result_placeholder")!
    
    if let imageurl = self.result?.imageUrl,
       let url = URL(string: imageurl) {
      imageManager.loadImage(url: url, placeholder: UIImage(named: "result_placeholder")!) { (img) in
        if let img = img, url.absoluteString == self.result?.imageUrl {
          self.imageView.image = img
        } else if img != nil, url.absoluteString != self.result?.imageUrl {
          print("previous url:\(url.absoluteString), current:\(self.result?.imageUrl)")
        }
      }
    }
    self.titleLabel.text = self.result?.name
    self.detailLabel.text = self.result?.partnerName
  }
  
  func updateResult(result : ResultBase) {
    self.result = result
    self.updateViews()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
//    self.imageView.sd_cancelCurrentImageLoad()
    self.imageView.image = nil
    self.titleLabel.text = nil
    self.detailLabel.text = nil
  }
}
