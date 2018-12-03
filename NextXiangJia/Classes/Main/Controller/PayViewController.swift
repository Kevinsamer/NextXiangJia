//
//  PayViewController.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/11/20.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
private let tableCell:String = "tableCell"
class PayViewController: UIViewController {
    var postOrderResultModel:PostOrderResultModel?{
        didSet{
            if let result = postOrderResultModel {
                finalSumLabel.text = "\(result.final_sum)元"
                confirmPay.setTitleForAllStates("确认支付\(result.final_sum)元")
            }
        }
    }
    
    //MARK: - 懒加载
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

}

extension PayViewController{
    private func setUI(){
        //0.修改背景色
        self.view.backgroundColor = .white
        //1.设置导航栏
        setNavigationBar()
        //2.设置table
        setTableView()
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
        print("支付")
    }
    
    @objc private func cancelPay(){
        //点击返回键取消支付
        self.cancelAlert.show()
    }
}
