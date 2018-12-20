//
//  OrderDetailViewController.swift
//  NextXiangJia
//  订单详情
//  Created by DEV2018 on 2018/7/11.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import FontAwesome_swift
import Kingfisher
import PullToRefreshKit
private let tableCellH:CGFloat = 95
private let tableCellID = "tableCellID"
private let footerViewID = "footerViewID"
private let headerViewH:CGFloat = 160
private let footerViewH:CGFloat = 330
private let bottomViewH:CGFloat = 60
class OrderDetailViewController: UIViewController {
    let centerViewModel:MycenterViewModel = MycenterViewModel()
    var order_id:Int = 0
    var orderModel:OrderModel?{
        didSet{
            self.orderGoodsTabelView.reloadData{
                self.orderGoodsTabelView.switchRefreshHeader(to: HeaderRefresherState.normal(RefreshResult.success, 0.3))
            }
            if let order = orderModel {
                if order.status == 1 && order.pay_status == 0 {
                    orderState = "待支付"
                    nextStepButton.addTarget(self, action: #selector(goToPay), for: .touchUpInside)
                }else if (order.distribution_status == 1 || order.distribution_status == 0) && order.status == 2{
                    orderState = "待收货"
                    cancelOrderButton.removeFromSuperview()
                    nextStepButton.setTitleForAllStates("确认收货")
                    nextStepButton.addTarget(self, action: #selector(confirmGot), for: .touchUpInside)
                }else if order.status == 5 {
                    orderState = "已完成"
                    cancelOrderButton.removeFromSuperview()
                    nextStepButton.setTitleForAllStates("再次购买")
                    nextStepButton.addTarget(self, action: #selector(buyAgain), for: .touchUpInside)
//                    bottomView.removeFromSuperview()
                }else if order.status == 3 || order.status == 4{
                    orderState = "已取消"
                    cancelOrderButton.removeFromSuperview()
                    nextStepButton.setTitleForAllStates("再次购买")
                    nextStepButton.addTarget(self, action: #selector(buyAgain), for: .touchUpInside)
//                    bottomView.removeFromSuperview()
                }
                name = order.accept_name
                phone = YTools.changePhoneNum(phone: "\(order.mobile)")
                address = "\(order.province_str)\(order.city_str)\(order.area_str) \(order.address)"
                
                orderStateLabel.text = orderState
                orderStateFALabel.text = String.fontAwesomeIcon(name: orderState == "已完成" ? .checkCircle : .exclamationCircle)
                nameAndPhoneBtn.setTitleForAllStates(name + "   " + phone)
                addressLabel.text = "地址：" + address
            }
            
        }
    }
    
    var goodsList:[OrderGoodsListModel]?{
        didSet{
//            if let goodList = goodsList{
//
//            }
            self.orderGoodsTabelView.reloadData()
        }
    }
    var orderState:String = ""
    var name = ""
    var phone = ""
    var address = ""
    //MARK: - 懒加载
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
    
    lazy var cancelAlert: UIAlertController = {
        let alert = UIAlertController(title: "订单取消后无法恢复，确认取消？", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
        return alert
    }()
    
    lazy var cancelOKAction: UIAlertAction = {
        let action = UIAlertAction(title: "确认", style: UIAlertActionStyle.default, handler: { (action) in
            DispatchQueue.main.async {
                self.initData()
            }
        })
        return action
    }()
    
    lazy var cancelOrderButton: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.frame = CGRect(x: 10, y: 15, width: 120, height: 30)
        btn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        btn.setTitleColorForAllStates(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        btn.setTitleForAllStates("取消订单")
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        btn.layer.cornerRadius = 20
        btn.layer.borderWidth = 1
        btn.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        btn.addTarget(self, action: #selector(cancelOrder), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    lazy var nextStepButton: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.frame = CGRect(x: finalScreenW - 130, y: 15, width: 120, height: 30)
        btn.backgroundColor = .red
        btn.setTitleColorForAllStates(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        btn.setTitleForAllStates("去支付")
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    
    lazy var bottomLineView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: finalScreenW, height: 1))
        view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        return view
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: UIDevice.current.isX() ? self.view.frame.height - bottomViewH - IphonexHomeIndicatorH : self.view.frame.height - bottomViewH, width: finalScreenW, height: bottomViewH))
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    
    lazy var topBackImgView: UIImageView = {
        //topBgView
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: finalScreenW, height: 100))
        view.image = #imageLiteral(resourceName: "order_detail_headerBg")
        return view
    }()
    
    lazy var orderStateLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 50, y: 20, width: 100, height: 30))
        //label.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        label.text = orderState
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var orderStateFALabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 20, width: 30, height: 30))
        //label.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        label.font = UIFont.fontAwesome(ofSize: 22, style: .solid)
        label.text = String.fontAwesomeIcon(name: orderState == "已完成" ? .checkCircle : .exclamationCircle)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.textAlignment = .right
        return label
    }()
    
    lazy var addressView: UIView = {
        let view = UIView(frame : CGRect(x: 20, y: 60, width: finalScreenW - 40, height: 80))
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.layer.shadowRadius = 5
        view.layer.cornerRadius = 10
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return view
    }()
    
    lazy var nameAndPhoneBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 10, y: 10, width: finalScreenW - 60, height: 30)
        //btn.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        btn.setImageForAllStates(#imageLiteral(resourceName: "address_icon_desel"))
        btn.setTitleForAllStates(name + "   " + phone)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15).monospaced.bold
        btn.contentHorizontalAlignment = .leading
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        btn.setTitleColorForAllStates(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        return btn
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 30, y: 40, width: finalScreenW - 80, height: 30))
        //label.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        label.text = "地址：" + address
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 13).monospaced
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    lazy var orderGoodsTabelView: UITableView = {
        let table = UITableView(frame: CGRect.init(x: 0, y: finalStatusBarH + finalNavigationBarH, width: finalScreenW, height: finalContentViewNoTabbarH - bottomViewH), style: UITableViewStyle.grouped)
        table.delegate = self
        table.dataSource = self
        table.alwaysBounceVertical = true
        table.allowsSelection = true
        //table.contentInset = UIEdgeInsetsMake(0, 0, footerViewH, 0)
        //TODO: - head悬停
        table.register(UINib.init(nibName: "FillOrderGoodsCell", bundle: nil), forCellReuseIdentifier: tableCellID)
        table.register(UINib.init(nibName: "OrderDetailFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: footerViewID)
        table.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        table.configRefreshHeader(with: header, container: self, action: {
            DispatchQueue.main.async {
                self.initData()
            }
        })
        
        
        return table
    }()
    
    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: finalScreenW, height: headerViewH))
        return view
    }()
    
    lazy var footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: finalScreenW, height: footerViewH))
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        self.navigationController?.navigationBar.tintColor = .black
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
//        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
//    }
//
//
//
//    override func viewWillDisappear(_ animated: Bool) {
//
//        super.viewWillDisappear(animated)
//        self.navigationController?.navigationBar.barTintColor = UIColor(named: "navibar_bartint_orange")
//        self.navigationController?.navigationBar.tintColor = .white
//            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18)]
//        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
//    }
}
//MARK: - 设置ui
extension OrderDetailViewController {
    private func setUI(){
        //1.初始化数据
        initData()
        //2.设置主体view
        setContentView()
        
    }
    
