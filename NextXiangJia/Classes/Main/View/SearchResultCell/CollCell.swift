//
//  CollCell.swift
//  tableViewInNav
//
//  Created by DEV2018 on 2018/6/12.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit

class CollCell: UICollectionViewCell {
    @IBOutlet var ImageView: UIImageView!
    @IBOutlet var GoodsInfo: UILabel!
    @IBOutlet var NewPrice: UILabel!
    @IBOutlet var OldPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
