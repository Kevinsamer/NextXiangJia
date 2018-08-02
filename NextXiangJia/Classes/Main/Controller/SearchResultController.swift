//
//  SearchResultController.swift
//  tableViewInNav
//  搜索结果页面
//  Created by DEV2018 on 2018/6/11.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import SwiftEventBus
private var collectionItemW = ( finalScreenW - 3 ) / 2
private var collectionItemH = UIDevice.current.isX() ? collectionItemW * 10 / 8 : collectionItemW * 10 / 9
private var cellID = "cellID"
private let listCellID = "listCellID"
private let collCellID = "collCellID"
private var keys = ""


class SearchResultController: UICollectionViewController {
    private var navBarY:CGFloat?
    private var searchBarY:CGFloat?
    private var navigationBarLayer:CALayer?
    private var searchBarLayer:CALayer?
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 懒加载
    lazy var searchBarVC: UISearchController = {
        let searchBarVC = UISearchController(searchResultsController: nil)
        
        return searchBarVC
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
    
    lazy var naviMissAnimate: CABasicAnimation = {
        let ani = CABasicAnimation(keyPath: "position")
        ani.fromValue = NSValue(cgPoint: CGPoint(x: (navigationBarLayer?.position.x)!, y: self.navBarY!))
        ani.toValue = NSValue(cgPoint: CGPoint(x: (navigationBarLayer?.position.x)!, y: self.navBarY! - finalNavigationBarH))
        ani.duration = 0.5
        return ani
    }()
    
    lazy var naviShowAnimate: CABasicAnimation = {
        let ani = CABasicAnimation(keyPath: "position")
        ani.fromValue = NSValue(cgPoint: CGPoint(x: (navigationBarLayer?.position.x)!, y: self.navBarY! - finalNavigationBarH))
        ani.toValue = NSValue(cgPoint: CGPoint(x: (navigationBarLayer?.position.x)!, y: self.navBarY!))
        ani.duration = 0.5
        return ani
    }()
    
    lazy var searchBarMissAnimate: CABasicAnimation = {
        let ani = CABasicAnimation(keyPath: "position")
        ani.fromValue = NSValue(cgPoint: CGPoint(x: (navigationBarLayer?.position.x)!, y: self.searchBarY!))
        ani.toValue = NSValue(cgPoint: CGPoint(x: (navigationBarLayer?.position.x)!, y: self.searchBarY! - finalNavigationBarH))
        ani.duration = 0.5
        return ani
    }()
    
    lazy var searchBarShowAnimate: CABasicAnimation = {
        let ani = CABasicAnimation(keyPath: "position")
        ani.fromValue = NSValue(cgPoint: CGPoint(x: (navigationBarLayer?.position.x)!, y: self.searchBarY! - finalNavigationBarH))
        ani.toValue = NSValue(cgPoint: CGPoint(x: (navigationBarLayer?.position.x)!, y: self.searchBarY!))
        ani.duration = 0.5
        return ani
    }()
    
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
        //0.初始化数据
        initData()
        //1.设置navigationBar
        setNavigationBar()
        //2.设置collView
        setCollectionView()
        //3.设置searchBar
        setSearchBar()
        self.definesPresentationContext = true
    }
    
    private func initData(){

//        SwiftEventBus.onBackgroundThread(self, name: "searchKeys") {[unowned self] (result) in
//            keys = result?.object as! String
//            self.navigationItem.title = keys
//            print(keys)
//        }
//        CommunicationTools.getCommunications(self, name: Communications.SearchResult) { [unowned self] (notification) in
//            keys = notification?.object as! String
//            self.navigationItem.title = keys
//            print(keys)
//        }
        self.navBarY = self.navigationController?.navigationBar.layer.position.y
        
    }
    
