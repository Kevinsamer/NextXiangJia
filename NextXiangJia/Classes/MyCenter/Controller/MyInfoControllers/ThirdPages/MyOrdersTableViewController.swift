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
import PullToRefreshKit
private let tableViewCellID = "tableViewCellID"
private let maxNumPerPage:Int = 20
class MyOrdersTableViewController: UIViewController, IndicatorInfoProvider{
    var orderNumbers:Int!
    var itemInfo: IndicatorInfo = ""
    var centerViewModel:MycenterViewModel = MycenterViewModel()
    var currentPage:Int = 1
    var oldY:CGFloat = 0
    ///当前所有的订单数组，上拉加载时直接替换为新数据
    var orders:[OrderModel]?{
        didSet{
            if let orderList = orders{
                if orderList.count == 0 {
                    self.ordersTableView.addSubview(noOrderButton)
                    self.ordersTableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    self.ordersTableView.switchRefreshFooter(to: FooterRefresherState.removed)
                }else{
                    noOrderButton.removeFromSuperview()
                    self.ordersTableView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
                    self.ordersTableView.switchRefreshFooter(to: FooterRefresherState.normal)
                }
                self.ordersTableView.reloadData()
            }
        }
    }
    
    //MARK: - 懒加载
//    lazy var backToTopButton: UIButton = {
//        //返回顶部按钮,弃用。双击状态栏返回顶部
//        let btn = UIButton(type: .custom)
//        btn.frame = CGRect(origin: CGPoint.init(x: finalScreenW - 50, y: finalContentViewNoTabbarH - 30), size: CGSize.init(width: 0, height: 0))
//        btn.layer.cornerRadius = 20
//        btn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        btn.layer.borderWidth = 1
//        btn.setImageForAllStates(#imageLiteral(resourceName: "backToTop"))
//        btn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        btn.isHidden = true
//        btn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
//        btn.addTarget(self, action: #selector(backToTop), for: .touchUpInside)
//        return btn
//    }()
    
    lazy var header: DefaultRefreshHeader = {
        let header = DefaultRefreshHeader.header()
        header.setText("下拉刷新", mode: .pullToRefresh)
        header.setText("释放刷新", mode: .releaseToRefresh)
        header.setText("数据刷新成功", mode: .refreshSuccess)
        header.setText("刷新中...", mode: .refreshing)
        header.setText("数据刷新失败，请检查网络设置", mode: .refreshFailure)
        header.tintColor = #colorLiteral(red: 0.9995891452, green: 0.6495086551, blue: 0.2688535452, alpha: 1)
        header.imageRenderingWithTintColor = true
        header.durationWhenHide = 0.4
        return header
    }()
    
    lazy var footer: DefaultRefreshFooter = {
        let footer = DefaultRefreshFooter.footer()
        footer.setText("上拉加载更多", mode: .pullToRefresh)
        footer.setText("到底啦", mode: .noMoreData)
        footer.setText("加载中...", mode: .refreshing)
        footer.setText("点击加载更多", mode: .tapToRefresh)
        footer.textLabel.textColor  = #colorLiteral(red: 0.9995891452, green: 0.6495086551, blue: 0.2688535452, alpha: 1)
        footer.refreshMode = .scroll
        return footer
    }()
    
    lazy var ordersTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.init(x: 0, y: finalStatusBarH + finalNavigationBarH, width: finalScreenW, height: finalContentViewNoTabbarH - 44), style: UITableViewStyle.plain)//44为buttonBarView的高度
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(UINib.init(nibName: "MyOrderTableViewCell", bundle: nil), forCellReuseIdentifier: tableViewCellID)
        //        self.tableView.contentInset = UIEdgeInsetsMake(finalNavigationBarH + finalStatusBarH, 0, 0, 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        tableView.showsVerticalScrollIndicator = false
        tableView.configRefreshHeader(with: header, container: self, action: {
            [unowned self] in
            self.currentPage = 1
            self.initData()
            tableView.reloadData {
                tableView.switchRefreshHeader(to: HeaderRefresherState.normal(RefreshResult.success, 0.3))
            }
        })
        
        tableView.configRefreshFooter(with: footer, container: self, action: {
            [unowned self] in
            self.currentPage += 1
            self.initData()
            tableView.reloadData()
            //tableView.layoutIfNeeded()
        })
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initData()
    }

    
}
//MARK: - 设置ui
extension MyOrdersTableViewController{
    private func setUI(){
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        //1.初始化数据
//        print(self.view.frame.height)
//        print(finalScreenH)
        initData()
        //2.设置tableView
        setTableView()
        //3.设置回到顶部按钮
        //setBackButton()
    }
    
//    private func setBackButton(){
//        self.view.addSubview(backToTopButton)
//    }
    
