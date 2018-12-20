//
//  MyCollectionViewController.swift
//  NextXiangJia
//  收藏夹
//  Created by DEV2018 on 2018/4/27.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import Toast_Swift
private let collectionViewH:CGFloat = 235
private let collectionViewCellID = "collectionViewCellID"
private let noDataLabelW:CGFloat = finalScreenW
class MyCollectionViewController: UIViewController {
    var collNum:Int = 0
    var collArrays:[MyCollectionModel] = [MyCollectionModel]()
    //MARK: - 懒加载
    lazy var noDataLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 100 + finalNavigationBarH + finalStatusBarH, width: noDataLabelW, height: 40))
        label.text = "您还没有收藏任何宝贝呢！"
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return label
    }()
    
    lazy var MyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: (finalScreenW - 5) / 2, height: collectionViewH)
        let coll = UICollectionView(frame: CGRect.init(x: 0, y: finalStatusBarH + finalNavigationBarH, width: finalScreenW, height: UIDevice.current.isX() ? finalScreenH - finalNavigationBarH - finalStatusBarH - IphonexHomeIndicatorH : finalScreenH - finalNavigationBarH - finalStatusBarH), collectionViewLayout: layout)
        coll.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        coll.allowsSelection = false
        coll.delegate = self
        coll.dataSource = self
        coll.register(UINib.init(nibName: "MyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: collectionViewCellID)
        return coll
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //设置ui
        setUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
//MARK: - 设置ui
extension MyCollectionViewController {
    private func setUI(){
        //0.初始化数据
        initData()
        //1.设置navigationBar
        navigationItem.title = "收藏夹"
        //2.设置bodyContent
        setupBodyContent()
    }
    
    private func initData(){
        collNum = 0
    }
    
    private func setupBodyContent(){
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        if collNum <= 0 {
            setNoDataView()
        }else {
            //有数据设置collectionview
            setCollectionView()
        }
    }
    
    private func setNoDataView(){
        MyCollectionView.removeFromSuperview()
        self.view.addSubview(noDataLabel)
    }
    
    private func setCollectionView(){
        noDataLabel.removeFromSuperview()
        self.view.addSubview(MyCollectionView)
    }
}
//MARK: - 实现UIcollectionView的代理和数据源协议
extension MyCollectionViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellID, for: indexPath) as! MyCollectionViewCell
        cell.CancelButton.addTarget(self, action: #selector(cancelClicked(_:)), for: .touchUpInside)
        return cell
    }
    
}
//MARK: - 事件绑定
extension MyCollectionViewController {
    @objc private func cancelClicked(_ sender: UIView){
//        let cell = (sender.superview?.superview) as! MyCollectionViewCell
//        let indexPath = MyCollectionView.indexPath(for: cell)!
        //真实删除的情况需要通过收藏商品的id来操作
        let alert = UIAlertController(title: "提示", message: "是否取消收藏", preferredStyle: UIAlertControllerStyle.alert)
        let OKAction = UIAlertAction(title: "是", style: UIAlertActionStyle.default) { [unowned self] (OK) in
            self.collNum -= 1
            self.MyCollectionView.reloadData({[unowned self] in
                YTools.showMyToast(rootView: self.view, message: "取消成功",position: .center)
            })
        }
        let CancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (Cancel) in
            
        }
        alert.addAction(OKAction)
        alert.addAction(CancelAction)
        
        self.present(alert, animated: true) {
            
        }
        
        
        
    }
}

