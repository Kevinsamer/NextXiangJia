//
//  GoodViewController.swift
//  NextXiangJia
//  商品
//  Created by DEV2018 on 2018/6/15.
//  Copyright © 2018年 DEV2018. All rights reserved.
//  rootView向下平移状态栏的高度，可见空间高度为usableViewHeight

import UIKit
import SnapKit
import FSPagerView
import Toast_Swift
import WebKit
import SwiftEventBus
import Kingfisher
private let maxContentOfSetY: CGFloat = 40
private let screenWidth = UIScreen.main.bounds.width
private let tableCellID = "tableCellID"
private let bottomBarH:CGFloat = 60 //底部购买view高度
private let topCellSpacing : CGFloat = 10
//goodsInfo
public var goodsNewPrice:Float = 329
public var goodsOldPrice:Float = 699
public var goodsName:String = "许多应用程序和云服务引用基础 Windows 操作系统以获取夏令时 (DST) 和时区 (TZ) 信息。为了确保 Windows 具有最新和最精确的时间数据"

//-------
//顶部广告栏
private let bannerH:CGFloat = finalScreenH / 2
//banner attribute
private let bannerCellID = "bannerCellID"
private var bannerNumbers = 5
//goodsInfoView
private let goodsInfoViewH:CGFloat = 130
//goodsChosenInfoView
private let goodsChosenInfoViewH:CGFloat = 40
//评论view
private let evaluationViewH:CGFloat = 150
//tableView第一个cell高度，该cell显示商品详细信息(商品规格选择等),由各组件高度拼接
private let firstCellH: CGFloat = bannerH + goodsInfoViewH + goodsChosenInfoViewH + evaluationViewH + topCellSpacing * 3
class GoodViewController: GoodDetailBaseViewController {
    var screenHeight : CGFloat?
    var usableViewHeight : CGFloat?
    var bannerImages : [GoodsPhoto]?
    var model : GoodsModel = GoodsModel()
    var specTypies:[String] = [String]()//规格类型数组
    var specTags:[Int] = [Int]()//不同规格的第一个下标记录
    var isLoadedWeb = false
    var sellPriceArray:[Double]?//各规格现价的数组
    var marketPriceArray:[Double]?//各规格原价的数组
    var viewLayer = CALayer()//底层view的动画layer
    var selectedProduct:SelectedProduct?//选择的货品
    override var goodsInfo: GoodInfo? {
        didSet{
            self.goodNameLabel.text = goodsInfo?.name
            bannerImages = goodsInfo?.photos
            goodBannerPageControll.numberOfPages = (goodsInfo?.photos.count)!
            goodBanner.reloadData()
            if sellPriceArray != nil && sellPriceArray?.first == sellPriceArray?.last{
                priceLabel.attributedText = goodPriceString((goodsInfo?.sell_price) ?? "\(0.00)", (goodsInfo?.market_price) ?? "\(0.00)")
                
            }
            initModel()
        }
    }
    var goodsProducts:[GoodsProduct]? {
        didSet{
            //print(goodsProducts![0].productSpecs[0].value)
            guard let products = goodsProducts else { return }
            sellPriceArray = YTools.collectSellPriceFromGoodsProduct(goodsProducts: products)
            if sellPriceArray?.count != 1 && sellPriceArray?.first != sellPriceArray?.last{
                priceLabel.text = "￥\(sellPriceArray?.last ?? 0.00)-￥\(sellPriceArray?.first ?? 0.00)"
                priceLabel.textColor = .red
                priceLabel.font = UIFont.boldSystemFont(ofSize: 20)
            }
            initModel()
        }
    }
    var productSpecs:[[ProductSpec]]? {
        didSet{
//            guard let specs = productSpecs else {
//                productSpecs = [[ProductSpec]]()
//                return
//            }
            //print(specs.count)
        }
    }
    //MARK: - 懒加载
    
