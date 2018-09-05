
//
//  ChoseGoodsTypeAlert.swift
//  shoppingcart
//
//  Created by  on 2018/2/6.
//  Copyright © 2018年  All rights reserved.
//

import UIKit
import Toast_Swift
class ChoseGoodsTypeAlert: UIView , UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{
    
    var tableview: UITableView!
    var sureButton: UIButton!
    var view: UIView!
    var bgView: UIView!
    var countView: CountView!
    var goodsInfo: GoodsinfoView!
    var sizeModel: SizeAttributeModel!
    var vc: GoodViewController!
    var dataSource = NSMutableArray()
    var model: GoodsModel!
    var selectSize: ((_ sizeModelBlock: SizeAttributeModel) -> Void)? = nil
    
    init(frame: CGRect, andHeight height: CGFloat,vc:GoodViewController) {
        super.init(frame: frame)
        self.vc = vc
        backgroundColor = UIColor.clear
        view = UIView.init(frame: self.bounds)
        view?.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        addSubview(view)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.hideView))
        view.addGestureRecognizer(tap)
        
        bgView = UIView.init(frame: CGRect(x:0,y:kHeight + (UIDevice.current.isX() ? IphonexHomeIndicatorH : 0),width:kWidth,height:height))
        bgView.backgroundColor = UIColor.white
        bgView.isUserInteractionEnabled = true
        addSubview(bgView)

        goodsInfo = GoodsinfoView.init(frame: CGRect(x:0,y:0,width:kWidth,height:kSize(width: 110)))
        goodsInfo.closeButton.addTarget(self, action: #selector(hideView), for: UIControlEvents.touchUpInside)
        bgView.addSubview(goodsInfo)

        sureButton = UIButton.init(type: UIButtonType.custom)
        sureButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        sureButton.setTitle("确定", for: UIControlState.normal)
        sureButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        sureButton.backgroundColor = UIColor.red
        sureButton.addTarget(self, action: #selector(sure), for: .touchUpInside)
        bgView.addSubview(sureButton)
        sureButton.snp.makeConstraints { (mark) in
            mark.width.equalTo(kWidth)
            mark.height.equalTo(kSize(width: 49))
            mark.left.equalTo(0)
            mark.bottom.equalTo(-(UIDevice.current.isX() ? IphonexHomeIndicatorH : 0))
        }

        tableview = UITableView.init(frame: CGRect(x:0,y:0,width:kWidth,height:0), style: UITableViewStyle.plain)
        tableview.sectionHeaderHeight = 0
        tableview.delegate = self
        tableview.dataSource = self
        addSubview(tableview)
        tableview.snp.makeConstraints { (mark) in
            mark.width.equalTo(kWidth)
            mark.top.equalTo(goodsInfo.snp.bottom)
            mark.left.equalTo(0)
            mark.bottom.equalTo(sureButton.snp.top)
        }

        countView = CountView.init(frame: CGRect(x:0,y:0,width:kWidth,height:kSize(width: 50)))
        countView.countTextField.delegate = self
        countView.addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        countView.reduceButton.addTarget(self, action: #selector(reduce), for: .touchUpInside)
        countView.textFieldDownButton.addTarget(self, action: #selector(tfresignFirstResponder), for: .touchUpInside)
        tableview.tableFooterView = countView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //消失
    @objc func hideView() {
        self.tfresignFirstResponder()
        UIView.animate(withDuration: 0.25, animations: {
            self.bgView.center.y = self.bgView.center.y+self.bgView.frame.height
            self.vc.zoomOut()
        }) { (true) in
            self.removeFromSuperview()
        }
    }
    //出现
    @objc func showView() {
        self.alpha = 1
        tableview.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.bgView.center.y = self.bgView.center.y-self.bgView.frame.height
            self.vc.zoomIn()
        }) { (true) in
            self.tableview.alpha = 1
        }
        
    }
    func initData(goodsModel: GoodsModel) {
        model = goodsModel
        goodsInfo.initData(model: goodsModel)
        dataSource.removeAllObjects()
        //传入数据源创建多个属性
        dataSource.addObjects(from: model.itemsList as! [GoodsTypeModel])
        //此方法必须在_dataSource赋值后方可调用
        self.reloadGoodsInfo()
        tableview.reloadData()
    }
    
    //拼接属性字符串
    func getSizeStr() -> NSString {
        var str = ""
        for typemodel:GoodsTypeModel in dataSource as! [GoodsTypeModel] {
            if typemodel.selectIndex >= 0 {
                if str.count == 0
                {
                    str = typemodel.typeArray[typemodel.selectIndex] as! String
                }else
                {
                    str = "\(str)、\(typemodel.typeArray[typemodel.selectIndex])"
                }
                
            }
        }
        return str as NSString
    }
    //刷新顶部商品信息栏
    func reloadGoodsInfo() {
        for typemodel:GoodsTypeModel in dataSource as! [GoodsTypeModel] {
            if typemodel.selectIndex < 0 {
                goodsInfo.promatLabel.text = "请选择\(typemodel.typeName)"
                break
            }
        }
        let str = self.getSizeStr()
        sizeModel = nil
        for sizemodel:SizeAttributeModel in model.sizeAttribute as! [SizeAttributeModel] {
            //遍历属性组合跟用户当前选择的是否一致
            if sizemodel.value == str as String {
                sizeModel = sizemodel
                if Int(countView.countTextField.text!)! > Int(sizeModel.stock)! {
                    countView.countTextField.text = sizeModel.stock
                }
                else if Int(countView.countTextField.text!)! < Int(sizeModel.stock)! {
                    if Int(countView.countTextField.text!)! == 0 {
                        countView.countTextField.text = "1"
                    }
                }
                
                goodsInfo.promatLabel.text = "已选\(sizemodel.value)"
                goodsInfo.resetData(sizeModel: sizemodel)
                return
            }
        }
        //没找到匹配的，显示默认数据
        goodsInfo.initData(model: model)
    }
    //MARK: 点击方法
    @objc func add() {
        let count: Int = Int(countView.countTextField.text!)!
        //如果有选好的属性就根据选好的属性库存判断，没选择就按总库存判断，数量不能超过库存
        if sizeModel != nil {
            if count < Int(sizeModel.stock)! {
                print(count + 1)
                countView.countTextField.text = "\(count + 1)"
            }
        }
        else {
            if count < Int(model.totalStock)! {
                countView.countTextField.text = "\(count + 1)"
            }
        }

    }
    
    @objc func reduce() {
        let count: Int = Int(countView.countTextField.text!)!
        if count>1
        {
            countView.countTextField.text = "\(count - 1)"
        }
    }
    
    @objc func sure() {
        for typemodel: GoodsTypeModel in dataSource as! [GoodsTypeModel]{
            if typemodel.selectIndex < 0 {
                //SVProgressHUD.show(with: "请选择\(typemodel.typeName)")
                YTools.showMyToast(rootView: self.tableview, message: "请选择\(typemodel.typeName)", duration: 2.0, position: ToastPosition.center)
                return
            }
        }
        if dataSource.count == 0 {
            //该商品无规格
            //SVProgressHUD.show(with:"该商品无规格")
            YTools.showMyToast(rootView: self.tableview, message: "该商品无规格", duration: 2.0, position: ToastPosition.center)
            hideView()
            return
        }
        //判断库存
        if Int(sizeModel.stock)! > 0 {
            if selectSize != nil {
                sizeModel.count = (countView.countTextField.text! as NSString) as String
                if self.selectSize != nil{
                    selectSize!(sizeModel)
                }
            }
            hideView()
        }
        else {
//            SVProgressHUD.show(with:"该规格商品暂无库存无法加入购物车")
            YTools.showMyToast(rootView: self.tableview, message: "该规格商品暂无库存无法加入购物车", duration: 2.0, position: ToastPosition.center)
        }
    }
    
    // MARK: - tf
    @objc func tfresignFirstResponder() {
        //self.tableview.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        countView.countTextField.resignFirstResponder()
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        tableview.setContentOffset(CGPoint.init(x: 0, y: countView.frame.origin.y), animated: true)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let count: Int = Int(countView.countTextField.text!)!
        if sizeModel != nil
        {
            if count>Int(sizeModel.stock)!
            {
                //SVProgressHUD.show(with:"数量超出库存")
                YTools.showMyToast(rootView: self.tableview, message: "数量超出库存", duration: 2.0, position: ToastPosition.center)
                countView.countTextField.text = sizeModel.stock
            }
            
        }else
        {
            if count>Int(model.totalStock)!
            {
                YTools.showMyToast(rootView: self.tableview, message: "数量超出库存", duration: 2.0, position: ToastPosition.center)
                countView.countTextField.text = model.totalStock
            }
        }
    }
    // MARK: - 代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ID = "ChoosTypeTableViewCell"
        var cell =  tableView.dequeueReusableCell(withIdentifier: ID)
        if cell == nil {
            cell = ChoosTypeTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: ID)
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        if indexPath.row<dataSource.count
        {
            let typemodel: GoodsTypeModel? = dataSource[indexPath.row] as? GoodsTypeModel
            tableView.rowHeight = (cell as! ChoosTypeTableViewCell).setData(model: typemodel!)
            
            (cell as! ChoosTypeTableViewCell).typeView!.selectButton = {(_ selectIndex:Int) -> Void in
                //sizeModel 选择的属性模型
                typemodel?.selectIndex = selectIndex
                self.reloadGoodsInfo()
            }
        }
        
        
        return cell!
    }
   
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
