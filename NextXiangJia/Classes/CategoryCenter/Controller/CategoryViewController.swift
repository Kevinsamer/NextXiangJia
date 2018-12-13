//
//  CategoryViewController.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/3/20.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import FontAwesome_swift
import PullToRefreshKit
import Kingfisher
import MaterialTapTargetPrompt_iOS
private let leftWidth:CGFloat = 100
private let headViewH:CGFloat = 30
private let lineSpace:CGFloat = 10
private var categoryNum = 10
private var lineNum = 3
private let MyCellID = "MyCellID"
private let headID = "headID"
private var centerX:CGFloat = finalContentViewHaveTabbarH / 2 + 25

////searchBar attribute
//private let searchBarH:CGFloat = 64
class CategoryViewController: UIViewController {
    //不需要滑动到页面中间的segmentView的个数
    let extrasNum = (finalContentViewHaveTabbarH / 50 / 2).int
    private var categoryText:[String] = [String]()//左侧
    private var cellText:[String] = [String]()//右侧
    var categorys:[CategoryModel]?{
        didSet{
            if categorys != nil {
                for _ in 0..<categoryText.count {
                    verticalSegment.removeSegmentAtIndex(0)
                }
                categoryText.removeAll()
                
                for category in categorys! {
                    categoryText.append(category.name)
                    verticalSegment.addSegmentWithTitle(category.name, onSelectionImage: nil, offSelectionImage: nil)
                }
                //视图层级为左侧一个UIScrollView，左侧scrollview上添加一个SMSegmentView，右侧一个collectionView
                //SMSegmentView的高度由segment的数量决定，segment的高度为leftwidth/2
                //左侧scrollview的可滑动区域高度由segment的数量决定且如果计算高度小于屏幕可视高度则固定为屏幕高度+1
                leftScrollView.contentSize = CGSize(width: leftWidth, height: leftWidth * CGFloat(categoryText.count) / 2 > finalContentViewHaveTabbarH ? leftWidth * CGFloat(categoryText.count) / 2 : finalContentViewHaveTabbarH + 1 )
                verticalSegment.height = leftWidth / 2 * CGFloat(categoryText.count)
                verticalSegment.organiseMode = .vertical
                verticalSegment.selectedSegmentIndex = 0
//                requestCategoryGoods(cat: categorys![0].id, page: 1)
            }
        }
    }
    var categoryGoods:[SearchResultModel]?{
        didSet{
            if categoryGoods?.count == 0 {
                self.rightCollectionView.addSubview(noDataLabel)
                self.rightCollectionView.isScrollEnabled = false
            }else {
                self.noDataLabel.removeFromSuperview()
                self.rightCollectionView.isScrollEnabled = true
                self.categoryGoods = YTools.splitArray(array: categoryGoods!, num: 4) as? [SearchResultModel]
            }
            self.rightCollectionView.reloadData()
        }
    }
    var categoryViewModel:CategoryViewModel = CategoryViewModel()
    // MARK: - 懒加载属性
    