    //UIWindows动画，实现选择规格时的凹陷折叠效果
    // 第一次形变
    // 每次进来都进行初始化 回归到正常状态
    lazy var form1: CATransform3D = {
        var form1 = CATransform3DIdentity
        // m34就是实现视图的透视效果的（俗称近大远小）
        form1.m34 = 1.0 / -2000
        //缩小的效果
        form1 = CATransform3DScale(form1, 0.95, 0.95, 1)
        //x轴旋转
        form1 = CATransform3DRotate(form1, CGFloat(15.0 * .pi / 180.0), 1, 0, 0)
        return form1
    }()
    // 第二次形变
    // 每次进来都进行初始化 回归到正常状态
    lazy var form2: CATransform3D = {
        var form2 = CATransform3DIdentity
        // 用上面用到的m34 来设置透视效果
        form2.m34 = form1.m34
        //向上平移一丢丢 让视图平滑点
        //form2 = CATransform3DTranslate(form2, 0, self.view.frame.height * -0.08, 0)
        //最终再次缩小到0.8倍
        form2 = CATransform3DScale(form2, 0.95, 0.95, 1)
        return form2
    }()
    
    lazy var noEvaluationLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: finalScreenW / 2 - 60, y: 75, width: 120, height: 30))
        label.text = "暂无评论"