    private func setNavigationBar(){
        navigationItem.rightBarButtonItem = rightItem
        navigationItem.title = "搜索结果"
        navigationBarLayer = self.navigationController?.navigationBar.layer
        //navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    }
    
    private func setCollectionView(){
        collectionView?.collectionViewLayout = collLayout
        //collectionView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView?.register(UINib.init(nibName: "CollCell", bundle: nil), forCellWithReuseIdentifier: collCellID)
        collectionView?.register(UINib.init(nibName: "ListCell", bundle: nil), forCellWithReuseIdentifier: listCellID)
        collectionView?.backgroundColor = UIColor(named: "line_gray")!
    }
    
    private func setSearchBar(){
        if #available(iOS 11.0, *) {
            searchBarVC.delegate = self
            //let searchBar = searchBarVC.searchBar
            searchBarVC.searchBar.tintColor = UIColor.black
            searchBarVC.searchBar.backgroundColor = UIColor.init(named: "global_orange")
            searchBarVC.searchBar.delegate = self
            searchBarVC.searchBar.searchBarStyle = UISearchBarStyle.prominent
            searchBarVC.searchBar.barStyle = UIBarStyle.black
            searchBarVC.searchBar.autocapitalizationType = .words
            searchBarVC.searchBar.placeholder = "请输入搜索内容"
            //searchBar.sizeToFit()
            searchBarVC.searchBar.placeholder = keys
            searchBarVC.searchBar.backgroundImage = UIImage()
//            searchBarVC.searchBar.layer.borderWidth = 5
//            searchBarVC.searchBar.layer.borderColor = UIColor.white.cgColor
            searchBarVC.searchBar.setValue("取消", forKey: "_cancelButtonText")
            if let textfield = searchBarVC.searchBar.value(forKey: "searchField") as? UITextField {
                textfield.textColor = UIColor.blue
                if let backgroundview = textfield.subviews.first {
                    // Background color
                    backgroundview.backgroundColor = UIColor.white
                    
                    // Rounded corner
                    backgroundview.layer.cornerRadius = 10
                    backgroundview.clipsToBounds = true
                    
                }
            }
            
            if let navigationbar = self.navigationController?.navigationBar {
                //navigationbar.barTintColor = UIColor(named: "navibar_bartint_orange")!
                navigationbar.tintColor = .white
            }
            navigationItem.searchController = searchBarVC
            navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
            navigationItem.searchController?.isActive = true
            self.searchBarY = self.navigationItem.searchController?.searchBar.layer.position.y
            self.searchBarLayer = self.navigationItem.searchController?.searchBar.layer
        }
    }
}

extension SearchResultController : UISearchControllerDelegate{
    
}

extension SearchResultController : UISearchBarDelegate {
    
}

extension SearchResultController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = GoodDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
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
        return 21
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if imageButton.isSelected {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listCellID, for: indexPath) as! ListCell
            cell.backgroundColor = UIColor.white
            cell.ImageView.image = UIImage(named: "LaunchImage")
            cell.GoodsInfo.text = "ListViewInfoListViewInfoListViewInfoListViewInfoListViewInfoListViewInfo\(indexPath.row)"
            cell.NewPrice.text = "￥\(indexPath.row)\(indexPath.row)"
            cell.OldPrice.attributedText = YTools.textAddMiddleLine(text: "￥\(indexPath.row)\(indexPath.row)")
            //print("\(indexPath.row)")
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collCellID, for: indexPath) as! CollCell
            cell.backgroundColor = UIColor.white
            cell.ImageView.image = UIImage(named: "LaunchImage")
            cell.GoodsInfo.text = "CollectionViewInfoCollectionViewInfoCollectionViewInfoCollectionViewInfoCollectionViewInfoCollectionViewInfo\(indexPath.item)"
            cell.NewPrice.text = "￥\(indexPath.row)\(indexPath.row)"
            cell.OldPrice.attributedText = YTools.textAddMiddleLine(text: "￥\(indexPath.row)\(indexPath.row)")
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
}

extension SearchResultController : SendDataProtocol {
    func SendData(data: Any?) {
        if let key = (data as? String){
            print("key = \(key)")
            keys = key
        }
    }
}
