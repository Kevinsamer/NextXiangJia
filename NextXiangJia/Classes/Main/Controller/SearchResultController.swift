//
//  SearchResultController.swift
//  tableViewInNav
//  搜索结果页面
//  Created by DEV2018 on 2018/6/11.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import SwiftEventBus
import Kingfisher
import PullToRefreshKit
private var collectionItemW = ( finalScreenW - 3 ) / 2
//private var collectionItemH = UIDevice.current.isX() ? collectionItemW * 10 / 8 : collectionItemW * 10 / 9
private var collectionItemH:CGFloat = 230
private var cellID = "cellID"
private let listCellID = "listCellID"
private let collCellID = "collCellID"


class SearchResultController: UICollectionViewController {
    private var navBarY:CGFloat?
    private var searchBarY:CGFloat?
    private var navigationBarLayer:CALayer?
    private var searchBarLayer:CALayer?
    var keys:String = ""//接收搜索结果
//    private var newKeys = ""
    private var currentPage = 1//当前页
    private var maxNumPerPage = 21//每页数据最多条数
    private var searchResultViewModel : SearchResultViewModel = SearchResultViewModel()
    private var searchResults:[SearchResultModel]?{
        didSet{
            if searchResults != nil {
                noDataLabel.removeFromSuperview()
                self.collectionView?.reloadData()
            }else{
                //nil展示无数据页
                self.collectionView?.switchRefreshFooter(to: FooterRefresherState.removed)
                setNoDataView()
            }
        }
    }
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 懒加载
    lazy var header: DefaultRefreshHeader = {
        let header = DefaultRefreshHeader.header()
        header.setText("下拉刷新", mode: .pullToRefresh)
        header.setText("释放刷新", mode: .releaseToRefresh)
        header.setText("数据刷新成功", mode: .refreshSuccess)
        header.setText("刷新中...", mode: .refreshing)
        header.setText("数据刷新失败，请检查网络设置", mode: .refreshFailure)
        header.tintColor = #colorLiteral(red: 0.9995891452, green: 0.6495086551, blue: 0.2688535452, alpha: 1)
        header.imageRenderingWithTintColor = true
        header.durationWhenHide = 0.4
        return header
    }()
    
    lazy var footer: DefaultRefreshFooter = {
        let footer = DefaultRefreshFooter.footer()
        footer.setText("上拉加载更多", mode: .pullToRefresh)
        footer.setText("到底啦", mode: .noMoreData)
        footer.setText("加载中...", mode: .refreshing)
        footer.setText("点击加载更多", mode: .tapToRefresh)
        footer.textLabel.textColor  = #colorLiteral(red: 0.9995891452, green: 0.6495086551, blue: 0.2688535452, alpha: 1)
        footer.refreshMode = .scroll
        return footer
    }()
    
    lazy var noDataLabel: UILabel = {
        let label = UILabel(frame: CGRect(origin: CGPoint.init(x: 0, y: 100), size: CGSize(width: finalScreenW, height: 60)))
        label.text = "抱歉，没有找到商品额~"
        label.textColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    lazy var searchBarVC: UISearchController = {
        let searchBarVC = UISearchController(searchResultsController: nil)
        
        return searchBarVC
    }()
    private lazy var alphaView : UIControl = {
        //UISearchBar的蒙层
        let view = UIControl(frame: CGRect(x: 0, y: finalStatusBarH + finalNavigationBarH, width: finalScreenW, height: UIDevice.current.isX() ? finalScreenH - IphonexHomeIndicatorH : finalScreenH))
        view.backgroundColor = .black
        view.alpha = 0.3
        view.addTarget(self, action: #selector(dismissAlphaView), for: .touchUpInside)
        return view
    }()
    
    lazy var tableLayout: UICollectionViewFlowLayout = {
        //流式布局--selected
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: finalScreenW, height: finalScreenH / 6)
        layout.minimumLineSpacing = 3
        return layout
    }()
    
    lazy var collLayout: UICollectionViewFlowLayout = {
        //一行两个--normal
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionItemW, height: collectionItemH)
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        //layout.headerReferenceSize = CGSize(width: finalScreenW, height: 40)
        //layout.sectionInset = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
        return layout
    }()
    
