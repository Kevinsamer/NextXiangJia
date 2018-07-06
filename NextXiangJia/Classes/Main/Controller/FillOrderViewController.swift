//
//  FillOrderViewController.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/6/29.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit

private let bottomViewH:CGFloat = 60
private let goodsCellH:CGFloat = 95
private let collCellID = "collCellID"
private let tableCellID = "tableCellID"
class FillOrderViewController: UIViewController {
    private var name = ""
    private var phone = ""
    private var address = ""
    private var totalPrice = ""
    private var payMode = "在线支付"
    private var sendMode = "快递运输"
    private var goodsNum: CGFloat = 6
    private var vouchersCardNum = ""
    private var vouchersPassword = ""
    
    //MARK: - 懒加载
    //①收件人信息views
    lazy var addressLine: UIImageView = {
        //底部线
        let imageV = UIImageView(frame: CGRect(x: 0, y: 80, width: finalScreenW - 20, height: 4))
        //imageV.sizeToFit()
        imageV.contentMode = .scaleAspectFit
        imageV.image = UIImage(named: "address_line")
        return imageV
    }()
    
    lazy var nameAndPhoneLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: (finalScreenW - 20) * 2 / 3, height: 50))
        label.text = name + "   " + phone
        label.font = UIFont.systemFont(ofSize: 22).bold
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 50, width: (finalScreenW - 20) * 7 / 8, height: 30))
        label.text = address
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var moreAddressImageV: UIImageView = {
        let imageV = UIImageView(frame: CGRect(x: (finalScreenW - 20) * 7 / 8, y: 0, width: (finalScreenW - 20) / 8, height: 80))
        imageV.contentMode = .center
        //imageV.backgroundColor = .red
        imageV.image = UIImage(named: "contact_addressList_accessoryBtn_n")!
        return imageV
    }()
    
    //②选择支付方式
    lazy var payModeAlert: MyAlertController = {
        let alert = MyAlertController(title: "支付方式", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        return alert
    }()
    
    lazy var payLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: (finalScreenW - 20) / 2 - 10, height:40))
        label.text = "支付方式"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var chosenPayModeLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: finalScreenW - 160, y: 0, width: 100, height:40))
        label.text = "在线支付"
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var morePayModeImage: UIImageView = {
        let imageV = UIImageView(frame: CGRect(x: finalScreenW - 60, y: 0, width: 40, height: 40))
        imageV.image = UIImage(named: "cart_choose_more")!
        //imageV.backgroundColor = .green
        imageV.contentMode = .center
        return imageV
    }()
    
    //③待支付商品信息
    lazy var goodsInfoTableView: UITableView = {
        let table = UITableView(frame: CGRect.init(x: 0, y: 0, width: finalScreenW - 20, height: goodsNum * goodsCellH), style: UITableViewStyle.plain)
        table.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        table.delegate = self
        table.dataSource = self
        table.bounces = false
        
        table.register(UINib.init(nibName: "FillOrderGoodsCell", bundle: nil), forCellReuseIdentifier: tableCellID)
        return table
    }()
    
    lazy var messageEditField: UITextField = {
        //留言输入框
        let field = UITextField(frame: CGRect(x: 10, y: goodsNum * goodsCellH + 40, width: finalScreenW - 40, height: 40))
        field.placeholder = "请输入订单留言"
//        field.borderStyle = UITextBorderStyle.roundedRect
        field.layer.cornerRadius = 20
        field.layer.borderWidth = 1
        field.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        field.addPaddingLeft(10)
        field.clearButtonMode = UITextFieldViewMode.always
        field.backgroundColor = #colorLiteral(red: 0.953465991, green: 0.9629062484, blue: 0.9629062484, alpha: 1)
        field.delegate = self
        field.returnKeyType = UIReturnKeyType.done
        field.keyboardAppearance = UIKeyboardAppearance.light
        
        return field
    }()
    
    lazy var sendModeView: UIControl = {
        //配送方式view
        let view = UIControl(frame: CGRect(x: 0, y: goodsNum * goodsCellH, width: finalScreenW - 20, height: 40))
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.addTarget(self, action: #selector(showSendModeAlert), for: UIControlEvents.touchUpInside)
        return view
    }()
    
    lazy var sendModeAlert: MyAlertController = {
        let alert = MyAlertController(title: "配送方式", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        return alert
    }()
    
    lazy var sendLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: (finalScreenW - 20) / 2 - 10, height:40))
        label.text = "配送方式"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var chosensendModeLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: finalScreenW - 160, y: 0, width: 100, height:40))
        label.text = "快递运输"
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var moreSendModeImage: UIImageView = {
        let imageV = UIImageView(frame: CGRect(x: finalScreenW - 60, y: 0, width: 40, height: 40))
        imageV.image = UIImage(named: "cart_choose_more")!
        //imageV.backgroundColor = .green
        imageV.contentMode = .center
        return imageV
    }()
    
    //④发票代金券
    lazy var invoiceLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height:40))
        label.text = "发票信息"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var invoiceSwitch: UISwitch = {
        let switchButton = UISwitch(frame: CGRect(x: finalScreenW - 80, y: 4.5, width: 100, height: 100))
        switchButton.isOn = false
        switchButton.addTarget(self, action: #selector(invoiceSwitchValueChanged), for: UIControlEvents.valueChanged)
        return switchButton
    }()
    
    lazy var neededInvoiceLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: finalScreenW - 190, y: 0, width: 100, height:40))
        label.text = "是否需要发票"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var invoiceInfoTextField: UITextField = {
        let field = UITextField(frame: CGRect(x: 10, y: 50, width: finalScreenW - 40, height: 40))
        field.placeholder = "不开发票"
        //field.borderStyle = UITextBorderStyle.roundedRect
        field.layer.cornerRadius = 20
        field.layer.borderWidth = 1
        field.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        field.addPaddingLeft(10)
        field.clearButtonMode = UITextFieldViewMode.always
        field.backgroundColor = #colorLiteral(red: 0.953465991, green: 0.9629062484, blue: 0.9629062484, alpha: 1)
        field.delegate = self
        field.returnKeyType = UIReturnKeyType.done
        field.keyboardAppearance = UIKeyboardAppearance.light
        return field
    }()
    
    //代金券view
    lazy var vouchersView: UIControl = {
        //配送方式view
        let view = UIControl(frame: CGRect(x: 0, y: 100, width: finalScreenW - 20, height: 40))
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.addTarget(self, action: #selector(showVouchersAlert), for: UIControlEvents.touchUpInside)
        return view
    }()
    
    lazy var vouchersAlert: UIAlertController = {
        let alert = UIAlertController(style: .actionSheet)
        return alert
    }()
    
    lazy var vouchersLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: (finalScreenW - 20) / 2 - 10, height:40))
        label.text = "使用代金券"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var chosenVouchersLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: finalScreenW - 160, y: 0, width: 100, height:40))
        label.text = "已使用1个"
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var moreVouchersImage: UIImageView = {
        let imageV = UIImageView(frame: CGRect(x: finalScreenW - 60, y: 0, width: 40, height: 40))
        imageV.image = UIImage(named: "cart_choose_more")!
        //imageV.backgroundColor = .green
        imageV.contentMode = .center
        return imageV
    }()
    //⑤价格view
    lazy var goodsPriceLabelL: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 30))
        //label.backgroundColor = UIColor.random.lighten()
        label.text = "商品金额"
        return label
    }()
    lazy var goodsPriceLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: finalScreenW - 130, y: 10, width: 100, height: 30))
        //label.backgroundColor = UIColor.random.lighten()
        label.textAlignment = .right
        label.text = "￥8848.00"
        return label
    }()
    
    lazy var vouchersPriceLabelL: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 40, width: 100, height: 30))
        //label.backgroundColor = UIColor.random.lighten()
        label.text = "代金券"
        return label
    }()
    lazy var vouchersPriceLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: finalScreenW - 130, y: 40, width: 100, height: 30))
        //label.backgroundColor = UIColor.random.lighten()
        label.textAlignment = .right
        label.text = "-￥8.00"
        label.textColor = #colorLiteral(red: 0.9995694757, green: 0.1469388008, blue: 0, alpha: 1)
        return label
    }()
    
    lazy var taxPriceLabelL: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 70, width: 100, height: 30))
        //label.backgroundColor = UIColor.random.lighten()
        label.text = "税金"
        return label
    }()
    lazy var taxPriceLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: finalScreenW - 130, y: 70, width: 100, height: 30))
        //label.backgroundColor = UIColor.random.lighten()
        label.textAlignment = .right
        label.text = "+￥8.00"
        label.textColor = #colorLiteral(red: 0.9995694757, green: 0.1469388008, blue: 0, alpha: 1)
        return label
    }()
    
    lazy var freightPriceLabelL: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 30))
        //label.backgroundColor = UIColor.random.lighten()
        label.text = "运费"
        return label
    }()
    lazy var freightPriceLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: finalScreenW - 130, y: 100, width: 100, height: 30))
        //label.backgroundColor = UIColor.random.lighten()
        label.textAlignment = .right
        label.text = "+￥8.00"
        label.textColor = #colorLiteral(red: 0.9995694757, green: 0.1469388008, blue: 0, alpha: 1)
        return label
    }()
    
    lazy var protectPriceLabelL: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 130, width: 100, height: 30))
        //label.backgroundColor = UIColor.random.lighten()
        label.text = "保价"
        return label
    }()
    lazy var protectPriceLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: finalScreenW - 130, y: 130, width: 100, height: 30))
        //label.backgroundColor = UIColor.random.lighten()
        label.textAlignment = .right
        label.text = "+￥8.00"
        label.textColor = #colorLiteral(red: 0.9995694757, green: 0.1469388008, blue: 0, alpha: 1)
        return label
    }()
    
    lazy var handlingFeePriceLabelL: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 160, width: 100, height: 30))
        //label.backgroundColor = UIColor.random.lighten()
        label.text = "支付手续费"
        return label
    }()
    lazy var handlingFeePriceLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: finalScreenW - 130, y: 160, width: 100, height: 30))
        //label.backgroundColor = UIColor.random.lighten()
        label.textAlignment = .right
        label.text = "+￥8.00"
        label.textColor = #colorLiteral(red: 0.9995694757, green: 0.1469388008, blue: 0, alpha: 1)
        return label
    }()
    
    //⑥底部支付bar
    lazy var bottomView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: UIDevice.current.isX() ? finalScreenH - bottomViewH - IphonexHomeIndicatorH : finalScreenH - bottomViewH, width: finalScreenW, height: bottomViewH))
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }()
    
    lazy var submitBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: finalScreenW * 2 / 3, y: 0, width: finalScreenW / 3, height: bottomViewH)
        button.setTitleForAllStates("提交订单")
        button.setTitleColorForAllStates(.white)
        button.backgroundColor = .red
        return button
    }()
    
    lazy var bottomPriceLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: finalScreenW * 2 / 3, height: bottomViewH))
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .red
        label.adjustsFontSizeToFitWidth = true
        label.attributedText = YTools.changePrice(price: totalPrice, fontNum: 22)
        return label
    }()
    
    
    //主体view，通过collView展示
    lazy var collView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let coll = UICollectionView(frame: CGRect(x: 0, y: finalStatusBarH + finalNavigationBarH, width: finalScreenW, height: finalContentViewNoTabbarH - bottomViewH), collectionViewLayout: layout)
        coll.delegate = self
        coll.dataSource = self
        //coll.allowsSelection = false
        coll.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        coll.backgroundColor = .white
        coll.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collCellID)
        coll.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        return coll
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // KeyboardAvoiding.avoidingView = self.messageEditField
        setUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
