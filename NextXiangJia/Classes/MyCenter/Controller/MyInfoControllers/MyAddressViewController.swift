//
//  MyAddressViewController.swift
//  NextXiangJia
//  地址管理
//  Created by DEV2018 on 2018/4/27.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
private let addressCellID = "addressCellID"
private var addressNums = 0
class MyAddressViewController: UIViewController {
    //MARK: - 懒加载
    lazy var newAddressButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.frame = CGRect(x: 20, y: finalContentViewNoTabbarH - 60, width: finalScreenW - 40, height: 40)
        button.setTitleForAllStates("＋ 新建地址")
        button.titleLabel?.textAlignment = .center
        button.setTitleColorForAllStates(.white)
        button.backgroundColor = .red
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(addNewAddress), for: UIControlEvents.touchUpInside)
        return button
    }()
    lazy var addressCollectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: finalScreenW, height: 140)
        layout.minimumLineSpacing = 5
        //coll的高度为导航栏以下全部
        let coll = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: finalScreenW, height: UIDevice.current.isX() ? finalContentViewNoTabbarH + IphonexHomeIndicatorH : finalContentViewNoTabbarH ), collectionViewLayout: layout)
        coll.backgroundColor = .white
        coll.isScrollEnabled = true
        coll.dataSource  = self
        coll.delegate = self
        coll.register(UINib.init(nibName: "AddressCell", bundle: nil), forCellWithReuseIdentifier: addressCellID)
        //coll.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
//MARK: - 设置ui
extension MyAddressViewController {
    private func setUI(){
        //1.设置navigationBar tabBar
//        YTools.setNavigationBarAndTabBar(navCT: self.navigationController!, tabbarCT: self.tabBarController!, titleName: "收货地址管理", navItem:self.navigationItem)
        navigationItem.title = "收货地址管理"
        //2.初始化数据
        initDatas()
        //3.设置bodyContent
        setupBodyContent()
    }
    private func initDatas(){
        addressNums = 9
    }
    private func setupBodyContent(){
//        let label = UILabel(frame: CGRect(x: finalScreenW / 2 - 50, y: finalScreenH / 2 - 20, width: 100, height: 40))
//        label.textAlignment = .center
//        label.text = "MyAddressPage"
//        self.view.addSubview(label)
        self.view.backgroundColor = .white
        //1.设置collectionView
        setupAddressCollection()
        //2.设置添加地址button
        setupNewAddressButton()
    }
    private func setupAddressCollection(){
        self.view.addSubview(addressCollectionView)
    }
    private func setupNewAddressButton(){
        self.view.addSubview(newAddressButton)
    }
}

extension MyAddressViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addressNums + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: addressCellID, for: indexPath)
        if indexPath.item == addressNums {
            cell.removeSubviews()
        }
        return cell
    }
    
    
}

extension MyAddressViewController {
    @objc func addNewAddress(){
        //TODO HERE
        var vc = AddNewAddressViewController()
        self.navigationController?.show(vc, sender: self)
    }
}