//        label.backgroundColor = .green
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var evaluationLine: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 30, width: finalScreenW, height: 1))
        view.backgroundColor = UIColor(named: "light_gray")!
        return view
    }()
    
    lazy var goodPercent: UILabel = {
        let label = UILabel(frame: CGRect(x: finalScreenW - 120 - topCellSpacing, y: 0, width: 120, height: 30))
        label.text = "好评度 100%"
//        label.backgroundColor = .green
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .red
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    lazy var evaluationLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: topCellSpacing, y: 0, width: 120, height: 30))
//        label.backgroundColor = .green
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "用户点评 (0)"
        return label
    }()
    
    lazy var evaluationView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: bannerH + goodsInfoViewH + goodsChosenInfoViewH + topCellSpacing * 3, width: finalScreenW, height: evaluationViewH))
        view.backgroundColor = .white
        return view
    }()
    
    lazy var moreImage: UIImageView = {
        let imageV = UIImageView(frame: CGRect(x: finalScreenW - goodsChosenInfoViewH, y: 0, width: goodsChosenInfoViewH, height: goodsChosenInfoViewH))
        imageV.image = UIImage(named: "cart_choose_more")!
        //imageV.backgroundColor = .green
        imageV.contentMode = .center
        return imageV
    }()
    
    lazy var chosenInfoLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: topCellSpacing, y: 0, width: finalScreenW - 100, height: goodsChosenInfoViewH))
        label.text = "请选择商品规格"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.init(named: "light_gray")!
        //label.attributedText = goodChosenString("新款蓝色，降噪版本，1件")
        return label
    }()
    
    lazy var goodsChosenInfoView: UIControl = {
        let view = UIControl(frame: CGRect(x: 0, y: bannerH + goodsInfoViewH + topCellSpacing * 2, width: finalScreenW, height: goodsChosenInfoViewH))
        view.backgroundColor = .white
        view.addTarget(self, action: #selector(popChooseView), for: UIControlEvents.touchUpInside)
        return view
    }()
    
    lazy var goodNameLabel: UILabel = {
        //商品名展示
        let label = UILabel(frame: CGRect(x: topCellSpacing, y: 60, width: finalScreenW - topCellSpacing * 2, height: 60))
        label.numberOfLines = 2
        //label.backgroundColor = .yellow
        label.font = UIFont.systemFont(ofSize: 16).bold
        label.text = goodsName
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        //新旧价格（单label富文本展示）
        let label = UILabel(frame: CGRect(x: topCellSpacing, y: 10, width: finalScreenW - topCellSpacing * 2, height: 40))
        label.attributedText = goodPriceString("\(goodsNewPrice)", "\(goodsOldPrice)")
        //label.backgroundColor = .yellow
        return label
    }()
    
    lazy var goodsInfoView: UIView = {
        //展示商品信息，商品名、价格
        let view = UIView(frame: CGRect(x: 0, y: bannerH + topCellSpacing, width: finalScreenW, height: goodsInfoViewH))
        view.backgroundColor = .white
        return view
    }()
    
    lazy var goodBanner: FSPagerView = {
        let viewPager = FSPagerView()
        viewPager.frame = CGRect(x: 0, y: 0, width: finalScreenW, height: bannerH)
        viewPager.dataSource = self
        viewPager.delegate = self
        viewPager.register(FSPagerViewCell.self, forCellWithReuseIdentifier: bannerCellID)
        //设置自动翻页事件间隔，默认值为0（不自动翻页）
        viewPager.automaticSlidingInterval = 5
        //设置页面之间的间隔距离
        viewPager.interitemSpacing = 0.0
        //设置可以无限翻页，默认值为false，false时从尾部向前滚动到头部再继续循环滚动，true时可以无限滚动
        viewPager.isInfinite = true
        //设置转场的模式
        //viewPager.transformer = FSPagerViewTransformer(type: FSPagerViewTransformerType.overlap)
        return viewPager
    }()
    
    lazy var goodBannerPageControll: FSPageControl = {
        //banner的下标控制器
        let pageControl = FSPageControl(frame: CGRect(x: 0, y: bannerH - 30, width: finalScreenW, height: 30))
        //设置下标的个数
        pageControl.numberOfPages = bannerNumbers
        //设置下标位置
        pageControl.contentHorizontalAlignment = .center
        pageControl.contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        //设置下标指示器图片（选中状态和普通状态）
        //        pageControl.setImage(UIImage.init(named: "1"), for: .normal)
        //        pageControl.setImage(UIImage.init(named: "2"), for: .selected)
        //绘制下标指示器的形状
        //pageControl.setPath(UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: 5, height: 5), cornerRadius: 4.0), for: .normal)
        //pageControl.setPath(UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 5, height: 5)), for: .normal)
        //pageControl.setPath(UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 10, height: 5)), for: .selected)
        //pageControl.setPath(UIBezierPath?.init(UIBezierPath.init(arcCenter: CGPoint.init(x: 10, y: 10), radius: 3, startAngle: 3, endAngle: 2, clockwise: true)), for: UIControlState.selected)
        //设置下标指示器边框颜色（选中状态和普通状态）
        pageControl.setStrokeColor(.gray, for: .normal)
        pageControl.setStrokeColor(.gray, for: .selected)
        //设置下标指示器颜色（选中状态和普通状态）
        pageControl.setFillColor(.white, for: .normal)
        pageControl.setFillColor(.gray, for: .selected)
        //TODO:实现点击某个下标跳转到相应page的功能
        return pageControl
    }()
    
    lazy var activity: UIActivityIndicatorView = {[unowned self] in
        //webView加载提示
        let activity = UIActivityIndicatorView()
        activity.center = CGPoint(x: screenWidth/2, y: (screenHeight! - 64)/2)
        activity.isHidden = true
        activity.activityIndicatorViewStyle = .gray
        return activity
    }()
    
    lazy var webProgressView: UIProgressView = {
        let progress = UIProgressView(frame: CGRect(x: 0, y: 0, width: wkWebView.frame.width, height: 10))
        progress.progressViewStyle = UIProgressViewStyle.bar
        return progress
    }()
    
    lazy var wkWebView: WKWebView = {
        var config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        let webView = WKWebView(frame: CGRect(x: 0, y: self.tableView.frame.maxY, width: self.view.frame.width, height: self.usableViewHeight!), configuration: config)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        webView.backgroundColor = UIColor.white
        return webView
    }()
    
    lazy var webAlphaView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: wkWebView.frame.width, height: wkWebView.frame.height))
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return view
    }()
    