//MARK: - 设置UI
extension FillOrderViewController {
    private func setUI(){
        //0.初始化数据
        initData()
        //1.修改背景色
        self.view.backgroundColor = .white
        //2.设置导航栏
        setNavigationBar()
        //3.设置底部view（提交订单按钮、总价）
        setBottomView()
        //4.初始化alert
        setAlertControllers()
        //4.设置主体的tableView
        setCollectionView()
    }
    
    private func initData(){
        name = "余志超"
        phone = YTools.changePhoneNum(phone: "13160107520")
        address = "江苏常州市武进区花园街200 传媒大厦"
        totalPrice = "￥23333.33"
    }
    
    private func setAlertControllers(){
        //支付方式alert
        let onlineBtn = UIAlertAction(title: "在线支付", style: UIAlertActionStyle.default, handler: { (action) in
            self.chosenPayModeLabel.text = "在线支付"
        })
        let arriveBtn = UIAlertAction(title: "货到付款", style: UIAlertActionStyle.default, handler: { (action) in
            self.chosenPayModeLabel.text = "货到付款"
        })
        let cancleBtn = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        payModeAlert.addAction(onlineBtn)
        payModeAlert.addAction(arriveBtn)
        payModeAlert.addAction(cancleBtn)
        
        //配送方式alert
        let expressBtn = UIAlertAction(title: "快递运输", style: .default) { (action) in
            self.chosensendModeLabel.text = "快递运输"
        }
        let takeSelfBtn = UIAlertAction(title: "自提", style: .default) { (action) in
            self.chosensendModeLabel.text = "自提"
        }
        sendModeAlert.addAction(expressBtn)
        sendModeAlert.addAction(takeSelfBtn)
        sendModeAlert.addAction(cancleBtn)
        //代金券alert
        let textFieldOne: TextField.Config = { textField in
            textField.left(image: #imageLiteral(resourceName: "image_proper_card"), color: UIColor(hex: 0x007AFF))
            textField.leftViewPadding = 16
            textField.leftTextPadding = 12
            textField.becomeFirstResponder()
            textField.backgroundColor = nil
            textField.textColor = .black
            textField.placeholder = "代金券卡号"
            textField.clearButtonMode = .whileEditing
            textField.autocapitalizationType = .none
            textField.keyboardAppearance = .default
            textField.keyboardType = .default
            textField.returnKeyType = .continue
            textField.action { textField in
                self.vouchersCardNum = textField.text ?? ""
            }
        }
        
        let textFieldTwo: TextField.Config = { textField in
            textField.left(image: #imageLiteral(resourceName: "ic_vpn_key"), color: UIColor(hex: 0x007AFF))
            textField.leftViewPadding = 16
            textField.leftTextPadding = 12
            textField.borderWidth = 1
            textField.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
            textField.backgroundColor = nil
            textField.textColor = .black
            textField.placeholder = "代金券密码"
            textField.clearsOnBeginEditing = true
            textField.autocapitalizationType = .none
            textField.keyboardAppearance = .default
            textField.keyboardType = .default
            //textField.isSecureTextEntry = true
            textField.returnKeyType = .done
            
            textField.action { textField in
                self.vouchersPassword = textField.text ?? ""
            }
        }
        vouchersAlert.addTwoTextFields(textFieldOne: textFieldOne,textFieldTwo: textFieldTwo)
        
        vouchersAlert.addAction(title: "使用", style: .cancel, isEnabled: true) { (action) in
            print("\(self.vouchersCardNum)+++++++\(self.vouchersPassword)")
        }
    }
    
    private func setCollectionView(){
        self.view.addSubview(collView)
    }
    
    private func setNavigationBar(){
        //去除返回按钮的文字
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = "填写订单"
    }
    
    private func setBottomView(){
        bottomView.addSubview(bottomPriceLabel)
        bottomView.addSubview(submitBtn)
        self.view.addSubview(bottomView)
    }
}

extension FillOrderViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collCellID, for: indexPath)
        cell.backgroundColor = UIColor.white
        cell.layer.shadowOpacity = 0.8
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.layer.shadowRadius = 5
        
