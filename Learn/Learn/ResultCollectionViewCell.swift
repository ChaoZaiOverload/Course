//
//  ResultCollectionViewCell.swift
//  Learn
//
//  Created by Yu, Huiting on 3/14/18.
//  Copyright © 2018 Huiting Yu. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class ResultCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var detailLabel: UILabel!
    
    private var result: ResultBase?
    
    private func updateViews() {
        if let imageUrl = self.result?.imageUrl {
            self.imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "result_placeholder"))
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
        self.imageView.sd_cancelCurrentImageLoad()
        self.titleLabel.text = nil
        self.detailLabel.text = nil
    }
}