    lazy var promptButton: UIButton = {[unowned self] in
        let button = UIButton(type: UIButtonType.system)
        button.frame = CGRect(x: finalScreenW - 50, y: self.rightCollectionView.frame.height / 2 - 25 + finalStatusBarH + finalNavigationBarH, width: 50, height: 50)
        button.size = CGSize(width: 50, height: 50)
        button.layer.cornerRadius = 25
        button.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        button.addTarget(self, action: #selector(dismissPromptButton), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var rightCollectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
//        layout.headerReferenceSize = CGSize(width: 100, height: 10)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: (finalScreenW - leftWidth), height: (finalContentViewHaveTabbarH - 30) / 2)
//        layout.headerReferenceSize = CGSize(width: finalScreenW - leftWidth, height: headViewH)
        layout.scrollDirection = .horizontal
        let coll = UICollectionView(frame: CGRect(x: leftWidth, y: finalStatusBarH + finalNavigationBarH, width: finalScreenW - leftWidth, height: finalContentViewHaveTabbarH), collectionViewLayout: layout)
        coll.register(UINib.init(nibName: "RightCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MyCellID)
        coll.dataSource = self
        coll.delegate = self
        coll.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coll.alwaysBounceHorizontal = true
        coll.isPagingEnabled = true
        coll.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return coll
    }()
    lazy var leftScrollView: UIScrollView = {
        var scroll = UIScrollView(frame: CGRect(x: 0, y: finalStatusBarH + finalNavigationBarH, width: leftWidth, height: finalContentViewHaveTabbarH))
        scroll.contentSize = CGSize(width: leftWidth, height: leftWidth * CGFloat(categoryText.count) / 2 > finalContentViewHaveTabbarH ? leftWidth * CGFloat(categoryText.count) / 2 : finalContentViewHaveTabbarH + 1 )
        scroll.backgroundColor = UIColor.init(named: "global_orange")!
        return scroll
    }()
//    lazy var rightScrollView: UIScrollView = {
//        var scroll = UIScrollView(frame: CGRect(x: leftWidth, y: 0, width: finalScreenW - leftWidth, height: finalContentViewHaveTabbarH))
//            scroll.contentSize = CGSize(width: finalScreenW - leftWidth, height: finalContentViewHaveTabbarH + 10)
//        scroll.backgroundColor = UIColor.white
//        return scroll
//    }()
    lazy var verticalSegment: SMSegmentView = {
        var appearance = SMSegmentAppearance(contentVerticalMargin: 5, segmentOnSelectionColour: .white, segmentOffSelectionColour: UIColor.init(named: "global_orange")!, titleOnSelectionColour: UIColor.init(named: "global_orange")!, titleOffSelectionColour: .white, titleOnSelectionFont: UIFont.boldSystemFont(ofSize: 18), titleOffSelectionFont: UIFont.systemFont(ofSize: 15), titleGravity: nil)
        var verticalSegment = SMSegmentView(frame: CGRect.init(x: 0, y: 0, width: leftWidth, height: leftWidth * CGFloat(categoryText.count) / 2), dividerColour: UIColor.lightGray, dividerWidth: 0, segmentAppearance: appearance)
        verticalSegment.organiseMode = .vertical
        for index in 0..<categoryText.count {
            verticalSegment.addSegmentWithTitle("title\(index)", onSelectionImage: nil, offSelectionImage: nil)
        }
        verticalSegment.selectedSegmentIndex = 0
        verticalSegment.addTarget(self, action: #selector(segmentValueChanged(segment:)), for: UIControlEvents.valueChanged)
        return verticalSegment
    }()
    
    lazy var noDataLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.rightCollectionView.frame.width, height: self.rightCollectionView.frame.height))
        label.text = "商品进货中，请稍后关注上架情况"
        label.textAlignment = .center
        label.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return label
    }()
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AppDelegate.appUser?.isFirstOpen ?? true {
            self.view.addSubview(promptButton)
            showPrompt()
            AppDelegate.appUser?.isFirstOpen = false
            AppUserCoreDataHelper.AppUserHelper.modifyAppUser(appUser: AppDelegate.appUser!)
            AppDelegate.appUser = AppUserCoreDataHelper.AppUserHelper.getAppUser()
        }
    }
}
//设置UI界面
extension CategoryViewController{
    private func setUI(){
        //0.初始化数据
        initData()
        //1.设置导航栏
        setupNavigationBar()
        //2.设置contentView
        setupContentView()
    }
    
    private func initData(){
        requestCategorys()
        refreshCategoryData()
        //refreshCollData(category: categoryText[0])
    }
    
    private func requestCategorys(){
        categoryViewModel.requestCategorys(parentID: nil) {
            self.categorys = self.categoryViewModel.categorys
        }
    }
    
    private func requestCategoryGoods(cat:Int, page:Int){
        categoryViewModel.requestCategoryGoods(categoryID: cat, page: page) {
            self.categoryGoods = self.categoryViewModel.categoryGoods
        }
    }
    