    lazy var imageButton: UIButton = {
        let imageButton = UIButton(type: UIButtonType.custom)
        imageButton.setImage(UIImage.init(named: "topBar_icon_09_01"), for: UIControlState())
        
        imageButton.setImage(UIImage.init(named: "topBar_icon_10_01"), for: UIControlState.selected)
        imageButton.addTarget(self, action: #selector(changeLayout), for: UIControlEvents.touchUpInside)
        return imageButton
    }()
    
    lazy var rightItem : UIBarButtonItem = {
        let item = UIBarButtonItem(customView: imageButton)
        return item
    }()
    
//    lazy var naviMissAnimate: CABasicAnimation = {
//        let ani = CABasicAnimation(keyPath: "position")
//        ani.fromValue = NSValue(cgPoint: CGPoint(x: (navigationBarLayer?.position.x)!, y: self.navBarY!))
//        ani.toValue = NSValue(cgPoint: CGPoint(x: (navigationBarLayer?.position.x)!, y: self.navBarY! - finalNavigationBarH))
//        ani.duration = 0.5
//        return ani
//    }()
//
//    lazy var naviShowAnimate: CABasicAnimation = {
//        let ani = CABasicAnimation(keyPath: "position")
//        ani.fromValue = NSValue(cgPoint: CGPoint(x: (navigationBarLayer?.position.x)!, y: self.navBarY! - finalNavigationBarH))
//        ani.toValue = NSValue(cgPoint: CGPoint(x: (navigationBarLayer?.position.x)!, y: self.navBarY!))
//        ani.duration = 0.5
//        return ani
//    }()
//
//    lazy var searchBarMissAnimate: CABasicAnimation = {
//        let ani = CABasicAnimation(keyPath: "position")
//        ani.fromValue = NSValue(cgPoint: CGPoint(x: (navigationBarLayer?.position.x)!, y: self.searchBarY!))
//        ani.toValue = NSValue(cgPoint: CGPoint(x: (navigationBarLayer?.position.x)!, y: self.searchBarY! - finalNavigationBarH))
//        ani.duration = 0.5
//        return ani
//    }()
//
//    lazy var searchBarShowAnimate: CABasicAnimation = {
//        let ani = CABasicAnimation(keyPath: "position")
//        ani.fromValue = NSValue(cgPoint: CGPoint(x: (navigationBarLayer?.position.x)!, y: self.searchBarY! - finalNavigationBarH))
//        ani.toValue = NSValue(cgPoint: CGPoint(x: (navigationBarLayer?.position.x)!, y: self.searchBarY!))
//        ani.duration = 0.5
//        return ani
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //navigationController?.setNavigationBarHidden(false, animated: false)
        SwiftEventBus.unregister(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //navigationItem.hidesSearchBarWhenScrolling = true
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //通过DebugViewHierarchy可见searchBar底部灰色线条为_UIBarBackground下的第二个子空间，使用KVC获取其父控件_UIBarBackground后隐藏其第二个子空间即可消除底部灰线
        for view in (self.navigationController?.navigationBar.subviews)! {
            if view.isKind(of: NSClassFromString("_UIBarBackground")!){
                view.subviews[1].isHidden = true
            }
        }
    }
}

extension SearchResultController {
    
    private func setUI(){
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.navBarY = self.navigationController?.navigationBar.layer.position.y
        //0.初始化数据
        initData()
        //1.设置navigationBar
        setNavigationBar()
        //2.设置collView
        setCollectionView()
        //3.设置searchBar
        setSearchBar()
        //self.definesPresentationContext = true
    }
    
    private func setNoDataView(){
        self.collectionView?.addSubview(noDataLabel)
    }
    
    private func initData(){
        requestResultData(word: keys, page: 1)
    }
    
    private func requestResultData(word:String, page:Int){
        searchResultViewModel.requestSearchResult(word: word, page: page) {[unowned self] in
            if self.currentPage == 1 {
                self.searchResults = self.searchResultViewModel.searchResults
                if self.searchResultViewModel.searchResults?.count < self.maxNumPerPage {
                    self.collectionView?.switchRefreshFooter(to: FooterRefresherState.noMoreData)
                }else {
                    self.collectionView?.switchRefreshFooter(to: FooterRefresherState.normal)
                }
                if self.searchResults != nil {
                    self.collectionView?.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: UICollectionViewScrollPosition.top, animated: false)
                }
                self.collectionView?.reloadData()
            }else {
                if self.searchResultViewModel.searchResults?.count == self.maxNumPerPage && self.searchResults?.last?.id != self.searchResultViewModel.searchResults?.last?.id {
                    //如果请求到的数据条数=每页最大条数,且本页数据最后一个和请求的数据最后一个不相同，则未到最后一页
                    self.searchResults?.append(self.searchResultViewModel.searchResults!)
                    self.collectionView?.switchRefreshFooter(to: FooterRefresherState.normal)
                }else if self.searchResultViewModel.searchResults?.count < self.maxNumPerPage {
                    //如果请求到的数据条数<每页最大条数，则已经请求到最后一组分页数据，且该请求数据需添加至当前数据集合
                    self.searchResults?.append(self.searchResultViewModel.searchResults!)
                    self.collectionView?.switchRefreshFooter(to: FooterRefresherState.noMoreData)
                }else {
                    //如果请求到的数据=每页最大条数且最后一条相同，则已请求到最后一组数据且该请求数据无需添加到当前数据集合
                    self.collectionView?.switchRefreshFooter(to: FooterRefresherState.noMoreData)
                }
            }
            
            //self.searchResults?.append(self.searchResultViewModel.searchResults!)
        }
    }
    
