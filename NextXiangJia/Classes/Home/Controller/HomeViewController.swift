//
//  HomeViewController.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/2/24.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import FontAwesome_swift
import FSPagerView
import CircleLabel
import SwifterSwift
import Kingfisher
import SwiftEventBus
import SnapKit

//searchBar attribute
private let searchBarH:CGFloat = 64
//banner attribute
private let bannerCellID = "bannerCellID"
private var bannerNumbers = 5
private var bannerImages = [""]
private var bannerH:CGFloat = 150
//fourBtn attribute
private var fourBtnW = finalScreenW / 4
private var fourBtnH:CGFloat = 100
//collection attribute
private var collectionItemW = ( finalScreenW - 9 ) / 2
private var collectionItemNumbers :CGFloat = 18
private var collectionItemH = collectionItemW * 6 / 5
private var collectionViewH = collectionItemNumbers / 2 * collectionItemH + 3 * (collectionItemNumbers / 2 - 1) + 40 + 2 // 3*3(行高)=9，40=headViewH ,最后的2是coll底部的线条 //- finalStatusBarH - finalNavigationBarH - finalTabBarH - (UIDevice.current.isX() ? IphonexHomeIndicatorH : 0)
private var categoryDHHeadH : CGFloat = 60
private var categoryDHViewH : CGFloat = 120
private var tipInfoViewH : CGFloat = 240
private let itemCellID = "itemCellID"
private let headID = "headID"

private var scrollViewContentSizeH:CGFloat = bannerH + fourBtnH + collectionViewH + tipInfoViewH + 20 + 20
//private var finalContentViewH = UIDevice.current.isX() ? finalScreenH - finalStatusBarH - finalNavigationBarH - finalTabBarH - IphonexHomeIndicator : finalScreenH - finalStatusBarH - finalNavigationBarH - finalTabBarH
class HomeViewController: UIViewController {
    // MARK: - 懒加载属性
    private lazy var homeViewModel : HomeViewModel = HomeViewModel()

    private lazy var tipInfoView : UIView = {
        //tip信息view
        let view = UIView(frame: CGRect(x: 20, y: bannerH + fourBtnH + collectionViewH + 20, width: finalScreenW - 40, height: tipInfoViewH))
        view.layer.borderColor = UIColor.init(named: "home_collectionview_bg")?.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 15
        //view.backgroundColor = UIColor.brown
        
        let truck = UILabel(frame: CGRect(x: 10, y: 10, width: 60, height: 60))
        truck.text = String.fontAwesomeIcon(name: .truck)
        truck.font = UIFont.fontAwesome(ofSize: 50)
        truck.textAlignment = .center
        let mianfei = UILabel(frame: CGRect(x: 70, y: 10, width: 250, height: 40))
        mianfei.text = "免费送货与退货"
        mianfei.font = UIFont.systemFont(ofSize: 30)
        let suoyou = UILabel(frame: CGRect(x: 70, y: 50, width: 250, height: 20))
        suoyou.text = "所有订单超过200免费送货。"
        suoyou.font = UIFont.systemFont(ofSize: 15)
        view.addSubviews([truck,mianfei,suoyou])
        
        let rmb = UILabel(frame: CGRect(x: 10, y: 90, width: 60, height: 60))
        rmb.text = String.fontAwesomeIcon(name: .rmb)
        rmb.font = UIFont.fontAwesome(ofSize: 50)
        rmb.textAlignment = .center
        let tuikuan = UILabel(frame: CGRect(x: 70, y: 90, width: 250, height: 40))
        tuikuan.text = "退款保证"
        tuikuan.font = UIFont.systemFont(ofSize: 30)
        let baifenbai = UILabel(frame: CGRect(x: 70, y: 130, width: 250, height: 20))
        baifenbai.text = "100%退款保证。"
        baifenbai.font = UIFont.systemFont(ofSize: 15)
        view.addSubviews([rmb,tuikuan,baifenbai])
        
        let phone = UILabel(frame: CGRect(x: 10, y: 170, width: 60, height: 60))
        phone.text = String.fontAwesomeIcon(name: .phone)
        phone.font = UIFont.fontAwesome(ofSize: 50)
        phone.textAlignment = .center
        let zaixian = UILabel(frame: CGRect(x: 70, y: 170, width: 250, height: 40))
        zaixian.text = "在线支持24/7"
        zaixian.font = UIFont.systemFont(ofSize: 30)
        let qi24 = UILabel(frame: CGRect(x: 70, y: 210, width: 250, height: 20))
        qi24.text = "客服7*24小时在线"
        qi24.font = UIFont.systemFont(ofSize: 15)
        view.addSubviews([phone,zaixian,qi24])
        
        return view
    }()
    private lazy var categoryDHHeadView : UIView = {
        //导航分类headView
        let view = UIView(frame: CGRect(x: 0, y: bannerH + fourBtnH + collectionViewH, width: finalScreenW, height: categoryDHHeadH))
        let icon = UILabel(frame: CGRect(x: 20, y: 10, width: 40, height: 40))
        icon.font = UIFont.fontAwesome(ofSize: 30)
        icon.text = String.fontAwesomeIcon(name: .list)
        icon.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        
        let text = UILabel(frame: CGRect(x: 70, y: 10, width: 200, height: 40))
        text.font = UIFont.systemFont(ofSize: 22)
        text.text = "畅销商品分类"
        view.addSubview(text)
        view.addSubview(icon)
        
        //view.backgroundColor = .purple
        return view
    }()
    private lazy var categoryDHView : UIView = {
        //导航分类view
        let view = UIView(frame: CGRect(x: 20, y: bannerH + fourBtnH + collectionViewH + categoryDHHeadH, width: finalScreenW - 40, height: categoryDHViewH))
        view.layer.borderColor = UIColor(named: "light_gray")?.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 15
        view.backgroundColor = UIColor.cyan
        return view
    }()