//    lazy var webView: UIWebView = {
//        let webView = UIWebView.init(frame: CGRect(x: 0, y: self.tableView.frame.maxY, width: self.view.frame.width, height: self.usableViewHeight!))
//        webView.delegate = self
//        webView.scrollView.delegate = self
//        webView.backgroundColor = UIColor.white
//        return webView
//    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: CGRect.init(x: 0, y: finalStatusBarH, width: finalScreenW, height: self.usableViewHeight!), style: UITableViewStyle.plain)
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: tableCellID)
        table.separatorStyle = .none
        table.allowsSelection = false
        table.contentInsetAdjustmentBehavior = .never
        return table
    }()
    
    lazy var webHeaderView: UILabel = {[unowned self] in
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: finalScreenW, height: 40))
        label.textAlignment = .center
        label.text = "继续拖动，查看图文详情"
        label.font = UIFont.systemFont(ofSize: 13)
        label.alpha = 0
        return label
    }()
    
    var alert: ChoseGoodsTypeAlert?
    
    //MARK: - 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        screenHeight = self.view.frame.height
        usableViewHeight = self.view.frame.height - finalStatusBarH - finalNavigationBarH - bottomBarH
        // Do any additional setup after loading the view.
        //print("screenH:\(screenHeight)---usableH:\(usableViewHeight)")
        setUI()
        wkWebView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print(self.goodsInfo?.name)
//        self.goodNameLabel.text = self.goodsInfo?.name
//        self.bannerImages = self.goodsInfo?.photos
//        self.goodBanner.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SwiftEventBus.unregister(self)
    }
    
    deinit {
        self.wkWebView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.webProgressView.progress = Float(self.wkWebView.estimatedProgress)
            if self.wkWebView.estimatedProgress == 1.0 {
                wkJS()
                //预留出执行js语句的时间，js语句运行结束后延迟0.4s显示webview
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4, execute: {
//                    self.wkWebView.isHidden = false
                    self.activity.stopAnimating()
                    self.webProgressView.removeFromSuperview()
                    self.webAlphaView.removeFromSuperview()
                })
            }
        }
    }
    
}
//设置ui
extension GoodViewController {
    private func setUI(){
        //-1.为底层view添加动画layer
        self.view.layer.addSublayer(viewLayer)
        //0.初始化数据
        initData()
        //1.设置上方scrollView
        setTableView()
        //2.设置下方的webView
        setWebView()
        
    }
    private func initData(){
        initModel()
        bannerImages = [GoodsPhoto(dict: ["String" : "1" as NSObject])]
        bannerNumbers = (bannerImages?.count)!
    }
    
