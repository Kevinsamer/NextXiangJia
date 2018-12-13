//
//  PayViewController.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/11/20.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import SwiftyJSON
private let tableCell:String = "tableCell"
class PayViewController: UIViewController {
    var biz:BizContent = BizContent()
    var orderViewModel:OrderViewModel = OrderViewModel()
    var out_trade_no:String = ""
    var totalPayResult:Bool = false
    ///提交订单后接收的resultModel
    var postOrderResultModel:PostOrderResultModel?{
        didSet{
            if let result = postOrderResultModel {
//                finalSumLabel.text = "\(result.final_sum)元"
//                confirmPay.setTitleForAllStates("确认支付\(result.final_sum)元")
                final_sum = result.final_sum
                order_ids = result.orderIdArray
                
            }
        }
    }
    ///我的订单中结算时接收的订单model
    var orderModel:OrderModel?{
        didSet{
            if let order = orderModel{
                final_sum = order.order_amount
                order_ids.append(order.id)
            }
        }
    }
    
    var final_sum:Double = 0{
        didSet{
            finalSumLabel.text = "\(final_sum)元"
            confirmPay.setTitleForAllStates("确认支付\(final_sum)元")
            biz.total_amount = "\(final_sum.format(f: ".2"))"
        }
    }
    
    var order_ids:[Int] = [Int](){
        didSet{
            for id in order_ids{
                out_trade_no += "\(id)"
            }
            biz.out_trade_no = out_trade_no
        }
    }
    
    
    
    
    //MARK: - 懒加载
    lazy var payingAlert: UIAlertController = {
        let alert = UIAlertController(title: "支付处理中,请稍等", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction.init(title: "返回我的订单查看支付结果", style: UIAlertActionStyle.cancel, handler: { (action) in
            let vc = MyOrdersViewController()
            vc.isFromPayVC = true
            self.navigationController?.show(vc, sender: self)
        }))
        return alert
    }()
    
    lazy var failedAlert: UIAlertController = {
        let alert = UIAlertController(title: "支付失败", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction.init(title: "重新支付", style: UIAlertActionStyle.cancel, handler: nil))
        return alert
    }()
    
    lazy var successAlert: UIAlertController = {
        let alert = UIAlertController(title: "支付成功", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction.init(title: "确认", style: UIAlertActionStyle.default, handler: { (action) in
            let vc = MyOrdersViewController()
            vc.isFromPayVC = true
            self.navigationController?.show(vc, sender: self)
        }))
        return alert
    }()
    
    lazy var contentTabelView: UITableView = {
        let table = UITableView(frame: CGRect.init(x: 0, y: finalStatusBarH + finalNavigationBarH, width: finalScreenW, height: finalScreenH), style: UITableViewStyle.grouped)
        table.alwaysBounceVertical = true
        table.allowsSelection = false
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        table.separatorStyle = .none
        table.register(UITableViewCell.self, forCellReuseIdentifier: tableCell)
        return table
    }()
    