    private func setTableView(){
        self.view.addSubview(ordersTableView)
    }
    
    private func initData(){
        self.centerViewModel.requestOrderList(user_id: Int((AppDelegate.appUser?.user_id)!), page: currentPage, query_what: self.itemInfo.title!) { orderList in
            if self.currentPage == 1 {
                //page=1，下拉刷新事件
                self.orders = orderList
                if orderList.count < maxNumPerPage{
                    self.ordersTableView.switchRefreshFooter(to: FooterRefresherState.noMoreData)
                }else{
                    self.ordersTableView.switchRefreshFooter(to: FooterRefresherState.normal)
                }
            }else{
                //page>1，上拉加载事件
                if orderList.count == maxNumPerPage && orderList.last?.id != self.orders?.last?.id{
                    //如果请求到的数据条数=maxNumPerPage，且本页最后一条数据id和请求到的最后一条数据id不同，则未到最后一页，请求数据需添加至当前数据集合
                    self.orders?.append(orderList)
                    self.ordersTableView.switchRefreshFooter(to: FooterRefresherState.normal)
                }else if orderList.count == maxNumPerPage && orderList.last?.id == self.orders?.last?.id{
                    //如果请求到的数据条数=maxNumPerPage，且本页最后一条数据id和请求到的最后一条数据id相同，则已到最后一页，请求数据无需添加至当前数据集合
                    self.ordersTableView.switchRefreshFooter(to: FooterRefresherState.noMoreData)
                }else{
                    //如果请求到的数据条数<maxNumPerPage，则已到最后一页，请求数据无需添加至当前数据集合
                    self.orders?.append(orderList)
                    self.ordersTableView.switchRefreshFooter(to: FooterRefresherState.noMoreData)
                }
            }
            
        }
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
            }else if (orderList[indexPath.row].distribution_status == 1 || orderList[indexPath.row].distribution_status == 0) && orderList[indexPath.row].status == 2 {
                cell.orderStateLabel.text = "待收货"
            }else if orderList[indexPath.row].status == 5 {
                let imageV = UIImageView(frame: CGRect(x: 0, y: -8, width: 40, height: 40))
                imageV.image = #imageLiteral(resourceName: "OrderList_FinishSign")
                imageV.contentMode = .scaleAspectFill
                cell.orderStateLabel.text = nil
                cell.orderStateLabel.addSubview(imageV)
            }else if orderList[indexPath.row].status == 3 || orderList[indexPath.row].status == 4 {
                cell.orderStateLabel.text = "已取消"
            }
        }
        
        //cell.goodsNum = Int.random(between: 5, and: 20)
        
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
        self.navigationController?.show(vc, sender: self)
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//    //屏幕滑动方向区分
//        let newY = scrollView.contentOffset.y
//        //print(newY)
////        if newY >= finalScreenH{
////            if oldY != newY{
////                if newY > oldY {
////                    //                print("屏幕向上滑动")
////                    dismissButton()
////                }else{
////                    //                print("屏幕向下滑动")
////                    showButton()
////                }
////            }
////            oldY = newY
////        }else{
////            dismissButton()
////        }
//        if newY > finalScreenH {
//            showButton()
//        }else{
//            dismissButton()
//        }
//    }
}

//extension MyOrdersTableViewController{
//    @objc private func backToTop(){
//        self.ordersTableView.setContentOffset(CGPoint.zero, animated: true)
//    }
//
//    private func showButton(){
//        if self.backToTopButton.frame.width != 40 {
//            self.backToTopButton.isHidden = false
//            UIView.animate(withDuration: 0.5) {
//                self.backToTopButton.size = CGSize(width: 40, height: 40)
//            }
//        }
//    }
//
//    private func dismissButton(){
//        if self.backToTopButton.frame.width != 0{
//            UIView.animate(withDuration: 0.5, animations: {
//                self.backToTopButton.size = CGSize.zero
//            }) { (flag) in
//            }
//        }
//    }
//}

