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
        navigationController?.setNavigationBarHidden(false, animated: false)
        SwiftEventBus.unregister(self)
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
        
    }
    
    private func setNavigationBar(){
        navigationItem.rightBarButtonItem = rightItem
        navigationItem.title = "搜索结果"
    }
    
    private func setCollectionView(){
        collectionView?.collectionViewLayout = collLayout
        //collectionView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView?.register(UINib.init(nibName: "CollCell", bundle: nil), forCellWithReuseIdentifier: collCellID)
        collectionView?.register(UINib.init(nibName: "ListCell", bundle: nil), forCellWithReuseIdentifier: listCellID)
        collectionView?.backgroundColor = .lightGray
    }
    
    private func setSearchBar(){
        if #available(iOS 11.0, *) {
            
            searchBarVC.delegate = self
            let searchBar = searchBarVC.searchBar
            searchBar.tintColor = UIColor.white
            searchBar.barTintColor = UIColor.white
            searchBar.delegate = self
            searchBar.searchBarStyle = UISearchBarStyle.default
            searchBar.barStyle = UIBarStyle.default
            searchBar.autocapitalizationType = .words
            searchBar.placeholder = "请输入搜索内容"
            searchBarVC.searchBar.placeholder = keys
            searchBar.setValue("取消", forKey: "_cancelButtonText")
            if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
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
                navigationbar.barTintColor = UIColor(named: "global_orange")
                navigationbar.tintColor = .white
            }
            navigationItem.searchController = searchBarVC
            navigationItem.hidesSearchBarWhenScrolling = false
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
        print(velocity.y)
        if velocity.y > 0 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }else{
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
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
