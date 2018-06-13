//
//  CategoryViewController.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/3/20.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import FontAwesome_swift
private let leftWidth:CGFloat = 100
private var categoryNum = 10
private var lineNum = 3
private let MyCellID = "MyCellID"
private let headID = "headID"
private var centerX:CGFloat = finalContentViewHaveTabbarH / 2 + 25
private var categoryText:[String] = []//左侧
private var cellText:[String] = []//右侧
class CategoryViewController: UIViewController {
    // MARK: - 懒加载属性
    lazy var rightCollectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: 100, height: 10)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: (finalScreenW - leftWidth - 40) / 3, height: 60)
        let coll = UICollectionView(frame: CGRect(x: leftWidth, y: 0, width: finalScreenW - leftWidth, height: finalContentViewHaveTabbarH), collectionViewLayout: layout)
        coll.dataSource = self
        coll.delegate = self
        //coll.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coll.alwaysBounceVertical = true
        coll.register(UINib.init(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headID)
        //coll.cancelInteractiveMovement()
        coll.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCellID")
        coll.backgroundColor = .white
        
        return coll
    }()
    lazy var leftScrollView: UIScrollView = {
        var scroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: leftWidth, height: finalContentViewHaveTabbarH))
        scroll.contentSize = CGSize(width: leftWidth, height: leftWidth * CGFloat(categoryText.count) / 2 > finalContentViewHaveTabbarH ? leftWidth * CGFloat(categoryText.count) / 2 : finalContentViewHaveTabbarH + 1 )
        scroll.backgroundColor = UIColor.init(named: "global_orange")!
        return scroll
    }()
    lazy var rightScrollView: UIScrollView = {
        var scroll = UIScrollView(frame: CGRect(x: leftWidth, y: 0, width: finalScreenW - leftWidth, height: finalContentViewHaveTabbarH))
            scroll.contentSize = CGSize(width: finalScreenW - leftWidth, height: finalContentViewHaveTabbarH + 10)
        scroll.backgroundColor = UIColor.white
        return scroll
    }()
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
    private lazy var searchBar:UISearchBar = {
        //搜索栏
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: finalScreenW, height: 64))
        searchBar.searchBarStyle = UISearchBarStyle.default
        searchBar.barStyle = UIBarStyle.default
        searchBar.autocapitalizationType = .words
        searchBar.delegate = self
        searchBar.placeholder = "请输入搜索内容"
        searchBar.tintColor = UIColor(named: "global_orange")
        var background = searchBar.value(forKey: "_background") as! UIView
        background.removeFromSuperview()
        return searchBar
    }()
    private lazy var alphaView : UIControl = {
        //UISearchBar的蒙层
        let view = UIControl(frame: CGRect(x: 0, y: 0, width: finalScreenW, height: finalContentViewNoTabbarH))
        view.backgroundColor = .black
        view.alpha = 0.3
        view.addTarget(self, action: #selector(dismissAlphaViewAndSearchBar), for: .touchUpInside)
        return view
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
}
//设置UI界面
extension CategoryViewController{
    private func setUI(){
        //0.初始化数据
        refreshCategoryData()
        refreshCollData(category: categoryText[0])
        //1.设置导航栏
        setupNavigationBar()
        //2.设置contentView
        setupContentView()
    }
    
    private func setupContentView(){
        //1.设置左侧vertical segment
        setupLeftVerticalSegment()
        //2.设置右侧collectionView
        setupRightCollectionView()
    }
    private func setupRightCollectionView(){
        
        self.view.addSubview(rightCollectionView)
    }
    private func setupLeftVerticalSegment(){
        self.view.addSubview(leftScrollView)
        leftScrollView.addSubview(verticalSegment)
    }
    
    private func setupNavigationBar(){
        //设置图标按钮实现点击高亮效果
        let leftBtn = UIButton.init()
        leftBtn.setTitle(String.fontAwesomeIcon(name: .home), for: .normal)
        leftBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        leftBtn.setTitleColor(.white, for: .normal)
        leftBtn.setTitleColor(UIColor.init(named: "dark_gray"), for: .highlighted)
        
        let rightBtn = UIButton()
        rightBtn.setTitle(String.fontAwesomeIcon(name: .search), for: .normal)
        rightBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        rightBtn.setTitleColor(.white                                                                   , for: .normal)
        rightBtn.setTitleColor(UIColor.init(named: "dark_gray"), for: .highlighted)
        rightBtn.addTarget(self, action: #selector(searchBtnClicked), for: .touchUpInside)
        //设置标题
        let title = UILabel()
        title.font = UIFont(name: "System", size: 18.0)
        title.textColor = .white
        title.text = "分类浏览"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBtn)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        //navigationItem.rightBarButtonItem = UIBarButtonItem.init(imageName: "home_top_search_right")
        navigationItem.title = "分类浏览"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18)]
        //navigationItem.titleView = title
        navigationController?.navigationBar.barTintColor = UIColor.init(named: "global_orange")
        navigationController?.navigationBar.isTranslucent = false
    }
}
//MARK: - clicked listener
extension CategoryViewController {
    @objc func segmentValueChanged(segment: SMSegmentView){
        print("\((finalContentViewHaveTabbarH / 100))")
        //不需要滑动到页面中间的segmentView的个数
        let extrasNum = (finalContentViewHaveTabbarH / 50 / 2).int
        if segment.selectedSegmentIndex > extrasNum && segment.selectedSegmentIndex < Int(categoryText.count) - extrasNum - 1 {
            leftScrollView.setContentOffset(CGPoint.init(x: 0, y: leftWidth / 2 * CGFloat(segment.selectedSegmentIndex - extrasNum)), animated: true)
        }else if segment.selectedSegmentIndex <= extrasNum {
            leftScrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        }else {
            leftScrollView.setContentOffset(CGPoint.init(x: 0, y: leftScrollView.contentSize.height - finalContentViewHaveTabbarH), animated: true)
        }
        
        refreshCollData(category: categoryText[segment.selectedSegmentIndex])
        rightCollectionView.reloadData()
    }
    
    private func refreshCollData(category:String){
        cellText.removeAll()
        for i in 0...randomNumber(from: 8...17){
            cellText.append("\(category)的cell\(i)")
        }
    }
    
    private func refreshCategoryData(){
        categoryText.removeAll()
        for i in 0...randomNumber(from: 6...77){
            categoryText.append("segment\(i)")
        }
    }
    
    @objc private func searchBtnClicked(){
        if searchBarState == 1 {
            //隐藏
            searchBar.removeFromSuperview()
            alphaView.removeFromSuperview()
            searchBarState = 2
        }else if searchBarState == 2 {
            //显示
            view.addSubview(alphaView)
            view.addSubview(searchBar)
            searchBar.becomeFirstResponder()
            searchBarState = 1
        }
    }
    
    @objc private func dismissAlphaViewAndSearchBar(){
        alphaView.removeFromSuperview()
        searchBar.resignFirstResponder()
        searchBtnClicked()
    }
}

extension CategoryViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellText.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCellID, for: indexPath)
        cell.contentView.bounds.size = CGSize(width: 180, height: 180)
        cell.contentView.layer.borderColor = UIColor.blue.cgColor
        cell.contentView.layer.borderWidth = 1
        let text = UITextView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        text.textAlignment = .center
        text.text = cellText[indexPath.row]
        cell.addSubview(text)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension CategoryViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        alphaView.removeFromSuperview()
        searchBtnClicked()
        searchContent = (searchBar.textField?.text)!
        print(searchContent)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        //self.rootScrollView.addSubview(alphaView)
        return true
    }
}
