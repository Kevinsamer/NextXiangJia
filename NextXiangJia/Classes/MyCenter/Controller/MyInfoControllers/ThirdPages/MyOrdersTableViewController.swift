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
    var centerViewModel:MycenterViewModel = MycenterViewModel()
    var page:Int = 1
    ///当前所有的订单数组，上拉加载时直接替换为新数据
    var orders:[OrderModel]?{
        didSet{
            if let orderList = orders{
                if orderList.count == 0 {
                    self.ordersTableView.addSubview(noOrderButton)
                    self.ordersTableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                }else{
                    self.ordersTableView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
                }
                self.ordersTableView.reloadData()
            }
        }
    }
    
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
        self.centerViewModel.requestOrderList(user_id: Int((AppDelegate.appUser?.user_id)!), page: page, query_what: self.itemInfo.title!) { orderList in
            self.orders = orderList
        }
        
        
//        if self.orderNumbers == 0 {
//            //无数据
//            self.ordersTableView.addSubview(noOrderButton)
//            self.ordersTableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        }
    }
}

extension MyOrdersTableViewController:UITableViewDelegate,UITableViewDataSource{
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.orders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellID, for: indexPath) as! MyOrderTableViewCell
        cell.selectionStyle = .none
        //cell.backgroundColor = UIColor.random
        if let orderList = self.orders {
            self.centerViewModel.requestOrderGoodsList(order_id: orderList[indexPath.row].id) { goodsList in
                cell.pics = [String]()
                for goods in goodsList {
                    cell.pics.append(goods.img)
                }
                cell.goodsNumLabel.text = "共\(goodsList.count)件商品"
            }
            cell.orderTimeLabel.text = orderList[indexPath.row].create_time
            cell.orderCodeLabel.text = orderList[indexPath.row].order_no
            cell.totalPriceLabel.text = "￥\(orderList[indexPath.row].order_amount)"
//            if itemInfo.title == "已完成" {
//                let imageV = UIImageView(frame: CGRect(x: 0, y: -8, width: 40, height: 40))
//                imageV.image = #imageLiteral(resourceName: "OrderList_FinishSign")
//                imageV.contentMode = .scaleAspectFill
//                cell.orderStateLabel.addSubview(imageV)
//            }else if itemInfo.title == "全部"{
//
//            }else {
//                cell.orderStateLabel.text = itemInfo.title
//            }
            if orderList[indexPath.row].status == 1 && orderList[indexPath.row].pay_status == 0 {
                cell.orderStateLabel.text = "待支付"
            }else if orderList[indexPath.row].distribution_status == 1 || orderList[indexPath.row].distribution_status == 2 {
                cell.orderStateLabel.text = "待收货"
            }else if orderList[indexPath.row].status == 5 {
                let imageV = UIImageView(frame: CGRect(x: 0, y: -8, width: 40, height: 40))
                imageV.image = #imageLiteral(resourceName: "OrderList_FinishSign")
                imageV.contentMode = .scaleAspectFill
                cell.orderStateLabel.addSubview(imageV)
            }else if orderList[indexPath.row].status == 3 || orderList[indexPath.row].status == 4 {
                cell.orderStateLabel.text = "已取消"
            }
        }
        
        cell.goodsNum = Int.random(between: 5, and: 20)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    
//    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //点击事件
        let vc = OrderDetailViewController()
        vc.order_id = self.orders![indexPath.row].id
        //TODO:修改服务器代码，返回订单详情数据
        self.navigationController?.show(vc, sender: self)
    }
}
