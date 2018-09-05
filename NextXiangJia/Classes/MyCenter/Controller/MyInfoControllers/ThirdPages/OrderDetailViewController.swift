//
//  OrderDetailViewController.swift
//  NextXiangJia
//  订单详情
//  Created by DEV2018 on 2018/7/11.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import FontAwesome_swift
private let tableCellH:CGFloat = 95
private let tableCellID = "tableCellID"
private let footerViewID = "footerViewID"
private let headerViewH:CGFloat = 160
private let footerViewH:CGFloat = 330
class OrderDetailViewController: UIViewController {
    var goodsNum:Int = 0
    var orderState:String = ""
    var name = ""
    var phone = ""
    var address = ""
    //MARK: - 懒加载
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
        let table = UITableView(frame: CGRect.init(x: 0, y: finalStatusBarH + finalNavigationBarH, width: finalScreenW, height: finalContentViewNoTabbarH), style: UITableViewStyle.grouped)
        table.delegate = self
        table.dataSource = self
        table.alwaysBounceVertical = true
        table.allowsSelection = false
        //TODO: - head悬停
        table.register(UINib.init(nibName: "FillOrderGoodsCell", bundle: nil), forCellReuseIdentifier: tableCellID)
        table.register(UINib.init(nibName: "OrderDetailFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: footerViewID)
        table.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
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
        self.view.addSubview(orderGoodsTabelView)
    }
    
    private func initData(){
        goodsNum = Int.random(between: 1, and: 10)
        orderState = "已取消"
        
        name = "余志超"
        phone = YTools.changePhoneNum(phone: "13160107520")
        address = "江苏常州市武进区花园街200 传媒大厦"
    }
}

extension OrderDetailViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goodsNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellID) as! FillOrderGoodsCell
        cell.goodsImageView.image = UIImage(named: "\(indexPath.row)")
        cell.goodsNameLabel.attributedText = "小米（MI）小米8SE手机 双卡双待  金色  全网通 *********".bold
        cell.goodsStandardsLabel.text = "颜色：金色   版本：全网通（6G RAM + 64G ROM）"
        cell.goodsPriceLabel.attributedText = YTools.changePrice(price: "￥1899.00", fontNum: 14)
        cell.goodsNumLabel.text = "x\(indexPath.row)"
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
        footer.orderCodeLabel.text = "11111111111111"
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerViewH
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerViewH
    }
    
}
