//
//  FillOrderViewController.swift
//  NextXiangJia
//  订单生成预览类
//  Created by DEV2018 on 2018/6/29.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import Kingfisher
private let bottomViewH:CGFloat = 60
private let goodsCellH:CGFloat = 95
private let collCellID = "collCellID"
private let tableCellID = "tableCellID"
class FillOrderViewController: UIViewController {
    private var name = "点击添加收货地址"
    private var phone = ""
    private var address = "暂无收货地址"
    private var payment:Int = 10//支付宝手机网站支付id
    private var payMode = "支付宝支付"
    private var sendModeID:Int = 1//默认为快递运输方式
    private var sendMode = "快递运输"
    private var freightPrice:Double = 0//运费
    private var goodsNum: CGFloat = 0
    private var vouchersCardNum = ""
    private var vouchersPassword = ""
    private var myCenterViewModel:MycenterViewModel = MycenterViewModel()
    private var orderViewModel:OrderViewModel = OrderViewModel()
    //如果是单个商品生成订单预览，则需要传这三个参数
    var id:String? = nil
    var type:String? = nil
    var num:String? = nil
    //private var kuaidiPrice:Double = 0.00//记录快递价格
    ///总价：包含运费、税费、商品价格等
    private var totalPrice:Double = 0.00{
        didSet{
            //print(totalPrice)
            self.bottomPriceLabel.attributedText = YTools.changePrice(price: "￥\(String(format: "%.2f", totalPrice))", fontNum: 22)
        }
    }
    ///商品总额
    private var goodsTotalPrice:Double = 0.00{
        didSet{
            self.goodsPriceLabel.text = "￥\(goodsTotalPrice)"
            if self.invoiceSwitch.isOn{
                self.totalPrice = goodsTotalPrice + tax
            }else{
                self.totalPrice = goodsTotalPrice
            }
        }
    }
    private var tax:Double = 0.00{
        didSet{
            if self.invoiceSwitch.isOn{
                self.taxPriceLabel.text = "+￥\(tax)"
            }else{
                self.taxPriceLabel.text = "+￥\(0.0)"
            }
            
        }
    }
    var goodsList:[ShopCartGoodsModel]?{
        didSet{
            self.goodsInfoTableView.reloadData()
        }
    }
    ///是否由选择地址页面选中地址后返回
    private var isBackByChoose:Bool = false
    ///默认的收货地址
    private var selectedAddress:MyAddressModel?{
        willSet{
            //print(selectedAddress?.id)
            self.nameAndPhoneLabel.text = "\(newValue?.accept_name ?? "收件人姓名")    \(YTools.changePhoneNum(phone: (newValue?.mobile)!))"
            self.addressLabel.text = "\(newValue?.province ?? "省")\(newValue?.city ?? "市")\(newValue?.area ?? "区")\(newValue?.address  ?? "详细地址")"
            
            DispatchQueue.main.async {
                self.initOrderDelivery(selectAddress: newValue!)
            }
//            print("newValue\(newValue?.province)")
            //print("select\(self.isBackByChoose)")
        }
//        didSet{
//            print("oldValue\(oldValue?.province)")
//        }
    }
    
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
        let alert = MyAlertController(title: "支付方式", message: "请选择付款方式", preferredStyle: UIAlertControllerStyle.actionSheet)
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
        label.text = "支付宝支付"
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
        let table = UITableView(frame: CGRect.init(x: 0, y: 0, width: finalScreenW - 20, height: CGFloat(goodsList?.count ?? 1) * goodsCellH), style: UITableViewStyle.plain)
        table.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        table.delegate = self
        table.dataSource = self
        table.bounces = false
        table.register(UINib.init(nibName: "FillOrderGoodsCell", bundle: nil), forCellReuseIdentifier: tableCellID)
        return table
    }()
    
    lazy var messageEditField: UITextField = {
        //留言输入框
        let field = UITextField(frame: CGRect(x: 10, y: self.goodsInfoTableView.frame.size.height + 40, width: finalScreenW - 40, height: 40))
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
        let view = UIControl(frame: CGRect(x: 0, y: self.goodsInfoTableView.height, width: finalScreenW - 20, height: 40))
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.addTarget(self, action: #selector(showSendModeAlert), for: UIControlEvents.touchUpInside)
        return view
    }()
    
    lazy var sendModeAlert: MyAlertController = {
        let alert = MyAlertController(title: "配送方式", message: "请选择配送方式", preferredStyle: UIAlertControllerStyle.actionSheet)
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
        label.text = "快递"
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
        label.text = "点击添加使用"
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
        label.text = "-￥0.0"
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
        label.text = "+￥8.0"
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
        label.text = "+￥8.0"
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
        label.text = "+￥0.0"
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
        label.text = "+￥0.0"
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
        button.addTarget(self, action: #selector(postOrder), for: .touchUpInside)
        return button
    }()
    
    lazy var bottomPriceLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: finalScreenW * 2 / 3, height: bottomViewH))
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .red
        label.adjustsFontSizeToFitWidth = true
        label.attributedText = YTools.changePrice(price: "￥\(goodsTotalPrice)", fontNum: 22)
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
        //取消滚动条
        coll.showsVerticalScrollIndicator = false
        coll.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        coll.backgroundColor = .white
        coll.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collCellID)
        coll.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        return coll
    }()
    
    lazy var onlineBtn = UIAlertAction(title: "支付宝支付", style: UIAlertActionStyle.default, handler: { (action) in
        self.chosenPayModeLabel.text = "支付宝支付"
    })
