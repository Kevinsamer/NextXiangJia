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
private let headViewH:CGFloat = 30
private var categoryNum = 10
private var lineNum = 3
private let MyCellID = "MyCellID"
private let headID = "headID"
private var centerX:CGFloat = finalContentViewHaveTabbarH / 2 + 25
private var categoryText:[String] = []//左侧
private var cellText:[String] = []//右侧
////searchBar attribute
//private let searchBarH:CGFloat = 64
class CategoryViewController: UIViewController {
    // MARK: - 懒加载属性
    lazy var rightCollectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: 100, height: 10)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: (finalScreenW - leftWidth - 40) / 3, height: 60)
        layout.headerReferenceSize = CGSize(width: finalScreenW - leftWidth, height: headViewH)
        let coll = UICollectionView(frame: CGRect(x: leftWidth, y: finalStatusBarH + finalNavigationBarH, width: finalScreenW - leftWidth, height: finalContentViewHaveTabbarH), collectionViewLayout: layout)
        coll.dataSource = self
        coll.delegate = self
        //coll.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coll.alwaysBounceVertical = true
        //coll.register(UINib.init(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headID)
        //coll.cancelInteractiveMovement()
        coll.register(UICollectionViewCell.self, forCellWithReuseIdentifier: MyCellID)
        coll.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        coll.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headID)
        return coll
    }()
    lazy var leftScrollView: UIScrollView = {
        var scroll = UIScrollView(frame: CGRect(x: 0, y: finalStatusBarH + finalNavigationBarH, width: leftWidth, height: finalContentViewHaveTabbarH))
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
        navigationItem.title = "分类浏览"
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
}

extension CategoryViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellText.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCellID, for: indexPath)
//        cell.contentView.bounds.size = CGSize(width: 180, height: 180)
//        cell.contentView.layer.borderColor = UIColor.blue.cgColor
//        cell.contentView.layer.borderWidth = 1
        //cell.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        let text = UITextView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        text.textAlignment = .center
        text.text = cellText[indexPath.row]
        text.isEditable = false
        text.isSelectable = false
        text.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
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
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headID, for: indexPath)
        let headText = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: headViewH))
        headText.text = "ABC"
        headText.attributedText = headText.text?.bold
        headText.textAlignment = .center
        headText.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        headText.font = UIFont.systemFont(ofSize: 18)
        head.addSubview(headText)
        return head
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    }
}

