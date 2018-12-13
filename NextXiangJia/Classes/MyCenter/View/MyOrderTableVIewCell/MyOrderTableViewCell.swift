//
//  MyOrderTableViewCell.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/7/9.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import Kingfisher
private let goodsCollCellID = "goodsCollCellID"
class MyOrderTableViewCell: UITableViewCell {
    var goodsNum:Int!
    var pics:[String] = [String](){
        didSet{
            self.myOrderGoodsCollView.reloadData()
        }
    }
    @IBOutlet var orderTimeLabel: UILabel!//订单时间
    @IBOutlet var orderCodeLabel: UILabel!//订单编号
    @IBOutlet var totalPriceLabel: UILabel!//总价
    @IBOutlet var goodsNumLabel: UILabel!//商品数量
    @IBOutlet var orderStateLabel: UILabel!//订单状态(已完成，已取消，待付款，待收货)
    @IBOutlet var myOrderGoodsCollView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        myOrderGoodsCollView.register(UINib.init(nibName: "GoodsImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: goodsCollCellID)
        //myOrderGoodsCollView.register(GoodsImageCollectionViewCell.self, forCellWithReuseIdentifier: goodsCollCellID)
        myOrderGoodsCollView.delegate = self
        myOrderGoodsCollView.dataSource = self
        myOrderGoodsCollView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        myOrderGoodsCollView.showsHorizontalScrollIndicator = false
        myOrderGoodsCollView.alwaysBounceHorizontal = true
        orderTimeLabel.adjustsFontSizeToFitWidth = true
        orderCodeLabel.adjustsFontSizeToFitWidth = true
        totalPriceLabel.adjustsFontSizeToFitWidth = true
        goodsNumLabel.adjustsFontSizeToFitWidth = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        
    }
    
}

extension MyOrderTableViewCell:UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: goodsCollCellID, for: indexPath) as! GoodsImageCollectionViewCell
        //let image = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        cell.goodsImageView.kf.setImage(with: URL.init(string: "\(BASE_URL)\(pics[indexPath.row])"), placeholder: UIImage.init(named: "loading"))
        //cell.addSubview(image)
        cell.backgroundColor = UIColor.random
        return cell
    }
    
    
}