    private func setNavigationBar(){
        navigationItem.rightBarButtonItem = rightItem
        navigationItem.title = "搜索结果"
        navigationBarLayer = self.navigationController?.navigationBar.layer
        //navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    }
    
    private func setCollectionView(){
        collectionView?.frame.size = CGSize(width: finalScreenW, height: UIDevice.current.isX() ? finalScreenH - IphonexHomeIndicatorH : finalScreenH)
        collectionView?.collectionViewLayout = collLayout
        //collectionView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView?.register(UINib.init(nibName: "CollCell", bundle: nil), forCellWithReuseIdentifier: collCellID)
        collectionView?.register(UINib.init(nibName: "ListCell", bundle: nil), forCellWithReuseIdentifier: listCellID)
        collectionView?.backgroundColor = UIColor(named: "line_gray")!
//        collectionView?.contentInsetAdjustmentBehavior = .never
        
        collectionView?.configRefreshHeader(with: header, container: self, action: {[unowned self] in
            self.currentPage = 1
            self.requestResultData(word: self.keys, page: self.currentPage)
            self.collectionView?.reloadData {
                self.collectionView?.switchRefreshHeader(to: HeaderRefresherState.normal(RefreshResult.success, 0.3))
            }
        })
        
        collectionView?.configRefreshFooter(with: footer, container: self, action: {[unowned self] in
            self.currentPage += 1
            self.requestResultData(word: self.keys, page: self.currentPage)
            self.collectionView?.reloadData()
        })
    }
    
    private func setSearchBar(){
        if #available(iOS 11.0, *) {
            searchBarVC.delegate = self
            //let searchBar = searchBarVC.searchBar
            searchBarVC.searchBar.tintColor = UIColor.black
            searchBarVC.searchBar.backgroundColor = UIColor.init(named: "global_orange")
            searchBarVC.searchBar.delegate = self
            searchBarVC.searchResultsUpdater = self
            searchBarVC.dimsBackgroundDuringPresentation = false
            searchBarVC.searchBar.searchBarStyle = UISearchBarStyle.prominent
            searchBarVC.searchBar.barStyle = UIBarStyle.default
            searchBarVC.searchBar.autocapitalizationType = .words
            searchBarVC.searchBar.placeholder = "请输入搜索内容"
            searchBarVC.searchBar.placeholder = keys
            searchBarVC.searchBar.backgroundImage = UIImage()
            searchBarVC.searchBar.showsCancelButton = true
            let UIButton = searchBarVC.searchBar.value(forKey: "_cancelButton") as? UIButton
            UIButton?.setTitle("取消", for: .normal)
            UIButton?.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),for: .normal)
            if let textfield = searchBarVC.searchBar.value(forKey: "_searchField") as? UITextField {
                textfield.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                //textfield.setValue(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), forKeyPath: "_placeholderLabel.textColor")
                if let backgroundview = textfield.subviews.first {
                    // Background color
                    backgroundview.backgroundColor = UIColor.white

                    // Rounded corner
                    backgroundview.layer.cornerRadius = 10
                    backgroundview.clipsToBounds = true

                }
            }
            
            
            navigationItem.searchController = searchBarVC
            navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
            //navigationItem.searchController?.isActive = true
            self.searchBarY = self.navigationItem.searchController?.searchBar.layer.position.y
            self.searchBarLayer = self.navigationItem.searchController?.searchBar.layer
        }
    }
}

extension SearchResultController : UISearchControllerDelegate,UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        
    }
    
}