    private func initModel(){
        model.imageId = goodsInfo?.img ?? "loading"
        model.goodsNo = "\(goodsInfo?.goods_id ?? 0)"
        model.title = goodsInfo?.name ?? "商品标题"
        model.totalStock = goodsInfo?.store_nums ?? "商品库存"
        model.price = GoodsPriceModel()
        model.sizeAttribute = NSMutableArray()//此处初始化后GoodsInfoView的才能显示初始化数据,去掉则都显示0
        //价格信息
        sellPriceArray = [Double]()
        if let products = goodsProducts {
            
            sellPriceArray = YTools.collectSellPriceFromGoodsProduct(goodsProducts: products)
            marketPriceArray = YTools.collectMarketPriceFromGoodsProduct(goodsProducts: products)
            model.itemsList = YTools.getSpecValuesFromProductSpec(products: products) as NSArray
            
            //如果该商品规格值spec_array有值，则使用规格中的价格区间，如果spec_array没有值，则使用商品属性中的销售价和市场价作为其中的价格区间
            model.price.minPrice = "\(sellPriceArray?.last ?? Double(goodsInfo?.sell_price ?? "0.00") ?? 0.00)"
            model.price.maxPrice = "\(sellPriceArray?.first ?? Double(goodsInfo?.sell_price ?? "0.00") ?? 0.00)"
            model.price.minOriginalPrice = "\(marketPriceArray?.last ?? Double(goodsInfo?.market_price ?? "0.00") ?? 0.00)"
            model.price.maxOriginalPrice = "\(marketPriceArray?.first ?? Double(goodsInfo?.market_price ?? "0.00") ?? 0.00)"
            for product in products {
//                type.price = "153"
//                type.originalPrice = "158"
//                type.stock = "\(i)"
//                type.goodsNo = model.goodsNo
//                type.value = valueArr[i]
//                type.imageId = "\(arc4random() % 4).jpg"
//                model.sizeAttribute.add(type)
                let type = SizeAttributeModel()
                type.price = product.sell_price
                type.originalPrice = product.market_price
                type.stock = "\(product.store_nums)"
                type.goodsNo = "\(product.goods_id)"
                type.value = YTools.getGoodsProductSpecs(product: product)
                //                type.imageId = goodsInfo?.img ?? "loading"
                for spec in product.productSpecs {
                    if spec.type == 1 {
                        //使用商品的图片
                        type.type = 1
                        type.imageId = goodsInfo?.img ?? "loading"
                    }
                    else if spec.type == 2 {
                        //使用各规格的图片
                        type.type = 2
                        type.imageId = spec.value
                    }
                }
                type.productId = "\(product.id)"
                type.productNo = product.products_no
                type.productType = 1//该商品有规格
                model.sizeAttribute.add(type)
            }
        }else {
            model.itemsList = [GoodsTypeModel.init(selectIndex: 0, typeName: "请选择规格", typeArray: ["\(goodsInfo?.name ?? "")"])]
            
            let type = SizeAttributeModel()
            model.price.minPrice = goodsInfo?.sell_price ?? "0.00"
            model.price.maxPrice = goodsInfo?.sell_price ?? "0.00"
            model.price.minOriginalPrice = goodsInfo?.market_price ?? "0.00"
            model.price.maxOriginalPrice = goodsInfo?.market_price ?? "0.00"
            //print(goodsInfo?.name)
            type.price = goodsInfo?.sell_price ?? "0.00"
            type.originalPrice = goodsInfo?.market_price ?? "0.00"
            type.stock = goodsInfo?.store_nums ?? "0"
            type.goodsNo = "\(goodsInfo?.goods_id ?? 0)"
            type.imageId = goodsInfo?.img ?? "loading"
            type.value = "\(goodsInfo?.name ?? "")"
            type.type = 1
            type.productId = ""
            type.productNo = ""
            type.productType = 0//该商品无规格
            //如果是没有规格只有一种的商品，则使用其属性构造一个规格以供选择，其规格的id和no都是-1
            model.sizeAttribute.add(type)
        }
        
        
        //属性-应该从服务器获取属性列表
        
//        let type1 = GoodsTypeModel()
//        type1.selectIndex = -1
//        type1.typeName = "尺码"
//        type1.typeArray = ["XL", "XXL"]
//        let type2 = GoodsTypeModel()
//        type2.selectIndex = -1
//        type2.typeName = "颜色"
//        type2.typeArray = ["黑色", "白色", "黑色", "白色", "黑色", "白色", "黑色"]
//        let type3 = GoodsTypeModel()
//        type3.selectIndex = -1
//        type3.typeName = "日期"
//        type3.typeArray = ["2016", "2017", "2018"]
        
        //model.itemsList = [type1, type2, type3]
        //属性组合数组-有时候不同的属性组合价格库存都会有差异，选择完之后要对应修改商品的价格、库存图片等信息，可能是获得商品信息时将属性数组一并返回，也可能属性选择后再请求服务器获得属性组合对应的商品信息，根据自己的实际情况调整
//        model.sizeAttribute = NSMutableArray()
//        var valueArr = ["XL、黑色、2016", "XXL、黑色、2016", "XL、白色、2016", "XXL、白色、2016", "XL、黑色、2017", "XXL、黑色、2017", "XL、白色、2017", "XXL、白色、2017", "XL、黑色、2018", "XXL、黑色、2018", "XL、白色、2018", "XXL、白色、2018"]
//        for i in 0..<valueArr.count {
//            let type = SizeAttributeModel()
//            type.price = "153"
//            type.originalPrice = "158"
//            type.stock = "\(i)"
//            type.goodsNo = model.goodsNo
//            type.value = valueArr[i]
//            type.imageId = "\(arc4random() % 4).jpg"
//            model.sizeAttribute.add(type)
//        }
    }
    
