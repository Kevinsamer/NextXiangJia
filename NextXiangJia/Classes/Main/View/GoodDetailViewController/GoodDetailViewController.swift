//
//  GoodDetailViewController.swift
//  NextXiangJia
//  商品详情页
//  Created by DEV2018 on 2018/6/15.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import SnapKit
import XLPagerTabStrip
import SwiftEventBus
//底部bar高度
private let bottomBarH:CGFloat = 60
class GoodDetailViewController: ButtonBarPagerTabStripViewController {
    var usableViewHeight : CGFloat?
    var goodsViewModel : GoodsDetailViewModel = GoodsDetailViewModel()
    var goodsInfo:GoodInfo?
    var productSpecs:[[ProductSpec]]?//规格信息
    var goodsProducts:[GoodsProduct]?
    var goodsID:Int = 0//商品id初始化为0
    var goodVC:GoodViewController?
    var detailVC:DetailViewController?
    var commentVC:CommentViewController?
    //MARK: - 懒加载
    lazy var shopButton: UIButton = {
        //店铺
        let button = UIButton(type: UIButtonType.custom)
        button.frame = CGRect(x: 0, y: 0, width: finalScreenW / 5, height: bottomBarH)
        button.setImageForAllStates(UIImage(named: "gd_shop_bottom")!)
        button.setTitleForAllStates("店铺")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.setTitleColorForAllStates(.black)
        button.setButtonTitleImageStyle(padding: 5, style: TitleImageStyly.ButtonImageTitleStyleTop)
        button.addTarget(self, action: #selector(shopClicked), for: UIControlEvents.touchUpInside)
        return button
    }()
    lazy var shopCartButton: UIButton = {
        //购物车
        let button = UIButton(type: UIButtonType.custom)
        button.frame = CGRect(x: finalScreenW / 5, y: 0, width: finalScreenW / 5, height: bottomBarH)
        button.setImageForAllStates(UIImage(named: "gd_cart_bottom")!)
        button.setTitleForAllStates("购物车")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.setTitleColorForAllStates(.black)
        button.setButtonTitleImageStyle(padding: 5, style: TitleImageStyly.ButtonImageTitleStyleTop)
        button.addTarget(self, action: #selector(shopCartClicked), for: UIControlEvents.touchUpInside)
        return button
    }()
    lazy var addInToShopCartButton: UIButton = {
        //加入购物车
        let button = UIButton(type: UIButtonType.custom)
        button.frame = CGRect(x: finalScreenW / 5 * 2, y: 0, width: finalScreenW / 10 * 3, height: bottomBarH)
        button.backgroundColor = .red
        button.setTitleForAllStates("加入购物车")
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(addIntoShopcartClicked), for: UIControlEvents.touchUpInside)
        return button
    }()
    lazy var buyNowButton: UIButton = {
        //立即购买
        let button = UIButton(type: UIButtonType.custom)
        button.frame = CGRect(x: finalScreenW / 10 * 7, y: 0, width: finalScreenW / 10 * 3, height: bottomBarH)
        button.backgroundColor = UIColor(named: "global_orange")
        button.setTitleForAllStates("立即购买")
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(buyNowClicked), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var bottomBar: UIView = {
        //底部bar，显示首页、店铺、购物车、加入购物车
        let view = UIView(frame: CGRect(x: 0, y: usableViewHeight!, width: finalScreenW, height: bottomBarH))
        view.backgroundColor = .white
        view.layer.borderColor = UIColor(named: "light_gray")?.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    //MARK: - 重写构造方法获取当前商品的id
    init(goodsID id : Int) {
        super.init(nibName: nil, bundle: nil)
        self.goodsID = id
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 系统回调
    override func viewDidLoad() {
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemBackgroundColor = .clear
        //        settings.style.buttonBarLeftContentInset = 20
        //        settings.style.buttonBarRightContentInset = 20
        settings.style.buttonBarMinimumInteritemSpacing = 0
        settings.style.buttonBarMinimumLineSpacing = -5
        settings.style.selectedBarHeight = 5
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 20)
        super.viewDidLoad()
        containerView.contentInsetAdjustmentBehavior = .never
        buttonBarView.removeFromSuperview()
        navigationController?.navigationBar.addSubview(buttonBarView)
        usableViewHeight = self.view.frame.height - bottomBarH - (UIDevice.current.isX() ? IphonexHomeIndicatorH : 0)
        
        setUI()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func reloadPagerTabStripView() {
        super.reloadPagerTabStripView()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        //guard let goodInfo = goodsInfo else { }
        //initData()
        goodVC = GoodViewController(itemInfo: "商品")
        detailVC = DetailViewController(itemInfo: "详情")
        commentVC = CommentViewController(itemInfo: "评价")
//        CommunicationTools.getCommunications(self, name: Communications.GoodsDetail) { (data) in
//            let goodsInfo = data?.object as? GoodInfo
//            goodVC.goodsInfo = goodsInfo
//            detailVC.goodsInfo = goodsInfo
//            commentVC.goodsInfo = goodsInfo
//        }
        
        //commentVC.view.size = CGSize(width: finalScreenW, height: usableViewHeight!)
        
        return [goodVC!,detailVC!,commentVC!]
    }
    
//    override func configureCell(_ cell: ButtonBarViewCell, indicatorInfo: IndicatorInfo) {
//        super.configureCell(cell, indicatorInfo: indicatorInfo)
//        cell.backgroundColor = .clear
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        navigationItem.titleView = nil
        super.viewWillDisappear(animated)
        buttonBarView.isHidden = true
        //self.tabBarController?.tabBar.isHidden = true
        SwiftEventBus.unregister(self, name: Communications.GoodsDetail.rawValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        buttonBarView.isHidden = false
        //self.tabBarController?.tabBar.isHidden = false
    }
    
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        guard buttonBarView != nil else {return}
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        
//        buttonBarView.move(fromIndex: 0, toIndex: 1, progressPercentage: 1, pagerScroll: PagerScroll.yes)
//        buttonBarView.move(fromIndex: 0, toIndex: 1, progressPercentage: 1, pagerScroll: PagerScroll.yes)
//        buttonBarView.move(fromIndex: 0, toIndex: 1, progressPercentage: 1, pagerScroll: PagerScroll.yes)
    }
}

//MARK: - 设置界面
extension GoodDetailViewController{
    
    private func setUI(){
        //0.设置滑动栏buttonBarView
        setButtonBarView()
        //1.初始化数据
        initData()
        //2.设置navigationBar
        setNavigationBar()
        //3.设置主content
        setContentView()
        //4.设置底部bar
        setBottomBar()
    }
    
    private func setBottomBar(){
        bottomBar.addSubview(shopButton)
        bottomBar.addSubview(shopCartButton)
        bottomBar.addSubview(addInToShopCartButton)
        bottomBar.addSubview(buyNowButton)
        self.view.addSubview(bottomBar)
    }
    private func setButtonBarView(){
        
        
        //改变选择字体的样式，选择加粗
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            
            oldCell?.label.textColor = UIColor(white: 1, alpha: 0.6)
            newCell?.label.textColor = .white
            
            if animated {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                })
            } else {
                newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        }
        
        buttonBarView.frame = CGRect(x: finalScreenW / 4, y: 0, width: finalScreenW /  2, height: finalNavigationBarH)
        //buttonBarView.collectionViewLayout = UICollectionViewFlowLayout()
        //buttonBarView.centerX = (navigationController?.navigationBar.centerX)!
        buttonBarView.selectedBar.backgroundColor = .white
        buttonBarView.backgroundColor = .clear
        
        pagerBehaviour = .progressive(skipIntermediateViewControllers: true, elasticIndicatorLimit: true)
    }
    
    private func setContentView(){
        view.backgroundColor = .white
    }
    
    private func setNavigationBar(){
        
    }
    
    private func initData(){
        goodsViewModel.requestGoodsDetail(goodsID: goodsID) {
            self.goodsInfo = self.goodsViewModel.goodsInfo
            //CommunicationTools.post(duration: 0, name: Communications.GoodsDetail, data: self.goodsViewModel.goodsInfo)
            self.goodVC?.goodsInfo = self.goodsViewModel.goodsInfo
            self.detailVC?.goodsInfo = self.goodsViewModel.goodsInfo
            self.commentVC?.goodsInfo = self.goodsViewModel.goodsInfo
        }
        goodsViewModel.requestGoodsProducts(goodsID: goodsID) {
            if self.goodsViewModel.goodsProducts != nil {
                self.goodsProducts = self.goodsViewModel.goodsProducts
                self.goodVC?.goodsProducts = self.goodsViewModel.goodsProducts
            }
            self.goodVC?.productSpecs = self.goodsViewModel.productSpecs
            self.productSpecs = self.goodsViewModel.productSpecs
        }
    }
    
}

//MARK: - 事件响应
extension GoodDetailViewController {
    @objc private func shopClicked(){
        print("店铺")
    }
    
    @objc private func shopCartClicked(){
        print("购物车")
        let vc = NextShopCartViewController()
//        let vc = UIViewController()
//        vc.view.backgroundColor = .red
        self.navigationController?.show(vc, sender: self)
    }
    
    @objc private func buyNowClicked(){
        print("立即购买")
        let vc = FillOrderViewController()
        self.navigationController?.show(vc, sender: self)
    }
    
    @objc private func addIntoShopcartClicked(){
        print("加入购物车")
    }
}


