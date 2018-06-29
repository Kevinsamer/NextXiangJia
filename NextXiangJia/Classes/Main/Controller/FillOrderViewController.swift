//
//  FillOrderViewController.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/6/29.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
private let bottomViewH:CGFloat = 60
private let collCellID = "collCellID"
class FillOrderViewController: UIViewController {
    private var name = ""
    private var phone = ""
    private var address = ""
    private var totalPrice = ""
    
    //MARK: - 懒加载
    //①收件人信息views
    lazy var addressLine: UIImageView = {
        //底部线
        let imageV = UIImageView(frame: CGRect(x: 0, y: 80, width: finalScreenW - 20, height: 4))
        //imageV.sizeToFit()
        imageV.contentMode = .scaleAspectFit
        imageV.image = UIImage(named: "address_line")
        return imageV
    }()
    
    lazy var nameAndPhoneLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: (finalScreenW - 20) * 2 / 3, height: 50))
        label.text = name + "   " + phone
        label.font = UIFont.systemFont(ofSize: 22).bold
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 50, width: (finalScreenW - 20) * 7 / 8, height: 30))
        label.text = address
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var moreAddressImageV: UIImageView = {
        let imageV = UIImageView(frame: CGRect(x: (finalScreenW - 20) * 7 / 8, y: 0, width: (finalScreenW - 20) / 8, height: 80))
        imageV.contentMode = .center
        //imageV.backgroundColor = .red
        imageV.image = UIImage(named: "contact_addressList_accessoryBtn_n")!
        return imageV
    }()
    
    //底部支付bar
    lazy var bottomView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: UIDevice.current.isX() ? finalScreenH - bottomViewH - IphonexHomeIndicatorH : finalScreenH - bottomViewH, width: finalScreenW, height: bottomViewH))
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }()
    
    lazy var submitBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: finalScreenW * 2 / 3, y: 0, width: finalScreenW / 3, height: bottomViewH)
        button.setTitleForAllStates("提交订单")
        button.setTitleColorForAllStates(.white)
        button.backgroundColor = .red
        return button
    }()
    
    lazy var bottomPriceLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: finalScreenW * 2 / 3, height: bottomViewH))
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .red
        label.attributedText = YTools.changePrice(price: totalPrice, fontNum: 22)
        return label
    }()
    
    
    //主体view，通过collView展示
    lazy var collView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let coll = UICollectionView(frame: CGRect(x: 0, y: finalStatusBarH + finalNavigationBarH, width: finalScreenW, height: finalContentViewNoTabbarH - bottomViewH), collectionViewLayout: layout)
        coll.delegate = self
        coll.dataSource = self
        coll.allowsSelection = false
        coll.backgroundColor = .white
        coll.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collCellID)
        coll.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        return coll
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
//MARK: - 设置UI
extension FillOrderViewController {
    private func setUI(){
        //0.初始化数据
        initData()
        //1.修改背景色
        self.view.backgroundColor = .white
        //2.设置导航栏
        setNavigationBar()
        //3.设置底部view（提交订单按钮、总价）
        setBottomView()
        //4.设置主体的tableView
        setCollectionView()
    }
    
    private func initData(){
        name = "余志超"
        phone = YTools.changePhoneNum(phone: "13160107520")
        address = "江苏常州市武进区花园街200 传媒大厦"
        totalPrice = "￥23333.33"
    }
    
    private func setCollectionView(){
        self.view.addSubview(collView)
    }
    
    private func setNavigationBar(){
        //去除返回按钮的文字
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = "填写订单"
    }
    
    private func setBottomView(){
        bottomView.addSubview(bottomPriceLabel)
        bottomView.addSubview(submitBtn)
        self.view.addSubview(bottomView)
    }
}

extension FillOrderViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collCellID, for: indexPath)
        cell.backgroundColor = UIColor.white
        cell.layer.shadowOpacity = 0.8
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.layer.shadowRadius = 5
        
        switch indexPath.row {
        case 0:
            cell.addSubview(nameAndPhoneLabel)
            cell.addSubview(addressLabel)
            cell.addSubview(moreAddressImageV)
            cell.addSubview(addressLine)
        case 1:
            cell.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        case 2:
            cell.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        case 3:
            cell.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        case 4:
            cell.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        default:
            cell.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0:
            return CGSize(width: finalScreenW - 20, height: 84)
        case 1:
            return CGSize(width: finalScreenW - 20, height: 40)
        case 2:
            return CGSize(width: finalScreenW - 20, height: finalScreenW / 2)
        case 3:
            return CGSize(width: finalScreenW - 20, height: 160)
        case 4:
            return CGSize(width: finalScreenW - 20, height: 240)
        default:
            return CGSize.zero
        }
    }
    
    
}
