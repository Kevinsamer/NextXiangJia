//
//  ShopCartViewController.swift
//  NextXiangJia
//  二级购物车页面
//  Created by DEV2018 on 2018/3/20.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import FontAwesome_swift

class NextShopCartViewController: UIViewController {
    var dataArray: [LZCartModel] = []//所有数据集合
    var selectArray: [LZCartModel] = []//结算数据集合
    var delArray :[LZCartModel] = []//删除数据集合
    var cartTableView: UITableView? = nil
    var priceLabel: UILabel?//已选数量、价格
    var allSelectButton: UIButton?//全选按钮
    var editButtonState = 2 // editButton状态  1编辑状态   2结算状态
    var rightBtn = UIButton()//编辑、完成按钮
    var commitButton = UIButton(type: .custom)//结算、删除按钮
    let backgroundView = UIView()//无数据背景视图
    // MARK: - 懒加载属性
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //设置UI
        setUI()
        view.backgroundColor = .white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - 设置UI界面
extension NextShopCartViewController{
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
        let backgroundView = UIView(frame: CGRect(x: 0, y: finalScreenH - finalNavigationBarH - (UIDevice.current.isX() ? IphonexHomeIndicatorH : 0), width: finalScreenW, height: finalTabBarH))//底部背景视图
        backgroundView.backgroundColor = LZColorTool.colorFromRGB(245, G: 245, B: 245)
        self.view.addSubview(backgroundView)
        
//        backgroundView.snp.makeConstraints { [unowned self] (make) in
//
//            make.left.right.equalTo(self.view)
//            make.height.equalTo(finalTabBarH)
//            //判断设备型号(X或者其他)后设置底部约束
//            make.bottom.equalTo(self.view).offset(UIDevice.current.isX() ? 0 - finalTabBarH - IphonexHomeIndicatorH : 0 - finalTabBarH)
//        }
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.lightGray
        backgroundView.addSubview(lineView)
        
        lineView.snp.makeConstraints { [unowned self](make) in
            
            make.left.right.equalTo(self.view)
            make.top.equalTo(backgroundView)
            make.height.equalTo(1.0)
        }
        //全选按钮初始化
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
        //提交按钮(结算、删除状态)初始化
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
        //已选择总价、数量label初始化
        let priceLabel = UILabel()
        priceLabel.font = UIFont.systemFont(ofSize: 18)
        priceLabel.textColor = UIColor.red
        backgroundView.addSubview(priceLabel)
        priceLabel.adjustsFontSizeToFitWidth = true//设置字体自适应宽度，防止字数过多显示不全
        self.priceLabel = priceLabel;
        //通过自定义方法显示总价和数量
        priceLabel.attributedText = self.numAndPriceString("0" ,"0.0")
        