extension SearchResultController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //print(searchBar.text)
        keys = searchBar.text ?? ""
        if keys != "" {
            currentPage = 1
            searchBar.text = ""
            searchBar.placeholder = keys
            requestResultData(word: keys, page: currentPage)
        }
        dismissAlphaView()
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        self.view?.addSubview(alphaView)
        return true
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        keys = searchText
//    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissAlphaView()
    }
    
}

extension SearchResultController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let results = searchResults {
            let vc = GoodDetailViewController(goodsID: results[indexPath.row].id)
            self.navigationBarLayer?.position.y = self.navBarY!
            //self.searchBarLayer?.position.y = self.searchBarY!
            self.navigationItem.hidesBackButton = false
            self.navigationItem.title = "搜索结果"
            self.navigationItem.rightBarButtonItem?.customView?.isHidden = false
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        print(velocity.y)
//        print(scrollView.contentOffset.y)
        if velocity.y > 0 {
            //隐藏搜索框
//            navigationBarLayer?.add(naviMissAnimate, forKey: "missNavi")
//            searchBarLayer?.add(searchBarMissAnimate, forKey: "searchMiss")
            UIView.animate(withDuration: 0.5, animations: {[unowned self] in
                self.navigationBarLayer?.position.y = self.navBarY! - finalNavigationBarH
                //self.searchBarLayer?.position.y = self.searchBarY! - finalNavigationBarH
                self.navigationItem.hidesBackButton = true
                self.navigationItem.title = ""
                self.navigationItem.rightBarButtonItem?.customView?.isHidden = true
            })
            //navigationController?.setNavigationBarHidden(true, animated: true)
        }else{
            //显示
            
//            navigationBarLayer?.add(naviShowAnimate, forKey: "showNavi")
//            searchBarLayer?.add(searchBarShowAnimate, forKey: "searchShow")
            UIView.animate(withDuration: 0.5, animations: {[unowned self] in
                self.navigationBarLayer?.position.y = self.navBarY!
                //self.searchBarLayer?.position.y = self.searchBarY!
                self.navigationItem.hidesBackButton = false
                self.navigationItem.title = "搜索结果"
                self.navigationItem.rightBarButtonItem?.customView?.isHidden = false
            })
            //navigationController?.setNavigationBarHidden(false, animated: true)

        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if imageButton.isSelected {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listCellID, for: indexPath) as! ListCell
            cell.backgroundColor = UIColor.white
            if let results = searchResults {
                cell.ImageView.kf.setImage(with: URL.init(string: BASE_URL + "\(results[indexPath.row].img)"), placeholder: UIImage.init(named: "loading"), options: nil, progressBlock: nil, completionHandler: nil)
                cell.GoodsInfo.text = "\(results[indexPath.row].name)"
                cell.NewPrice.text = "￥\(results[indexPath.row].sell_price)"
                cell.OldPrice.attributedText = YTools.textAddMiddleLine(text: "￥\(results[indexPath.row].market_price)")
            }
            
            
            //print("\(indexPath.row)")
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collCellID, for: indexPath) as! CollCell
            cell.backgroundColor = UIColor.white
            if let results = searchResults {
                cell.ImageView.kf.setImage(with: URL.init(string: BASE_URL + "\(results[indexPath.row].img)"), placeholder: UIImage.init(named: "loading"), options: nil, progressBlock: nil, completionHandler: nil)
                cell.GoodsInfo.text = "\(results[indexPath.row].name)"
                cell.NewPrice.text = "￥\(results[indexPath.row].sell_price)"
                cell.OldPrice.attributedText = YTools.textAddMiddleLine(text: "￥\(results[indexPath.row].market_price)")
            }
            //print("\(indexPath.row)")
            return cell
        }
    }
}
//MARK: - 响应事件
extension SearchResultController {
    @objc private func changeLayout(){
        imageButton.isSelected = !imageButton.isSelected
        if imageButton.isSelected {
            collectionView?.collectionViewLayout = tableLayout
            collectionView?.reloadData()
        }else{
            collectionView?.collectionViewLayout = collLayout
            collectionView?.reloadData()
        }
        
    }
    
    @objc private func dismissAlphaView(){
        alphaView.removeFromSuperview()
        searchBarVC.searchBar.setShowsCancelButton(false, animated: true)
        searchBarVC.searchBar.resignFirstResponder()
    }
}

//extension SearchResultController : SendDataProtocol {
//    func SendData(data: Any?) {
//        if let key = (data as? String){
//            print("key = \(key)")
//            //keys = key
//        }
//    }
//}