//    lazy var arriveBtn = UIAlertAction(title: "货到付款", style: UIAlertActionStyle.default, handler: { (action) in
//        self.chosenPayModeLabel.text = "货到付款"
//    })
    let cancleBtn = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
    var expressBtn = UIAlertAction()
    var takeSelfBtn = UIAlertAction()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.isBackByChoose = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.myCenterViewModel.requestUserAddress(id: Int((AppDelegate.appUser?.user_id)!)) {[unowned self] in
            if self.myCenterViewModel.userAddressInfo?.count == 0 {
                //页面显示前如果请求得到的地址数量为0则显示需要添加地址的信息
                self.selectedAddress = nil
                self.nameAndPhoneLabel.text = self.name
                self.addressLabel.text = self.address
            }else{
                if self.selectedAddress == nil && !self.isBackByChoose{
                    //如果请求到的地址数量不为0且不是选择地址后回调且没有选择的地址，则请求默认地址作为选择的地址
                    self.myCenterViewModel.requestIsDefaultAddress(user_id: Int((AppDelegate.appUser?.user_id)!), finishCallback: { (defaultAddress) in
                        self.selectedAddress = defaultAddress
                    })
                }else if self.selectedAddress != nil && !self.isBackByChoose{
                    //如果请求到的地址数量不为0且不是选择地址后回调且有选择的地址，则遍历所有地址找到选中的地址，将该地址替换为选中的地址
                    //print("i am  in\(self.selectedAddress?.id)")
                    for address in self.myCenterViewModel.userAddressInfo! {
                        //print("address\(address.id)")
                        if address.id == self.selectedAddress?.id {
                            self.selectedAddress = address
                        }
                    }
                }
            }
        }
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
        //name,phone,address应该从收货地址数据中获得
        self.myCenterViewModel.requestIsDefaultAddress(user_id: Int((AppDelegate.appUser?.user_id)!)) { (defaultAddress) in
            self.selectedAddress = defaultAddress
        }
        self.orderViewModel.requestPreviewOrder(isPhone: "true", id: "\(self.id ?? "")", type: "\(self.type ?? "")", num: "\(self.num ?? "")") {[unowned self] (sum,goodsList,tax) in
//            print(sum)
//            print(goodsList.count)
//            print(tax)
            self.goodsList = goodsList
            self.goodsTotalPrice = sum
            self.tax = tax
        }
    }
    
    private func initOrderDelivery(selectAddress:MyAddressModel){
        self.orderViewModel.requestProvinceIDByName(provinceName: selectAddress.province) { (provinceId) in
//            print("province=\(selectAddress.province)")
//            print("id=\(provinceId)")
            self.orderViewModel.requestOrderDelivery(goodsList: self.goodsList!, province: provinceId) {[unowned self] (kuaidi,ziti) in
                DispatchQueue.main.async(execute: {
                    self.sendModeAlert = MyAlertController(title: "配送方式", message: "请选择配送方式", preferredStyle: UIAlertControllerStyle.actionSheet)
                    
                    self.expressBtn = UIAlertAction(title: "\(kuaidi.name)    运费:￥\(kuaidi.price)\(kuaidi.description)", style: .default) { [unowned self] (action) in
                        if self.chosensendModeLabel.text != kuaidi.name {
                            self.totalPrice += kuaidi.price
                        }
                        self.chosensendModeLabel.text = "\(kuaidi.name)"
                        self.freightPriceLabel.text = "+￥\(kuaidi.price)"
                        self.sendModeID = 1
                    }
                    self.takeSelfBtn = UIAlertAction(title: "\(ziti.name)    运费:￥\(ziti.price)", style: .default) { [unowned self] (action) in
                        if self.chosensendModeLabel.text != ziti.name {
                            self.totalPrice -= kuaidi.price
                        }
                        self.chosensendModeLabel.text = "\(ziti.name)"
                        self.freightPriceLabel.text = "+￥\(ziti.price)"
                        self.sendModeID = 3
                    }
                    //配送方式alert
                    if kuaidi.if_delivery == 0{
                        //self.kuaidiPrice = kuaidi.price
                        self.sendModeAlert.addAction(self.expressBtn)
                        self.chosensendModeLabel.text = kuaidi.name
                        self.freightPriceLabel.text = "+￥\(kuaidi.price)"
                        self.sendModeID = 1
                        self.totalPrice = self.goodsTotalPrice + kuaidi.price + (self.invoiceSwitch.isOn ? self.tax : 0)
                    }else{
                        self.sendModeAlert.message = "您选择的地区部分商品无法送达"
                        self.chosensendModeLabel.text = ziti.name
                        self.freightPriceLabel.text = "+￥\(ziti.price)"
                        self.sendModeID = 3
                        self.totalPrice = self.goodsTotalPrice + (self.invoiceSwitch.isOn ? self.tax : 0)
                    }
                    self.sendModeAlert.addAction(self.takeSelfBtn)
                    self.sendModeAlert.addAction(self.cancleBtn)
                })
            }
            
        }
    }
    
    private func setAlertControllers(){
        //支付方式alert
        payModeAlert.addAction(onlineBtn)
        //payModeAlert.addAction(arriveBtn)
        payModeAlert.addAction(cancleBtn)
        
        
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
        //navigationController?.navigationBar.topItem?.title = ""
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
            let vc = ChooseAddressViewController()
            vc.sendDataProtocol = self
            self.navigationController?.show(vc, sender: self)
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
        return goodsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellID) as! FillOrderGoodsCell