        priceLabel.snp.makeConstraints { (make) in
            
            make.left.equalTo(seletAllButton.snp.right).offset(10)
            make.right.equalTo(commitButton.snp.left).offset(-10)
            make.top.bottom.equalTo(backgroundView)
        }
        
    }
    //删除状态 已选数量 字体富文本字符串显示设置
    func numString(_ num: String) -> NSMutableAttributedString{
        let text = "已选:" + num + "件"
        let attributedString = NSMutableAttributedString.init(string: text)
        let rang1 = (text as NSString).range(of: "已选:")
        let rang2 = (text as NSString).range(of: "件")
        attributedString.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.black , NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)], range: rang1)
        attributedString.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.black , NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)], range: rang2)
        return attributedString
    }
    //结算状态 已选数量、总价 字体富文本字符串显示设置
    func numAndPriceString(_ num: String, _ price: String) -> NSMutableAttributedString {
        
        let text = "已选:" + num + "件,合计:¥" + price
        let attributedString = NSMutableAttributedString.init(string: text)
        
        let rang1 = (text as NSString).range(of: "件,合计:")
        let rang2 = (text as NSString).range(of: "已选:")
        attributedString.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.black , NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)], range: rang1)
        attributedString.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.black , NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)], range: rang2)
        //        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: rang1)
        //        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 16), range: rang1)
        
        return attributedString
    }
    
    //购物车为空时的视图
    func emptyView() {
        allSelectButton?.isSelected = false
        backgroundView.backgroundColor = UIColor.white
        //backgroundView.addTarget(self, action: #selector(removeEmptyView), for: UIControlEvents.touchUpInside)
        //设置下划手势事件监听
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeEmptyView(sender:)))
        swipe.direction = .down
        backgroundView.addGestureRecognizer(swipe)
        self.view.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints {[unowned self] (make) in
            //通过设置make.edges来一次设置目标view的全部约束
            make.edges.equalTo(self.view)
        }
        //空视图图片
        let imageView = UIImageView(image: UIImage(named: "cart_default_bg"))
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        backgroundView.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            
            make.width.equalTo(247.0/187 * 100)
            make.height.equalTo(100)
            make.centerX.equalTo(backgroundView)
            make.centerY.equalTo(backgroundView.snp.centerY).offset(-100)
        }
        //空视图文字显示
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.text = "购物车为空,下拉刷新数据"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = LZColorTool.colorFromHex(0x706f6f)
        backgroundView.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.left.right.equalTo(backgroundView)
            make.height.equalTo(40)
            make.top.equalTo(imageView.snp.bottom).offset(50)
        }
        
        //         let tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        //        tableView.backgroundColor = UIColor.white
        //        tableView.refreshControl = UIRefreshControl()
        //        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
        //        tableView.refreshControl?.addTarget(self, action: #selector(refreshCartTable), for: UIControlEvents.valueChanged)
        //        backgroundView.addSubview(tableView)
        //        tableView.snp.makeConstraints { (make) in
        //            make.edges.equalTo(backgroundView)
        //        }
    }
    
    //计算总价和数量
    func priceCount() {
        var price: Double = 0.0
        for model in selectArray {
            let pri = Double(model.price!)
            price += pri! * Double(model.number)
        }
        if editButtonState == 2 {
            priceLabel?.attributedText = numAndPriceString("\(selectArray.count)" , "\(price)")
        }else if editButtonState == 1{
            priceLabel?.attributedText = numString("\(delArray.count)")
        }
    }
    //初始化tableView
    private func setupTableView(){
        cartTableView = UITableView(frame: CGRect.init(x: 0, y: finalStatusBarH + finalNavigationBarH, width: finalScreenW, height: finalScreenH - finalStatusBarH - finalNavigationBarH - (UIDevice.current.isX() ? IphonexHomeIndicatorH + finalTabBarH: finalTabBarH)),style: UITableViewStyle.plain)
//        cartTableView?.contentInsetAdjustmentBehavior = .never
        cartTableView?.delegate = self
        cartTableView?.dataSource = self
        cartTableView?.backgroundColor = LZColorTool.colorFromRGB(235, G: 246, B: 248)
        cartTableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        cartTableView?.rowHeight = KLZTableViewCellHeight
        self.view.addSubview(cartTableView!)
        //设置下拉刷新事件
        cartTableView?.refreshControl = UIRefreshControl()
        cartTableView?.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
        cartTableView?.refreshControl?.addTarget(self, action: #selector(refreshCartTable), for: UIControlEvents.valueChanged)
//        cartTableView?.snp.makeConstraints({[unowned self] (make) in
//            make.left.right.equalTo(self.view)
//            make.top.equalTo(self.view).offset(0)
//            make.bottom.equalTo(self.view).offset(UIDevice.current.isX() ? 0 - IphonexHomeIndicatorH : 0)
//        })
    }
    //初始化数据
    private func initData(){
        dataArray.removeAll()
        for i in 0...10 {
            let model = LZCartModel()
            model.shop = "店铺\(i)"
            model.name = "测试\(i)"
            model.price = "100.00"
            model.number = 2
            model.date = "2018.06.01"
            model.image = UIImage(named: "ios_tickets_520")
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
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBtn)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        //navigationItem.rightBarButtonItem = UIBarButtonItem.init(imageName: "home_top_search_right")
        navigationItem.title = "购物车"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18)]
        //navigationItem.titleView = title
        navigationController?.navigationBar.barTintColor = UIColor.init(named: "global_orange")
        navigationController?.navigationBar.isTranslucent = true
    }
}
//MARK: - 点击事件
extension NextShopCartViewController{
    //空视图下划手势事件监听
    @objc func swipeEmptyView(sender : UISwipeGestureRecognizer){
        sender.numberOfTouchesRequired = 1
        if sender.direction == UISwipeGestureRecognizerDirection.down {
            backgroundView.removeFromSuperview()
            cartTableView?.refreshControl?.beginRefreshing()
            refreshCartTable()
            print("downSwipe")
        }
    }
    //当购物车为空时，覆盖一个view作为空视图，重新加载数据时移除空视图view
    @objc func removeEmptyView(){
        backgroundView.removeFromSuperview()
    }
    //下拉刷新事件
    @objc func refreshCartTable(){
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(refreshTimer), userInfo: nil, repeats: false)
    }
    //延时
    @objc func refreshTimer(){
        initData()
        allSelectButton?.isSelected = false
        selectArray.removeAll()
        delArray.removeAll()
        priceCount()
        cartTableView?.reloadData()
        cartTableView?.refreshControl?.endRefreshing()
    }
    //结算状态
    private func editJiesuanState(){
        rightBtn.setTitleForAllStates("编辑")
        commitButton.setTitleForAllStates("去结算")
        commitButton.setTitleColorForAllStates(.white)
        commitButton.backgroundColor = LZColorTool.redColor()
        commitButton.borderWidth = 0
        editButtonState = 2
        //        delArray.removeAll()
        //        selectArray.removeAll()
        //        allSelectButton?.isSelected = false
        priceCount()
    }
    //删除状态
    private func editEdittingState(){
        rightBtn.setTitleForAllStates("完成")
        commitButton.setTitleForAllStates("删除")
        commitButton.setTitleColorForAllStates(.lightGray)
        commitButton.backgroundColor = .white
        commitButton.borderWidth = 1
        commitButton.borderColor = .lightGray
        editButtonState = 1
        //        delArray.removeAll()
        //        selectArray.removeAll()
        //        allSelectButton?.isSelected = false
        priceCount()
    }
    @objc func editButtonClicked(){
        if editButtonState == 1 {
            //返回结算状态，edit显示编辑
            editJiesuanState()
            
        }else if editButtonState == 2 {
            //进入编辑状态，edit显示完成
            editEdittingState()
        }
        selectArray.removeAll()
        delArray.removeAll()
        allSelectButton?.isSelected = false
        for model in self.dataArray {
            model.select = false
        }
        cartTableView?.reloadData()
        //        cartTableView?.allowsMultipleSelectionDuringEditing = true
        //        cartTableView?.setEditing(!(cartTableView?.isEditing)!, animated: true)
        //        if (cartTableView?.isEditing)! {
        //            rightBtn.setTitleForAllStates("完成")
        //            commitButton.setTitleForAllStates("删除")
        //            editButtonState = 1
        //        }else{
        //            rightBtn.setTitleForAllStates("编辑")
        //            commitButton.setTitleForAllStates("去结算")
        //            editButtonState = 2
        //        }
    }
    
    //全选按钮点击事件
    @objc func selectAllButtonClick(_ button: UIButton) {
        //1.选择状态取反
        button.isSelected = !button.isSelected
        //2.判断当前状态，操作对应的集合
        if editButtonState == 1{
            for model in self.delArray {
                model.select = false
            }
            self.delArray.removeAll()
            
            if button.isSelected {
                for model in self.dataArray {
                    model.select = true
                    
                    self.delArray.append(model)
                }
            }
            self.priceCount()
        }else if editButtonState == 2{
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
            self.priceCount()
        }
        
        self.cartTableView?.reloadData()
        
    }
    //提交按钮事件
    @objc func comitButtonClick() {
        if editButtonState == 1 {
            //编辑状态
            if delArray.count == 0 {
                let alert = UIAlertController(title: "提示", message: "请选择要删除的商品", preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: { (cancle) in
                    
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "提示",message: "删除后无法恢复,是否继续删除?",preferredStyle: UIAlertControllerStyle.alert)
                
                let ok = UIAlertAction(title: "确定",style: UIAlertActionStyle.default,handler:{okAction in
                    self.dataArray.removeAll(self.delArray)
                    self.delArray.removeAll()
                    self.priceCount()
                    self.cartTableView?.reloadData {
                        if self.dataArray.count == 0 {
                            self.emptyView()
                        }
                    }
                })
                let cancel = UIAlertAction(title: "取消",style: UIAlertActionStyle.cancel,handler: {cancelAction in
                    
                })
                alert.addAction(ok)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
                //
                print("删除:")
                for del in delArray{
                    del.showInfo()
                }
                
            }
        }else if editButtonState == 2{
            //结算状态
            print("结算:")
            for select in selectArray{
                select.showInfo()
            }
        }
    }
}