    private lazy var collections:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionItemW, height: collectionItemH)
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        layout.headerReferenceSize = CGSize(width: finalScreenW, height: 40)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
        
        let collection = UICollectionView(frame: CGRect.init(x: 0, y: bannerH + fourBtnH, width: finalScreenW, height: collectionViewH), collectionViewLayout: layout)
        collection.bounces = false
        collection.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collection.dataSource = self
        collection.delegate = self
        collection.register(UINib.init(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: itemCellID)
        collection.register(UINib.init(nibName: "HomeCollHeadView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headID)
        collection.backgroundColor = UIColor.init(named: "home_collectionview_bg")
//        collection.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return collection
    }()
    
    private lazy var rootScrollView:UIScrollView = {
        //scrollView所有view的父view
        let scroll = UIScrollView(frame: CGRect(x: 0, y: finalStatusBarH + finalNavigationBarH, width: finalScreenW, height: finalContentViewHaveTabbarH))
        scroll.backgroundColor = .white
        scroll.contentSize = CGSize(width: finalScreenW, height: scrollViewContentSizeH)
        scroll.isScrollEnabled = true
        scroll.contentInsetAdjustmentBehavior = .never
        scroll.showsVerticalScrollIndicator = testMode//debug时开启滚动条,release时隐藏
        scroll.alwaysBounceVertical = true
        return scroll
    }()
    
    private lazy var topBanner:FSPagerView = {
        //顶部banner
        let viewPager = FSPagerView()
        viewPager.frame = CGRect(x: 0, y: 0, width: finalScreenW, height: 150)
        viewPager.dataSource = self
        viewPager.delegate = self
        viewPager.register(FSPagerViewCell.self, forCellWithReuseIdentifier: bannerCellID)
        //设置自动翻页事件间隔，默认值为0（不自动翻页）
        viewPager.automaticSlidingInterval = 1.0
        //设置页面之间的间隔距离
        viewPager.interitemSpacing = 0.0
        //设置可以无限翻页，默认值为false，false时从尾部向前滚动到头部再继续循环滚动，true时可以无限滚动
        viewPager.isInfinite = true
        //设置转场的模式
        //viewPager.transformer = FSPagerViewTransformer(type: FSPagerViewTransformerType.overlap)
        return viewPager
    }()
    
    private lazy var topBannerControl:FSPageControl = {
        //banner的下标控制器
        let pageControl = FSPageControl(frame: CGRect(x: 0, y: 120, width: finalScreenW, height: 30))
        //设置下标的个数
        pageControl.numberOfPages = bannerNumbers
        //设置下标位置
        pageControl.contentHorizontalAlignment = .center
        //设置下标指示器图片（选中状态和普通状态）
        //        pageControl.setImage(UIImage.init(named: "1"), for: .normal)
        //        pageControl.setImage(UIImage.init(named: "2"), for: .selected)
        //绘制下标指示器的形状
        //pageControl.setPath(UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: 5, height: 5), cornerRadius: 4.0), for: .normal)
        //pageControl.setPath(UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 5, height: 5)), for: .normal)
        //pageControl.setPath(UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 10, height: 5)), for: .selected)
        //pageControl.setPath(UIBezierPath?.init(UIBezierPath.init(arcCenter: CGPoint.init(x: 10, y: 10), radius: 3, startAngle: 3, endAngle: 2, clockwise: true)), for: UIControlState.selected)
        //设置下标指示器边框颜色（选中状态和普通状态）
        pageControl.setStrokeColor(.white, for: .normal)
        pageControl.setStrokeColor(.gray, for: .selected)
        //设置下标指示器颜色（选中状态和普通状态）
        pageControl.setFillColor(.white, for: .normal)
        pageControl.setFillColor(.gray, for: .selected)
        //TODO:实现点击某个下标跳转到相应page的功能
        return pageControl
    }()
    //4个导航btn
    private lazy var homeFourBtnCategory:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 150, width: fourBtnW, height: fourBtnH))
        //view.backgroundColor = UIColor.random.lighten(by: 0.5)
        let circle = CircleLabel(frame: CGRect(x: fourBtnW / 2 - 25, y: 10, width: 50, height: 50))
        circle.useTextColor = false
        circle.textColor = .white
        circle.circleColor = UIColor(named: "global_orange")!
        circle.text = String.fontAwesomeIcon(name: .listUL)
        circle.font = UIFont.fontAwesome(ofSize: 30)
        var label:UILabel = {
            let label = UILabel(frame: CGRect(x: fourBtnW / 2 - 40, y: 70, width: 80, height: 20))
            label.textAlignment = .center
            label.text = "全部分类"
            label.font = label.font.withSize(15)
            label.textColor = .gray
            return label
        }()
        view.addSubview(label)
        view.addSubview(circle)
        return view
    }()
    private lazy var homeFourBtnShopCart:UIView = {
        let view = UIView(frame: CGRect(x: 0 + fourBtnW, y: 150, width: fourBtnW, height: fourBtnH))
        //view.backgroundColor = UIColor.random.lighten(by: 0.5)
        let circle = CircleLabel(frame: CGRect(x: fourBtnW / 2 - 25, y: 10, width: 50, height: 50))
        circle.useTextColor = false
        circle.textColor = .white
        circle.circleColor = UIColor.init(hexString: "#F85B8E")!
        circle.text = String.fontAwesomeIcon(name: .shoppingCart)
        circle.font = UIFont.fontAwesome(ofSize: 30)
        var label:UILabel = {
            let label = UILabel(frame: CGRect(x: fourBtnW / 2 - 40, y: 70, width: 80, height: 20))
            label.textAlignment = .center
            label.text = "购物车"
            label.font = label.font.withSize(15)
            label.textColor = .gray
            return label
        }()
        view.addSubview(label)
        view.addSubview(circle)
        return view
    }()
    private lazy var homeFourBtnTodayTuangou:UIView = {
        let view = UIView(frame: CGRect(x: 0 + fourBtnW * 2, y: 150, width: fourBtnW, height: fourBtnH))
        //view.backgroundColor = UIColor.random.lighten(by: 0.5)
        let circle = CircleLabel(frame: CGRect(x: fourBtnW / 2 - 25, y: 10, width: 50, height: 50))
        circle.useTextColor = false
        circle.textColor = .white
        circle.circleColor = UIColor.init(hexString: "#5AC2D7")!
        circle.text = String.fontAwesomeIcon(name: .gavel)
        circle.font = UIFont.fontAwesome(ofSize: 30)
        var label:UILabel = {
            let label = UILabel(frame: CGRect(x: fourBtnW / 2 - 40, y: 70, width: 80, height: 20))
            label.textAlignment = .center
            label.text = "今日团购"
            label.font = label.font.withSize(15)
            label.textColor = .gray
            return label
        }()
        view.addSubview(label)
        view.addSubview(circle)
        return view
    }()
    private lazy var homeFourBtnMyCollection:UIView = {
        let view = UIView(frame: CGRect(x: 0 + fourBtnW * 3, y: 150, width: fourBtnW, height: fourBtnH))
        //view.backgroundColor = UIColor.random.lighten(by: 0.5)
        let circle = CircleLabel(frame: CGRect(x: fourBtnW / 2 - 25, y: 10, width: 50, height: 50))
        circle.useTextColor = false
        circle.textColor = .white
        circle.circleColor = UIColor.init(hexString: "#ED413F")!
        circle.text = String.fontAwesomeIcon(name: .star)
        circle.font = UIFont.fontAwesome(ofSize: 30)
        var label:UILabel = {
            let label = UILabel(frame: CGRect(x: fourBtnW / 2 - 40, y: 70, width: 80, height: 20))
            label.textAlignment = .center
            label.text = "我的收藏"
            label.font = label.font.withSize(15)
            label.textColor = .gray
            return label
        }()
        view.addSubview(label)
        view.addSubview(circle)
        return view
    }()
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.初始化数据
        initData()