    private func setContentView(){
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationItem.title = "订单详情"
        topBackImgView.addSubview(orderStateLabel)
        topBackImgView.addSubview(orderStateFALabel)
        headerView.addSubview(topBackImgView)
        addressView.addSubview(nameAndPhoneBtn)
        addressView.addSubview(addressLabel)
        headerView.addSubview(addressView)
        bottomView.addSubview(bottomLineView)
        bottomView.addSubview(nextStepButton)
        bottomView.addSubview(cancelOrderButton)
        self.view.addSubview(bottomView)
        self.view.addSubview(orderGoodsTabelView)
        self.cancelAlert.addAction(self.cancelOKAction)
        //self.orderGoodsTabelView.contentInset = UIEdgeInsetsMake(0, 0, -footerViewH, 0)
    }
    
    private func initData(){
        self.centerViewModel.requestOrderDetail(order_id: self.order_id) { orderModel in
            self.orderModel = orderModel
            
        }
        self.centerViewModel.requestOrderGoodsList(order_id: self.order_id) { (goodsList) in
            self.goodsList = goodsList
        }
        
    }
}

extension OrderDetailViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goodsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellID) as! FillOrderGoodsCell
        cell.selectionStyle = .none
        cell.goodsImageView.kf.setImage(with: URL.init(string: BASE_URL + "\(self.goodsList![indexPath.row].img)"), placeholder: UIImage.init(named: "loading"))
        cell.goodsNameLabel.attributedText = "\(self.goodsList![indexPath.row].goodsArrayModel?.name ?? "商品名称")".bold
        cell.goodsStandardsLabel.text = "\(self.goodsList![indexPath.row].goodsArrayModel?.value ?? "规格信息")"
        cell.goodsPriceLabel.attributedText = YTools.changePrice(price: "￥\(self.goodsList![indexPath.row].goods_price)", fontNum: 14)
        cell.goodsNumLabel.text = "x\(self.goodsList![indexPath.row].goods_nums)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableCellH
    }
    //添加头尾视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerViewID) as! OrderDetailFooterView
        //footer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        footer.orderCodeLabel.text = "\(self.orderModel?.order_no ?? "订单编号")"
        footer.orderTimeLabel.text = "\(self.orderModel?.create_time ?? "下单时间")"
        footer.orderPriceLabel.text = "￥\(self.orderModel?.goods_amount ?? 0.0)"
        footer.orderDaijinLabel.text = "-￥\(self.orderModel?.promotions ?? 0.0)"
        footer.orderShuijinLabel.text = "+￥\(self.orderModel?.taxes ?? 0.0)"
        footer.orderYunfeiLabel.text = "+￥\(self.orderModel?.payable_freight ?? 0.0)"
        footer.orderBaojiaLabel.text = "+￥\(self.orderModel?.insured ?? 0.0)"
        footer.orderShouXuFeiLabel.text = "+￥\(self.orderModel?.pay_fee ?? 0.0)"
        footer.orderTotalPriceLabel.text = "￥\(self.orderModel?.order_amount ?? 0.0)"
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerViewH
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerViewH
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        YTools.pushToGoodsDetail(goodsID: goodsList![indexPath.row].goods_id, navigationController: self.navigationController, sender: self)
    }
    
//    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
    
}

extension OrderDetailViewController{
    ///跳转支付
    @objc private func goToPay(){
        let vc = PayViewController()
        vc.orderModel = orderModel
        self.navigationController?.show(vc, sender: self)
    }
    ///确认收货
    @objc private func confirmGot(){
        self.centerViewModel.requestOrderStatus(order_id: self.order_id, op: "confirm") {[unowned self] in
            DispatchQueue.main.async {
                self.initData()
            }
        }
    }
    
    ///取消订单
    @objc private func cancelOrder(){
        self.centerViewModel.requestOrderStatus(order_id: self.order_id, op: "cancel") {[unowned self] in
            self.cancelAlert.show()
        }
    }
    
    @objc private func buyAgain(){
        //print(self.goodsList?.first?.id)
        YTools.pushToGoodsDetail(goodsID: (self.goodsList?.first?.goods_id)!, navigationController: self.navigationController, sender: self)
    }
}