        switch indexPath.row {
        case 0:
            cell.removeSubviews()
            cell.addSubview(nameAndPhoneLabel)
            cell.addSubview(addressLabel)
            cell.addSubview(moreAddressImageV)
            cell.addSubview(addressLine)
        case 1:
            cell.removeSubviews()
            cell.addSubview(payLabel)
            cell.addSubview(chosenPayModeLabel)
            cell.addSubview(morePayModeImage)
        case 2:
            cell.removeSubviews()
            cell.addSubview(goodsInfoTableView)
            sendModeView.addSubview(sendLabel)
            sendModeView.addSubview(chosensendModeLabel)
            sendModeView.addSubview(moreSendModeImage)
            cell.addSubview(sendModeView)
            cell.addSubview(messageEditField)
            //cell.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        case 3:
            cell.removeSubviews()
            cell.addSubview(invoiceLabel)
            cell.addSubview(invoiceSwitch)
            cell.addSubview(neededInvoiceLabel)
            cell.addSubview(invoiceInfoTextField)
            vouchersView.addSubview(vouchersLabel)
            vouchersView.addSubview(chosenVouchersLabel)
            vouchersView.addSubview(moreVouchersImage)
            cell.addSubview(vouchersView)
        case 4:
            cell.removeSubviews()
            cell.addSubview(goodsPriceLabelL)
            cell.addSubview(goodsPriceLabel)
            cell.addSubview(vouchersPriceLabelL)
            cell.addSubview(vouchersPriceLabel)
            cell.addSubview(taxPriceLabelL)
            cell.addSubview(taxPriceLabel)
            cell.addSubview(freightPriceLabelL)
            cell.addSubview(freightPriceLabel)
            cell.addSubview(protectPriceLabelL)
            cell.addSubview(protectPriceLabel)
            cell.addSubview(handlingFeePriceLabelL)
            cell.addSubview(handlingFeePriceLabel)
            //cell.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        default:
            //cell.removeSubviews()
            //cell.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0:
            return CGSize(width: finalScreenW - 20, height: 84)
        case 1:
            return CGSize(width: finalScreenW - 20, height: 40)
        case 2:
            return CGSize(width: finalScreenW - 20, height: goodsInfoTableView.height + 90) //配送方式viewH=40 间距=10 留言H=40
        case 3:
            return CGSize(width: finalScreenW - 20, height: 140)
        case 4:
            return CGSize(width: finalScreenW - 20, height: 200)
        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if messageEditField.isFirstResponder {
            messageEditField.resignFirstResponder()
        }
        if invoiceInfoTextField.isFirstResponder {
            invoiceInfoTextField.resignFirstResponder()
        }
        switch indexPath.row {
        case 0:
            print("选择地址")
        case 1:
            self.present(payModeAlert, animated: true, completion: nil)
        case 2:
            break
        case 3:
            break
        case 4:
            break
        default:
            break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

extension FillOrderViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(goodsNum)
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
        return goodsCellH
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if messageEditField.isFirstResponder {
            messageEditField.resignFirstResponder()
        }
        if invoiceInfoTextField.isFirstResponder {
            invoiceInfoTextField.resignFirstResponder()
        }
    }
    
}
//MARK: - 实现textField代理
extension FillOrderViewController:UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print(textField.text!)
        return true
    }
}

//MARK: - 事件响应
extension FillOrderViewController {
    @objc private func showSendModeAlert(){
        self.present(self.sendModeAlert, animated: true, completion: nil)
    }
    
    @objc private func showVouchersAlert(){
        vouchersAlert.show()
    }
    
    @objc private func invoiceSwitchValueChanged(){
        if invoiceSwitch.isOn {
            //need
            invoiceInfoTextField.placeholder = "请输入发票抬头"
            invoiceInfoTextField.isEnabled = true
        }else {
            //no
            invoiceInfoTextField.placeholder = "不开发票"
            invoiceInfoTextField.isEnabled = false
            invoiceInfoTextField.clear()
        }
    }
}