//      print(tabBarController?.tabBar.bounds.height)
//      print(rootScrollView.bounds.height)
//      print(finalScreenH)
//      print(finalScreenW)
//      print(finalScreenH)
//      print(navigationController?.navigationBar.bounds.height)
        // Do any additional setup after loading the view.
        //2.设置UI界面
        //navigationBarHeight = 44/tabBarHeight = 49/statueBarH = api获取
        //bannerHeight = 150
        //fourBtnHeight = 100
        //collectionViewH =
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
// MARK: - Set UI
extension HomeViewController{
    private func setUI(){
        //self.view.backgroundColor = UIColor.init(named: "home_collectionview_bg")
        //不需要设置Scrollview的内边距
        //automaticallyAdjustsScrollViewInsets = false
        //1.设置导航栏
        setupNavigationBar()
        //2.导航栏下添加scrollerView
        addScrollerView()
        //3.设置ADBanner
        setupADBanner()
        //4.设置4个圆形button
        setupFourButton()
        //5.设置collectionView展示推荐
        setupCollectionView()
        //6.设置分类导航head
        //setupCategoryDHHeadView()
        //7.设置分类导航view
        //setupCategoryDHView()
        //8.设置tip信息View
        setupTipInfoView()
    }
    
    private func setupTipInfoView(){
        rootScrollView.addSubview(tipInfoView)
    }
    
