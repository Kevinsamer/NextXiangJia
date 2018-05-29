//
//  ShopCartViewController.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/3/20.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import FontAwesome_swift

class ShopCartViewController: UIViewController {
    var dataArray: [LZCartModel] = []
    var selectArray: [LZCartModel] = []
    
    var cartTableView: UITableView? = nil
    var priceLabel: UILabel?
    var allSelectButton: UIButton?
    var editButtonState = 2 // editButton状态  1编辑状态   2结算状态
    var rightBtn = UIButton()
    var commitButton = UIButton(type: .custom)
    // MARK: - 懒加载属性

    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //设置UI
        setUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tabBarController?.tabBar.isHidden = false
    }

}

// MARK: - 设置UI界面
extension ShopCartViewController{
    private func setUI(){
        //0.初始化数据
        initData()
        //1.设置导航栏
        setupNavigationBar()
        //2.设置tableview
        setupTableView()
        //3.设置底部视图
        setupBottomView()
        
    }
    
    /*创建底部视图*/
    func setupBottomView() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = LZColorTool.colorFromRGB(245, G: 245, B: 245)
        self.view.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints { (make) in
            
            make.left.right.equalTo(self.view)
            make.height.equalTo(finalTabBarH)
            make.bottom.equalTo(self.view).offset(UIDevice.current.isX() ? 0 - finalTabBarH - IphonexHomeIndicatorH : 0 - finalTabBarH)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.lightGray
        backgroundView.addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) in
            
            make.left.right.equalTo(self.view)
            make.top.equalTo(backgroundView)
            make.height.equalTo(1.0)
        }
        
        let seletAllButton = UIButton(type: .custom)
        seletAllButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        seletAllButton.setTitle("  全选", for: UIControlState())
        seletAllButton.setImage(UIImage(named: "cart_unSelect_btn"), for: UIControlState())
        seletAllButton.setImage(UIImage(named: "cart_selected_btn"), for: UIControlState.selected)
        seletAllButton.setTitleColor(UIColor.black, for: UIControlState())
        seletAllButton.addTarget(self, action: #selector(selectAllButtonClick), for: UIControlEvents.touchUpInside)
        backgroundView.addSubview(seletAllButton)
        allSelectButton = seletAllButton
        
        seletAllButton.snp.makeConstraints { (make) in
            
            make.left.equalTo(backgroundView).offset(10)
            make.top.equalTo(backgroundView).offset(5)
            make.bottom.equalTo(backgroundView).offset(-5)
            make.width.equalTo(80)
        }
        
        
        
        commitButton.backgroundColor = LZColorTool.redColor()
        commitButton.setTitle("去结算", for: UIControlState())
        commitButton.addTarget(self, action: #selector(comitButtonClick), for: UIControlEvents.touchUpInside)
        backgroundView.addSubview(commitButton)
        
        commitButton.snp.makeConstraints { (make) in
            
            make.top.equalTo(backgroundView)
            make.right.equalTo(backgroundView)
            make.bottom.equalTo(backgroundView)
            make.width.equalTo(100)
        }
        
        let priceLabel = UILabel()
        priceLabel.font = UIFont.systemFont(ofSize: 18)
        priceLabel.textColor = UIColor.red
        backgroundView.addSubview(priceLabel)
        self.priceLabel = priceLabel;
        
        priceLabel.attributedText = self.priceString("100")
        
        priceLabel.snp.makeConstraints { (make) in
            
            make.left.equalTo(seletAllButton.snp.right).offset(10)
            make.right.equalTo(commitButton.snp.left).offset(-10)
            make.top.bottom.equalTo(backgroundView)
        }
        
    }
    
    /*富文本字符串*/
    func priceString(_ price: String) -> NSMutableAttributedString {
        
        let text = "合计:¥" + price
        let attributedString = NSMutableAttributedString.init(string: text)
        
        let rang = (text as NSString).range(of: "合计:")
        
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: rang)
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 16), range: rang)
        
        return attributedString
    }
    