//        cell.goodsImageView.image = UIImage(named: "\(indexPath.row)")
        cell.goodsImageView.kf.setImage(with: URL.init(string: BASE_URL + "\(goodsList![indexPath.row].img)"), placeholder: UIImage.init(named: "loading"), options: nil, progressBlock: nil, completionHandler: nil)
        cell.goodsNameLabel.attributedText = goodsList?[indexPath.row].name.bold ?? "小米（MI）小米8SE手机 双卡双待  金色  全网通 *********".bold
        var specString = ""
        for spec in goodsList![indexPath.row].specArray{
            if spec.value.contains("upload"){
                specString += (spec.name + ":" + spec.tip + "   ")
            }else{
                specString += (spec.name + ":" + spec.value + "   ")
            }
        }
        cell.goodsStandardsLabel.text = specString
        cell.goodsPriceLabel.attributedText = YTools.changePrice(price: "￥\(goodsList?[indexPath.row].sell_price ?? 0.00)", fontNum: 14)
        cell.goodsNumLabel.text = "x\(goodsList?[indexPath.row].count ?? 0)"
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
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
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
            self.taxPriceLabel.text = "+￥\(tax)"
            self.totalPrice += tax
        }else {
            //no
            invoiceInfoTextField.placeholder = "不开发票"
            invoiceInfoTextField.isEnabled = false
            invoiceInfoTextField.clear()
            self.taxPriceLabel.text = "+￥\(0.0)"
            self.totalPrice -= tax
        }
    }
    
    @objc private func postOrder(){
        //提交订单1.判断是否有收货地址
        if self.selectedAddress == nil{
            YTools.showMyToast(rootView: self.view, message: "请选择收货地址")
        }else{
            self.orderViewModel.requestPostOrder(isPhone: "true", directGid: (self.id == nil ? 0 : Int(self.id!)!) , directType: self.type, directNum: (self.num == nil ? 1 : Int(self.num!)!), directPromo: nil, directActiveId: 0, acceptTime: "任意", payment: 10, message: messageEditField.text ?? "", taxes: (self.invoiceSwitch.isOn ? self.tax : nil), taxTitle: (self.invoiceSwitch.isOn ? self.invoiceInfoTextField.text ?? "" : nil), radioAddress: (self.selectedAddress?.id)!, deliveryId: self.sendModeID, finishCallback: { postOrderResultModel in
                //提交订单完成，跳转到支付页面
                let vc = PayViewController()
                vc.postOrderResultModel = postOrderResultModel
                self.navigationController?.show(vc, sender: self)
            })
        }
        
    }
}

extension FillOrderViewController:SendDataProtocol{
    func SendData(data: Any?) {
        //print((data as? MyAddressModel)?.accept_name)
        self.selectedAddress = data as? MyAddressModel
        self.isBackByChoose = true
    }
}

