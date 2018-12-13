//
//  GoodsImageCollectionViewCell.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/12/5.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit

class GoodsImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet var goodsImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        goodsImageView.contentMode = .scaleToFill
    }

}