//    /*返回按钮点击事件*/
//    @objc func leftButtonClick() {
//
//        self.dismiss(animated: true, completion: nil)
//    }
    
    /*购物车为空时的视图*/
    func emptyView() {
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        self.view.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self.view)
        }
        
        let imageView = UIImageView(image: UIImage(named: "cart_default_bg"))
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        backgroundView.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            
            make.width.equalTo(247.0/187 * 100)
            make.height.equalTo(100)
            make.centerX.equalTo(backgroundView)
            make.centerY.equalTo(backgroundView.snp.centerY).offset(-100)
        }
        
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.text = "购物车为空"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = LZColorTool.colorFromHex(0x706f6f)
        backgroundView.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            
            make.left.right.equalTo(backgroundView)
            make.height.equalTo(40)
            make.top.equalTo(imageView.snp.bottom).offset(50)
        }
    }
    
    /*计算总金额*/
    func priceCount() {
        var price: Double = 0.0
        
        for model in selectArray {
            
            let pri = Double(model.price!)
            
            price += pri! * Double(model.number)
        }
        
        priceLabel?.attributedText = priceString("\(price)")
    }
    
    private func setupTableView(){
        cartTableView = UITableView(frame: CGRect.zero,style: UITableViewStyle.plain)
        cartTableView?.delegate = self
        cartTableView?.dataSource = self
        cartTableView?.backgroundColor = LZColorTool.colorFromRGB(235, G: 246, B: 248)
        cartTableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        cartTableView?.rowHeight = KLZTableViewCellHeight;
        self.view.addSubview(cartTableView!)
        
        cartTableView?.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view).offset(0)
            make.bottom.equalTo(self.view).offset(UIDevice.current.isX() ? 0 - finalTabBarH * 2 - IphonexHomeIndicatorH : 0 - finalTabBarH * 2)
        })
    }
    
    private func initData(){
        for i in 0...10 {
            
            let model = LZCartModel()
            model.shop = "店铺\(i)"
            model.name = "测试\(i)"
            model.price = "100.00"
            model.number = 2
            model.date = "2018.06.01"
            model.image = UIImage(named: "40fe711f9b754b596159f3a6.jpg")
            dataArray.append(model)
        }
    }
    
    private func setupNavigationBar(){
        //设置图标按钮实现点击高亮效果
        let leftBtn = UIButton.init()
        leftBtn.setTitle(String.fontAwesomeIcon(name: .home), for: .normal)
        leftBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        leftBtn.setTitleColor(.white, for: .normal)
        leftBtn.setTitleColor(UIColor.init(named: "dark_gray"), for: .highlighted)
        
        rightBtn.setTitle("编辑", for: .normal)
        rightBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        rightBtn.setTitleColor(.white, for: .normal)
        rightBtn.setTitleColor(UIColor.init(named: "dark_gray"), for: .highlighted)
        rightBtn.addTarget(self, action: #selector(editButtonClicked), for: UIControlEvents.touchUpInside)
        
        //设置标题
        let title = UILabel()
        title.font = UIFont(name: "System", size: 18.0)
        title.textColor = .white
        title.text = "购物车"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBtn)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        //navigationItem.rightBarButtonItem = UIBarButtonItem.init(imageName: "home_top_search_right")
        navigationItem.title = "购物车"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18)]
        //navigationItem.titleView = title
        navigationController?.navigationBar.barTintColor = UIColor.init(named: "global_orange")
        navigationController?.navigationBar.isTranslucent = false
    }
}
//MARK: - 点击事件
extension ShopCartViewController{
    @objc func editButtonClicked(){
//        if editButtonState == 1 {
//            //返回结算状态，edit显示编辑
//            rightBtn.setTitleForAllStates("编辑")
//            commitButton.setTitleForAllStates("去结算")
//            editButtonState = 2
//        }else if editButtonState == 2 {
//            //进入编辑状态，edit显示完成
//            rightBtn.setTitleForAllStates("完成")
//            commitButton.setTitleForAllStates("删除")
//            editButtonState = 1
//        }
        
        cartTableView?.allowsMultipleSelectionDuringEditing = true
        cartTableView?.setEditing(!(cartTableView?.isEditing)!, animated: true)
        if (cartTableView?.isEditing)! {
            rightBtn.setTitleForAllStates("完成")
            commitButton.setTitleForAllStates("删除")
            editButtonState = 1
        }else{
            rightBtn.setTitleForAllStates("编辑")
            commitButton.setTitleForAllStates("去结算")
            editButtonState = 2
        }
    }
    
    /*全选按钮点击事件*/
    @objc func selectAllButtonClick(_ button: UIButton) {
        
        button.isSelected = !button.isSelected
        
        for model in self.selectArray {
            model.select = false
        }
        
        self.selectArray.removeAll()
        
        if button.isSelected {
            for model in self.dataArray {
                model.select = true
                
                self.selectArray.append(model)
            }
        }
        
        self.cartTableView?.reloadData()
        self.priceCount()
    }
    /*提交按钮点击事件*/
    @objc func comitButtonClick() {
        
        //        for model in self.selectArray {
        //
        //            print("选择的商品:\(model)")
        //        }
        if editButtonState == 1 {
            //编辑状态
            print("删除")
        }else if editButtonState == 2{
            //结算状态
            print("结算")
        }
        
    }
}

extension ShopCartViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: LZCartTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cartCellID") as? LZCartTableViewCell
        if cell == nil {
            cell = LZCartTableViewCell(style: UITableViewCellStyle.default,reuseIdentifier: "cartCellID")
        }
        
        
        let model = dataArray[(indexPath as NSIndexPath).row]
        
        cell?.configCellDateWithModel(model)
        
        /*点击cell数量加按钮回调*/
        cell?.addNumber({number in
            
            model.number = number
            self.priceCount()
            print("aaa\(number)")
        })
        
        /*点击cell数量减按钮回调*/
        cell?.cutNumber({number in
            
            model.number = number
            self.priceCount()
            print("bbbbb\(number)")
        })
        
        /*选择cell商品回调*/
        cell?.selectAction({select in
            
            model.select = select
            
            if select {
                self.selectArray.append(model)
            } else {
                
                let index = self.selectArray.index(of: model)
                self.selectArray.remove(at: index!)
            }
            
            if self.selectArray.count == self.dataArray.count {
                
                self.allSelectButton?.isSelected = true
            } else {
                self.allSelectButton?.isSelected = false
            }
            
            self.priceCount()
            
            print("select\(select)")
        })
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "提示",message: "删除后无法恢复,是否继续删除?",preferredStyle: UIAlertControllerStyle.alert)
        
        let ok = UIAlertAction(title: "确定",style: UIAlertActionStyle.default,handler:{okAction in
            
            let model = self.dataArray.remove(at: (indexPath as NSIndexPath).row)
            
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            
            if self.selectArray.contains(model) {
                
                let index = self.selectArray.index(of: model)
                self.selectArray.remove(at: index!)
                
                self.priceCount()
            }
            
            if self.selectArray.count == self.dataArray.count {
                
                self.allSelectButton?.isSelected = true
            } else {
                self.allSelectButton?.isSelected = false
            }
            
            if self.dataArray.count == 0 {
                
                self.emptyView()
            }
        })
        
        let cancel = UIAlertAction(title: "取消",style: UIAlertActionStyle.cancel,handler: {cancelAction in
            
            
        })
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        
        return "删除"
    }
    
    
}