    private func setupContentView(){
        //1.设置左侧vertical segment
        setupLeftVerticalSegment()
        //2.设置右侧collectionView
        setupRightCollectionView()
    }
    private func setupRightCollectionView(){
        rightCollectionView.configSideRefresh(with: DefaultRefreshRight.right(), container: self, at: SideRefreshDestination.right) {
            if let categorys = self.categorys {
                let vc = CategoryResultController(collectionViewLayout: UICollectionViewFlowLayout())
                vc.catID = categorys[self.verticalSegment.selectedSegmentIndex].id
                vc.navTitle = categorys[self.verticalSegment.selectedSegmentIndex].name
//                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }

        }
        self.view.addSubview(rightCollectionView)
    }
    private func setupLeftVerticalSegment(){
        self.view.addSubview(leftScrollView)
        leftScrollView.addSubview(verticalSegment)
    }
    
    private func setupNavigationBar(){
        navigationItem.title = "分类浏览"
    }
}
//MARK: - clicked listener
extension CategoryViewController {
    @objc func segmentValueChanged(segment: SMSegmentView){
        //每次点击segment时将该segment自动滑动到屏幕中部，如果点击的是不需要滑动到中间的首尾几个segment，则将segmentView滑动至顶部或者底部
        if segment.selectedSegmentIndex > extrasNum && segment.selectedSegmentIndex < Int(categoryText.count) - extrasNum - 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.leftScrollView.setContentOffset(CGPoint.init(x: 0, y: leftWidth / 2 * CGFloat(segment.selectedSegmentIndex - self.extrasNum)), animated: false)
            })
        }else if segment.selectedSegmentIndex <= extrasNum {
            UIView.animate(withDuration: 0.3, animations: {
                self.leftScrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
            })
        }else {
            UIView.animate(withDuration: 0.3, animations: {
                self.leftScrollView.setContentOffset(CGPoint.init(x: 0, y: self.leftScrollView.contentSize.height - finalContentViewHaveTabbarH), animated: false)
            })
        }
        requestCategoryGoods(cat: categorys![segment.selectedSegmentIndex].id, page: 1)
        if categoryGoods != nil && categoryGoods?.count > 0{
            self.rightCollectionView.scrollToItem(at: IndexPath.init(row: 0, section: 0), at: UICollectionViewScrollPosition.left, animated: true)
        }
    }

    //测试数据
    private func refreshCategoryData(){
        categoryText.removeAll()
        for i in 0...randomNumber(from: 6...50){
            categoryText.append("segment\(i)")
        }
    }
    
    @objc private func showPrompt(){
        let prompt = MaterialTapTargetPrompt(target: promptButton, type: .circle)
        prompt.circleColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 0.6941085188)
        prompt.textPostion = .centerLeft
        prompt.secondaryFont = UIFont.systemFont(ofSize: 30)
        prompt.primaryText = ""
        prompt.secondaryText = "      左滑查看更多"
        prompt.dismissed = {
            self.dismissPromptButton()
        }
        prompt.action = {
            self.dismissPromptButton()
        }
    }
    
    @objc private func dismissPromptButton(){
        self.promptButton.removeFromSuperview()
    }
}

extension CategoryViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryGoods?.count ?? 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCellID, for: indexPath) as! RightCollectionViewCell
//        cell.imageView.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
//        cell.nameLabel.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
//        cell.sellPriceLabel.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
//        cell.marketPriceLabel.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        //绑定数据
        if let goods = categoryGoods {
            cell.imageView.kf.setImage(with: URL.init(string: BASE_URL + goods[indexPath.row].img), placeholder: UIImage.init(named: "loading"), options: nil, progressBlock: nil, completionHandler: nil)
            cell.nameLabel.text = goods[indexPath.row].name
            cell.sellPriceLabel.text = "￥\(goods[indexPath.row].sell_price)"
            cell.marketPriceLabel.attributedText = YTools.textAddMiddleLine(text: "￥\(goods[indexPath.row].market_price)")
        }else {
            cell.imageView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
            cell.nameLabel.text = "goodsName"
            cell.sellPriceLabel.text = "sellPrice"
            cell.marketPriceLabel.attributedText = YTools.textAddMiddleLine(text: "marketPrice")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpace
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        //设置headerVIew
//        let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headID, for: indexPath)
//        let headText = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: headViewH))
//        headText.text = "ABC"
//        headText.attributedText = headText.text?.bold
//        headText.textAlignment = .center
//        headText.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        headText.font = UIFont.systemFont(ofSize: 18)
//        head.addSubview(headText)
//        return head
//    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        collectionView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        YTools.pushToGoodsDetail(goodsID: categoryGoods![indexPath.row].id, navigationController: self.navigationController, sender: self)
    }
}