    lazy var needPayLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: 80, height: 60))
        label.text = "需支付:"
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    lazy var finalSumLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 110, y: 0, width: 200, height: 60))
        label.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        label.textAlignment = .left
        label.text = "999.99元"
        return label
    }()
    
    lazy var zfbImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: finalScreenW, height: 100))
        imageView.image = #imageLiteral(resourceName: "zfb")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var confirmPay: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.frame = CGRect(x: 20, y: 25, width: finalScreenW - 40, height: 50)
        btn.setTitleForAllStates("确认支付999.99元")
        btn.setTitleColorForAllStates(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        btn.backgroundColor = UIColor.init(named: "global_orange")
        btn.titleLabel?.textAlignment = .center
        btn.addTarget(self, action: #selector(doPay), for: .touchUpInside)
        return btn
    }()
    
    lazy var leftBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: #imageLiteral(resourceName: "btnBack"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelPay))
        return item
    }()
    
    lazy var goOnPayAction: UIAlertAction = {
        let action = UIAlertAction(title: "继续支付", style: UIAlertActionStyle.cancel, handler: { (action) in
            
        })
        return action
    }()
    
    lazy var cancelPayAction: UIAlertAction = {
        let action = UIAlertAction(title: "确认离开", style: UIAlertActionStyle.default, handler: { (action) in
            let vc = MyOrdersViewController()
            vc.isFromPayVC = true
            self.navigationController?.show(vc, sender: self)
        })
        return action
    }()
    
    lazy var cancelAlert: UIAlertController = {
        let alert = UIAlertController(title: "确认要取消支付？", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(goOnPayAction)
        alert.addAction(cancelPayAction)
        return alert
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //离开时开启侧滑
        self.navigationItem.hidesBackButton = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //关闭侧滑
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    deinit {
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }
}

extension PayViewController{
    private func setUI(){
        //0.修改背景色
        self.view.backgroundColor = .white
        //1.设置导航栏
        setNavigationBar()
        //2.设置table
        setTableView()
        //3.添加支付结果通知接收器
        self.addNotificationObserver(name: ALiPayResultNotificationName, selector: #selector(payResultAction))
    }
    
    private func setNavigationBar(){
        //navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = "支付订单"
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    private func setTableView(){
        self.view.addSubview(contentTabelView)
    }
}

extension PayViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCell, for: indexPath)
        cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        if indexPath.section == 0 {
            //需支付
            cell.addSubview(needPayLabel)
            cell.addSubview(finalSumLabel)
        }else if indexPath.section == 1{
            //支付宝图片
            cell.addSubview(zfbImageView)
        }else if indexPath.section == 2 {
            cell.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
            cell.addSubview(confirmPay)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        }
        return 5
    }
    
}

extension PayViewController {
    @objc private func doPay(){
        //调起支付宝
        AlipaySDK.defaultService().payOrder(AliSDKManager.signInfo(bizContent: biz), fromScheme: "xiangjiamall") { (resultDic) in
            //支付结果回调Block，用于wap支付结果回调（非跳转钱包支付）
            //print(resultDic)
            NotificationCenter.default.post(name: ALiPayResultNotificationName, object: self, userInfo: resultDic)
        }
//        for id in self.order_ids{
//            orderViewModel.requestUpdateOrder(order_id: id, status: 2, finishCallback: { (updateResult) in
//                self.totalPayResult = updateResult
//            })
//        }
        
    }
    
    @objc private func cancelPay(){
        //点击返回键取消支付
        self.cancelAlert.show()
    }
    
    ///获取到通知中userInfo存储的支付结果
    @objc private func payResultAction(noti:Notification){
        if let payResult = noti.userInfo{
            switch JSON(payResult)["resultStatus"].stringValue {
            case "9000":
                //支付成功,
                //1.通知服务器修改订单状态
                let group = DispatchGroup()
                let mQueue = DispatchQueue(label: "myQueue")
                for id in self.order_ids{
                    print("请求修改订单")
                    group.enter()
                    mQueue.async(group: group, qos: .default, flags: [], execute: {
                        self.orderViewModel.requestUpdateOrder(order_id: id, status: 2, finishCallback: { (updateResult) in
                            self.totalPayResult = updateResult
                            group.leave()
                        })
                    })
                    
                }
                //2.显示支付成功
                group.notify(queue: .main, execute: {
                    print("请求结束后判断总体支付结果")
                    if self.totalPayResult {
                        self.successAlert.show()
                    }else {
                        self.failedAlert.show()
                    }
                })
                
                
                break
            case "8000":
                //正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
                payingAlert.show()
                break
            case "4000":
                //订单支付失败
                failedAlert.show()
                break
            case "5000":
                //重复请求
                payingAlert.show()
                break
            case "6001":
                //用户中途取消
                failedAlert.show()
                break
            case "6002":
                //网络连接出错
                failedAlert.show()
                break
            case "6004":
                //支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
                payingAlert.show()
            break
            default:
                //其他
//                print("支付失败")
                failedAlert.show()
                break
            }
        }
        
        
    }
}