    private func setupCategoryDHView(){
        rootScrollView.addSubview(categoryDHView)
    }
    
    private func setupCategoryDHHeadView(){
        rootScrollView.addSubview(categoryDHHeadView)
    }
    
    private func setupCollectionView(){
        rootScrollView.addSubview(collections)
    }
    
    private func setupFourButton(){
        //1.banner下依次添加4个View作为Gesture的触发View
        rootScrollView.addSubview(homeFourBtnCategory)
        rootScrollView.addSubview(homeFourBtnShopCart)
        rootScrollView.addSubview(homeFourBtnTodayTuangou)
        rootScrollView.addSubview(homeFourBtnMyCollection)
        //2.添加Gesture事件
        addFourBtnGesture()
    }
    
    private func addScrollerView(){
        self.view.addSubview(rootScrollView)
//        rootScrollView.snp.makeConstraints({ (make) in
//            //make.width.equalTo(finalScreenW)
//            make.bottom.top.left.right.equalToSuperview()
//        })
        //PS:scrollView的ContentSize高度 = 子视图拼接的高度
    }
    
    private func setupADBanner(){
        rootScrollView.addSubview(topBanner)
        rootScrollView.addSubview(topBannerControl)
    }
    
    private func setupNavigationBar(){
        navigationItem.title = "首页"
    }
}
// MARK: - 设置banner的数据源和代理
extension HomeViewController: FSPagerViewDataSource,FSPagerViewDelegate{
    //item数量
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return bannerNumbers
    }
    //数据填充回调
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = topBanner.dequeueReusableCell(withReuseIdentifier: bannerCellID, at: index)
        cell.imageView?.image = UIImage.init(named: "\(bannerImages[index])")
        //cell.contentView.layer.shadowRadius = 0 //去除cell四周阴影
        cell.textLabel?.text = "title\(index)"
        return cell
    }
    //下标同步
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        topBannerControl.currentPage = index
    }
    //点击事件回调
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        print(index)
    }
    
    func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool {
        return false
    }
}
//MARK: - 添加Gesture 和 target
extension HomeViewController{
    //4btn的gesture
    func addFourBtnGesture(){
        homeFourBtnCategory.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(categoryTapAction)))
        homeFourBtnShopCart.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shopCartTapAction)))
        homeFourBtnMyCollection.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(collectionTapAction)))
        homeFourBtnTodayTuangou.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tuangouTapAction)))
        
    }
    
    @objc func categoryTapAction(){
        print("Category Clicked")
        self.tabBarController?.selectedIndex = 3
    }
    @objc func shopCartTapAction(){
        print("Shopcart Clicked")
        self.tabBarController?.selectedIndex = 1
    }
    @objc func collectionTapAction(){
        print("Collection Clicked")
    }
    @objc func tuangouTapAction(){
        print("Tuangou Clicked")
    }
    
}
//MARK: - 设置collectionView的数据源和代理
extension HomeViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(collectionItemNumbers)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellID, for: indexPath)
        
        return cell
    }
    //cell点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = GoodDetailViewController()
        navigationController?.show(vc, sender: self)
        //navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let head = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headID, for: indexPath)
        
        return head
    }

}

//MARK: - 初始化数据
extension HomeViewController{
    private func initData(){
        //1.初始化banner数据
        initBannerData()
        //2.初始化collection数据
        initCollectionData()
    }
    private func initBannerData(){
        bannerImages = ["1","2","3","4","5"]//测试数据
        homeViewModel.requestBannerData {
            //请求结束后重载视图数据
            self.topBanner.reloadData()
            print("加载banner数据 \(YTools.getCurrentNavigationBarHeight(navCT: self.navigationController!))")
            for tag in self.homeViewModel.tagGroup {
                print(tag.tag_name)
                for room in tag.rooms {
                    print(room.room_name)
                }
                print("-------")
            }
        }
        
    }
    private func initCollectionData(){
        homeViewModel.requestCollectionData()
    }
}