    private func setWebView(){
        self.view.addSubview(wkWebView)
        self.wkWebView.addSubview(webAlphaView)
        self.wkWebView.addSubview(webProgressView)
        self.wkWebView.addSubview(activity)
        self.wkWebView.addSubview(webHeaderView)
    }
    private func setTableView(){
        self.view.addSubview(tableView)
        //tableView.reloadData()
    }
    //js脚本，调整界面内容，只显示图文详情
    private func wkJS(){
        //隐藏商品信息
        wkWebView.evaluateJavaScript("document.getElementsByClassName('goods_info')[0].style.display='none'", completionHandler: { (nullAble, errors) in
            //            print(errors)
        })
        //隐藏轮播图
        wkWebView.evaluateJavaScript("document.getElementsByClassName('goods_photo')[0].style.display='none'", completionHandler: { (nullAble, errors) in
            //            print(errors)
        })
        //隐藏客服button
        wkWebView.evaluateJavaScript("document.getElementsByClassName('layer-3')[0].style.display='none'", completionHandler: { (nullAble, errors) in
            //            print(errors)
        })
        //隐藏tabbar
        wkWebView.evaluateJavaScript("document.getElementById('layout_bottom')[0].style.display='none'", completionHandler: { (nullAble, errors) in
            //            print(errors)
        })
        wkWebView.evaluateJavaScript("document.getElementsByClassName('btn_bottom_goods')[0].style.display='none'", completionHandler: { (nullAble, errors) in
            //            print(errors)
        })
        //隐藏商品详情评论咨询按钮
        wkWebView.evaluateJavaScript("document.getElementsByClassName('pro_tab')[0].style.display='none'", completionHandler: { (nullAble, errors) in
            //            print(errors)
        })
        //隐藏顶部导航栏
        wkWebView.evaluateJavaScript("document.getElementsByClassName('header fixed top z2')[0].style.display='none'", completionHandler: { (nullAble, errors) in
            //            print(errors)
        })
        
    }
}

//MARK: - 新旧价格  富文本方法
extension GoodViewController {
    func goodPriceString(_ newPrice: String, _ oldPrice: String) -> NSMutableAttributedString {
        let text = "￥" + newPrice + "     ￥" + oldPrice
        let attributedString = NSMutableAttributedString.init(string: text)
        let rang1 = (text as NSString).range(of: "￥" + newPrice)
        //当新旧价格一样时会出现rang2覆盖rang1样式的bug，通过在rang2的字符串前添加一个空格来规避这个情况
        let rang2 = (text as NSString).range(of: " ￥" + oldPrice)
        attributedString.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.red , NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20).bold], range: rang1)
        attributedString.addAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16) , NSAttributedStringKey.baselineOffset : 0 , NSAttributedStringKey.strikethroughStyle : 2 , NSAttributedStringKey.foregroundColor : UIColor.lightGray], range: rang2)
        //        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: rang1)
        //        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 16), range: rang1)
        return attributedString
    }
    
    func goodChosenString(_ chosenInfo: String) -> NSMutableAttributedString {
        let text = "已选      \(chosenInfo)"
        let attributedString = NSMutableAttributedString.init(string: text)
        let rang1 = (text as NSString).range(of: "已选")
        let rang2 = (text as NSString).range(of: chosenInfo)
        attributedString.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.lightGray , NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12)], range: rang1)
        attributedString.addAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16).bold , NSAttributedStringKey.foregroundColor : UIColor.black], range: rang2)
        return attributedString
    }
}

//MARK: - 往返商品详情和webView方法
extension GoodViewController {
    func goToWebDetail() {
        UIView.animate(withDuration: 0.3, animations: {[unowned self] in
            self.wkWebView.frame = CGRect(x: 0, y: finalStatusBarH, width: screenWidth, height: self.usableViewHeight!)
            self.tableView.frame = CGRect(x: 0, y: -self.usableViewHeight! - finalStatusBarH, width: screenWidth, height: self.usableViewHeight!)
            //self.webView.isHidden = false
            self.wkWebView.layer.opacity = 1
            
        }) { (finished) in
            guard !self.isLoadedWeb else {
                return
            }
            //此处有显示图文详情的链接则直接使用，若没有提供链接，则使用注释的request来加载手机端商品详情页面，通过js隐藏不需要的元素来展示图文详情
//            let request = URLRequest(url: URL(string: BASE_URL + "site/products/id/\((self.goodsInfo?.goods_id) ?? 0)")!)
            let request = URLRequest(url: URL(string: GOODWEBDETAIL_URL + "\(self.goodsInfo?.goods_id ?? 0)")!)
            self.wkWebView.load(request)
            self.isLoadedWeb = true
        }
    }
    
