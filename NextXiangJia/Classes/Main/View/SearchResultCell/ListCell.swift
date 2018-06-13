//
//  ListCell.swift
//  tableViewInNav
//
//  Created by DEV2018 on 2018/6/12.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit

class ListCell: UICollectionViewCell {

    @IBOutlet var OldPrice: UILabel!
    @IBOutlet var NewPrice: UILabel!
    @IBOutlet var GoodsInfo: UILabel!
    @IBOutlet var ImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