extension NextShopCartViewController : UITableViewDelegate,UITableViewDataSource{
    //TableView行数量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    //行内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: LZCartTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cartCellID") as? LZCartTableViewCell
        if cell == nil {
            cell = LZCartTableViewCell(style: UITableViewCellStyle.default,reuseIdentifier: "cartCellID")
        }
        
        
        let model = dataArray[(indexPath as NSIndexPath).row]
        model.indexPath = indexPath
        cell?.configCellDateWithModel(model) //数据填充
        
        //点击cell数量加按钮回调
        cell?.addNumber({number in
            
            model.number = number
            self.priceCount()
            print("aaa\(number)")
        })
        
        //点击cell数量减按钮回调
        cell?.cutNumber({number in
            
            model.number = number
            self.priceCount()
            print("bbbbb\(number)")
        })
        
        //选择cell商品回调
        cell?.selectAction({select in
            
            model.select = select
            
            if self.editButtonState == 1 {
                //编辑状态，删除
                if select {
                    self.delArray.append(model)
                } else {
                    let index = self.delArray.index(of: model)
                    self.delArray.remove(at: index!)
                }
                if self.delArray.count == self.dataArray.count {
                    self.allSelectButton?.isSelected = true
                } else {
                    self.allSelectButton?.isSelected = false
                }
                self.priceCount()
            }else if self.editButtonState == 2 {
                //结算状态，选择结算
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
            }
            print("select\(select)")
        })
        