    func backToTableDetail() {
        UIView.animate(withDuration: 0.3, animations: {
            self.wkWebView.frame = CGRect(x: 0, y: self.usableViewHeight! + finalStatusBarH, width: screenWidth, height: self.usableViewHeight!)
            self.tableView.frame = CGRect(x: 0, y: finalStatusBarH, width: screenWidth, height: self.usableViewHeight!)
            
            self.wkWebView.layer.opacity = 0
        }){(finished) in
            //self.tableView.scrollToTop()
        }
    }
    
    func handleWebHeaderViewAnimation(_ offSetY: CGFloat) {
        self.webHeaderView.alpha = -offSetY/maxContentOfSetY
        self.webHeaderView.center = CGPoint(x: screenWidth/2, y: -offSetY/2)
        
        if -offSetY > maxContentOfSetY {
            self.webHeaderView.text = "释放，返回商品详情"
        } else {
            self.webHeaderView.text = "下拉，返回商品详情"
        }
    }
}

//遵守TableView的协议和数据源协议
extension GoodViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: tableCellID, for: indexPath)
        //cell.textLabel?.text = "这是第\(indexPath.row)行"
        //cell.backgroundColor = UIColor.random.lighten()
        if indexPath.item == 0 {
            cell.removeSubviews()
            cell.backgroundColor = UIColor(named: "light_gray")?.lighten(by: 0.1)
            cell.addSubview(goodBanner)
            cell.addSubview(goodBannerPageControll)
            goodsInfoView.addSubview(priceLabel)
            goodsInfoView.addSubview(goodNameLabel)
            cell.addSubview(goodsInfoView)
            goodsChosenInfoView.addSubview(chosenInfoLabel)
            goodsChosenInfoView.addSubview(moreImage)
            cell.addSubview(goodsChosenInfoView)
            cell.addSubview(evaluationView)
            evaluationView.addSubview(evaluationLabel)
            evaluationView.addSubview(goodPercent)
            evaluationView.addSubview(noEvaluationLabel)
            evaluationView.addSubview(evaluationLine)
            cell.addSubview(evaluationView)
            
        }else {
            cell.textLabel?.removeFromSuperview()
            let view = UIView(frame: CGRect(x: 0, y: 0, width: finalScreenW, height: 10))
            view.backgroundColor = UIColor(named: "light_gray")?.lighten(by: 0.1)
            let label = UILabel(frame: CGRect(x: 0, y: 10, width: finalScreenW, height: 40))
            label.textAlignment = .center
            label.text = "△上拉查看商品详情"
            label.font = UIFont.systemFont(ofSize: 13)
            cell.addSubview(view)
            cell.addSubview(label)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return firstCellH
        }else {
            return 50
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offSetY = scrollView.contentOffset.y
        let beyondOffSetY = scrollView.contentSize.height - usableViewHeight!
        
        if scrollView.isMember(of: UITableView.self) {
//            if offSetY - beyondOffSetY >= maxContentOfSetY {
//                self.goToWebDetail()
//            }
            print("offSetY:\(offSetY) --- beyondY:\(beyondOffSetY)")
            if offSetY - beyondOffSetY >= maxContentOfSetY {
                self.goToWebDetail()
            }
        } else {
            if offSetY <= -maxContentOfSetY, offSetY < 0 {
                self.backToTableDetail()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !scrollView.isMember(of: UITableView.self) {
            self.handleWebHeaderViewAnimation(scrollView.contentOffset.y)
        }
    }
}
//遵守webView的协议
//extension GoodViewController: UIWebViewDelegate {
//    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
//        self.activity.isHidden = false
//        self.activity.startAnimating()
//        return true
//    }
//    
//    func webViewDidFinishLoad(_ webView: UIWebView) {
//        self.activity.stopAnimating()
//    }
//    
//    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
//        self.activity.stopAnimating()
//    }
//}

// MARK: - 设置banner的数据源和代理
extension GoodViewController: FSPagerViewDataSource,FSPagerViewDelegate{
    //item数量
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return (bannerImages?.count)!
    }
    //数据填充回调
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: bannerCellID, at: index)
        cell.imageView?.kf.setImage(with: URL.init(string: BASE_URL + bannerImages![index].img))
        cell.imageView?.contentMode = .scaleAspectFit
        cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.contentView.layer.shadowRadius = 0 //去除下标指示器阴影
        //cell.textLabel?.text = "title\(index)"
        return cell
    }
    //下标同步
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        goodBannerPageControll.currentPage = index
    }
    //点击事件回调
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        print(index)
    }
    
}

