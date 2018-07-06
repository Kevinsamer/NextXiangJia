//
//  FillOrderGoodsCell.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/7/4.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit

class FillOrderGoodsCell: UITableViewCell {
    @IBOutlet var goodsImageView: UIImageView!
    @IBOutlet var goodsNumLabel: UILabel!
    @IBOutlet var goodsPriceLabel: UILabel!
    @IBOutlet var goodsStandardsLabel: UILabel!
    @IBOutlet var goodsNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        goodsPriceLabel.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
