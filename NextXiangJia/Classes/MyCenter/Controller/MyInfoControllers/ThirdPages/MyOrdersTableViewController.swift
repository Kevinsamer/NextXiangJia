//
//  MyOrdersTableViewController.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/7/9.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SnapKit
private let tableViewCellID = "tableViewCellID"
class MyOrdersTableViewController: UIViewController, IndicatorInfoProvider{
    var orderNumbers:Int!
    var itemInfo: IndicatorInfo = ""
    //MARK: - 懒加载
    lazy var ordersTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.init(x: 0, y: finalStatusBarH + finalNavigationBarH, width: finalScreenW, height: finalContentViewNoTabbarH - 44), style: UITableViewStyle.plain)//44为buttonBarView的高度
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(UINib.init(nibName: "MyOrderTableViewCell", bundle: nil), forCellReuseIdentifier: tableViewCellID)
        //        self.tableView.contentInset = UIEdgeInsetsMake(finalNavigationBarH + finalStatusBarH, 0, 0, 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        return tableView
    }()
    
    lazy var noOrderButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.frame = CGRect(x: finalScreenW / 4, y: self.ordersTableView.centerY - finalScreenW / 2, width: finalScreenW / 2, height: finalScreenW / 2)
        button.setImageForAllStates(#imageLiteral(resourceName: "OrderList_NoOrder_Image"))
        button.setTitleForAllStates("您还没有相关订单")
        button.setTitleColorForAllStates(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
        button.setButtonTitleImageStyle(padding: 30, style: .ButtonImageTitleStyleTop)
        //button.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        return button
    }()
    
    //MARK: - 重写初始方法
    init(itemInfo: IndicatorInfo, orderNumbers:Int) {
        self.itemInfo = itemInfo
        self.orderNumbers = orderNumbers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
//MARK: - 设置ui
extension MyOrdersTableViewController{
    private func setUI(){
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        //1.初始化数据
        initData()
        //2.设置tableView
        setTableView()
    }
    
    private func setTableView(){
        self.view.addSubview(ordersTableView)
    }
    
    private func initData(){
        if self.orderNumbers == 0 {
            //无数据
            self.ordersTableView.addSubview(noOrderButton)
        }
    }
}

extension MyOrdersTableViewController:UITableViewDelegate,UITableViewDataSource{
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orderNumbers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellID, for: indexPath) as! MyOrderTableViewCell
        
        //cell.backgroundColor = UIColor.random
        cell.goodsNum = Int.random(between: 5, and: 20)
        if itemInfo.title == "已完成" {
            //            let textAttach = NSTextAttachment()
            //            textAttach.image = #imageLiteral(resourceName: "OrderList_FinishSign").scaled(toHeight: 50)?.scaled(toWidth: 50)
            //            textAttach.adjustsImageSizeForAccessibilityContentSizeCategory = true
            //            cell.orderStateLabel.attributedText = NSAttributedString(attachment: textAttach)
            let imageV = UIImageView(frame: CGRect(x: 0, y: -8, width: 40, height: 40))
            imageV.image = #imageLiteral(resourceName: "OrderList_FinishSign")
            imageV.contentMode = .scaleAspectFill
            cell.orderStateLabel.addSubview(imageV)
        }else {
            cell.orderStateLabel.text = itemInfo.title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //点击事件
    }
}