//MARK: - 事件响应
extension GoodViewController {
    @objc private func popChooseView(){
        alert = ChoseGoodsTypeAlert(frame: CGRect(x: 0, y: UIDevice.current.isX() ? -IphonexHomeIndicatorH : 0, width: kWidth, height: kHeight), andHeight: kSize(width:500), vc:self)
        alert?.alpha = 0
        UIApplication.shared.keyWindow?.addSubview(alert!)
        alert?.selectSize = {(_ sizeModel: SizeAttributeModel) -> Void in
            //sizeModel 选择的属性模型
            //SVProgressHUD.showSuccess(withStatus: "选择了:"+sizeModel.value)
            YTools.showMyToast(rootView: self.view, message: "选择了: \(sizeModel.value)、\(sizeModel.count)件、\(sizeModel.productNo)", duration: 2.0, position: ToastPosition.center)
            self.chosenInfoLabel.attributedText = self.goodChosenString("\(sizeModel.value)、\(sizeModel.count)件")
            //self.zoomOut()
            self.selectedProduct = YTools.getSelectedProductById(sizeModel: sizeModel, goodsProducts: self.goodsProducts!)
            //获取到选择的规格，根据productType来确定参数是否带有规格信息（0无规格  1有规格）
        }
        //initModel()
        alert?.initData(goodsModel: model)
        
        //zoomIn()
        alert?.showView()
        
    }
    //navigationController的view折叠内陷方法
    public func zoomIn(){
        UIView.animate(withDuration: 0.25, animations: {
            //UIApplication.shared.keyWindow?.layer.transform = self.form1
            self.navigationController?.view.layer.transform = self.form1
        }) { (finish) in
            UIView.animate(withDuration: 0.25, animations: {
                //UIApplication.shared.keyWindow?.layer.transform = self.form2
                self.navigationController?.view.layer.transform = self.form2
            })
        }
    }
    //复原方法
    public func zoomOut(){
        UIView.animate(withDuration: 0.25, animations: {
            //UIApplication.shared.keyWindow?.layer.transform = self.form1
            
            self.navigationController?.view.layer.transform = self.form1
        }) { (finish) in
            UIView.animate(withDuration: 0.25, animations: {
                //UIApplication.shared.keyWindow?.layer.transform = CATransform3DIdentity
                self.navigationController?.view.layer.transform = CATransform3DIdentity
            })
        }
    }
}

//MARK: - 遵守WKWebView协议
extension GoodViewController : WKUIDelegate,WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        self.activity.isHidden = false
        self.activity.startAnimating()
//        webView.layer.isHidden = true
        //开始加载时调用
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //即将完成加载
        //禁用长按功能
        self.wkWebView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none';", completionHandler: { (nullAble, errors) in
//                        print(errors)
        })
        self.wkWebView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none';", completionHandler: { (nullAble, errors) in
            //                        print(errors)
        })
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        //加载失败时调用
        self.activity.stopAnimating()
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
}