        return cell!
    }
    
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //
    //        let alert = UIAlertController(title: "提示",message: "删除后无法恢复,是否继续删除?",preferredStyle: UIAlertControllerStyle.alert)
    //
    //        let ok = UIAlertAction(title: "确定",style: UIAlertActionStyle.default,handler:{okAction in
    //
    //            let model = self.dataArray.remove(at: (indexPath as NSIndexPath).row)
    //
    //            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
    //
    //            if self.delArray.contains(model) {
    //
    //                let index = self.delArray.index(of: model)
    //                self.delArray.remove(at: index!)
    //
    //                self.priceCount()
    //            }
    //
    //            if self.delArray.count == self.dataArray.count {
    //
    //                self.allSelectButton?.isSelected = true
    //            } else {
    //                self.allSelectButton?.isSelected = false
    //            }
    //
    //            if self.dataArray.count == 0 {
    //
    //                self.emptyView()
    //            }
    //        })
    //
    //        let cancel = UIAlertAction(title: "取消",style: UIAlertActionStyle.cancel,handler: {cancelAction in
    //
    //
    //        })
    //
    //        alert.addAction(ok)
    //        alert.addAction(cancel)
    //
    //        self.present(alert, animated: true, completion: nil)
    //
    //
    //    }
    //设置cell左滑显示的按钮
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let actionColl = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "添加收藏") { (action, index) in
            print("收藏\(indexPath.row)")
            
        }
        actionColl.backgroundColor = UIColor(named: "global_orange")
        let actionDel = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "删除") { (action, index) in
            print("删除\(indexPath.row)")
            let alert = UIAlertController(title: "提示",message: "删除后无法恢复,是否继续删除?",preferredStyle: UIAlertControllerStyle.alert)
            
            let ok = UIAlertAction(title: "确定",style: UIAlertActionStyle.default,handler:{okAction in
                
                let model = self.dataArray.remove(at: (indexPath as NSIndexPath).row)
                
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                
                if self.delArray.contains(model) {
                    
                    let index = self.delArray.index(of: model)
                    self.delArray.remove(at: index!)
                    
                    self.priceCount()
                }
                if self.selectArray.contains(model) {
                    
                    let index = self.selectArray.index(of: model)
                    self.selectArray.remove(at: index!)
                    
                    self.priceCount()
                }
                
                if self.delArray.count == self.dataArray.count || self.selectArray.count ==  self.dataArray.count{
                    
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
        return [actionDel , actionColl]
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        
        return "删除"
    }
    //ios11后cell右滑，代替editActionsForRowAt,可修改按钮样式
    //    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    //        let action1 = UIContextualAction(style: .normal, title: "Mark1") { (action, view, handler) in
    //            handler(true)
    //        }
    //        let action2 = UIContextualAction(style: .normal, title: "Mark2") { (action, view, handler) in
    //            handler(true)
    //        }
    //        let action3 = UIContextualAction(style: .normal, title: "Mark3") { (action, view, handler) in
    //            handler(true)
    //        }
    //        action1.backgroundColor = UIColor.init(red: 254/255.0, green: 175/255.0, blue: 254/255.0, alpha: 1);
    //        action2.backgroundColor = UIColor.red
    //        action3.backgroundColor = UIColor.purple
    //        let configuration = UISwipeActionsConfiguration(actions: [action1,action2,action3])
    //        return configuration
    //    }
    
}

