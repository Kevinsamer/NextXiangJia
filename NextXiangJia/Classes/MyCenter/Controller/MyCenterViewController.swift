//
//  MyCenterViewController.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/3/20.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import FontAwesome_swift
import Kingfisher
import SwifterSwift
import Foundation
//searchBar attribute
private let searchBarH:CGFloat = 64
private let MyInfoCellID = "MyInfoCellID"
private let headViewRealH : CGFloat = 600 //实际高度600
private let headViewUsedH : CGFloat = 200 //可用高度200
private let headToBodyH : CGFloat = 20
private let bodyViewH : CGFloat = 505
private let headLabelW : CGFloat = finalScreenW / 3 - 20
private let headLabelH : CGFloat = 20
private let fa:[FontAwesome] = [.trophy,.tags,.reply,.file,.comment,.comments,.bell,.heart,.moneyBillAlt,.signInAlt,.mapMarker,.table,.key]
private let faText = ["我的积分","我的代金券","退款申请","站点建议","商品咨询","商品评价","短信息","收藏夹","账户余额","在线充值","地址管理","个人资料","修改密码"]
private let rootScrollViewH : CGFloat = headViewUsedH + headToBodyH + bodyViewH
class MyCenterViewController: UIViewController {
    
    //MARK: - sb拖拽控件
    @IBOutlet var headView: UIView!
    
    @IBOutlet var bodyView: UIView!
    
    @IBOutlet var rootScrollView: UIScrollView!
    // MARK: - 懒加载属性
    lazy var myInfoColltionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let coll = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: finalScreenW, height: bodyViewH), collectionViewLayout: layout)
        coll.dataSource = self
        coll.delegate = self
        coll.backgroundColor = .white
        coll.register(MyCenterCell.self, forCellWithReuseIdentifier: MyInfoCellID)
        return coll
    }()
    //Head Iconssa
    lazy var headImageView : UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 40, y: 420, width: 80, height: 80))
//        imageView.image = UIImage(named: "loading")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.layer.borderColor = UIColor(named: "head_view_border_color")?.cgColor
        imageView.layer.borderWidth = 2
        imageView.backgroundColor = .white
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickHeadView(sender: )))
//        imageView.addGestureRecognizer(tapGesture)
//        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    //ID Label
    lazy var myIDLabel : UILabel = {
        let label = UILabel(frame: CGRect(x: 140, y: 445, width: 200, height: 30))
        label.textAlignment = NSTextAlignment.left
//        label.text = "This is my IDThis is my IDThis is my IDThis is my ID"
        label.textColor = .white
        label.font = UIFont(name: "Arial", size: 21.0)?.bold
//        label.adjustsFontSizeToFitWidth = true // 改变字号使所有字符能显示
        return label
    }()
    
    lazy var topInfoView: UIView = {
        let view = UIView(frame: CGRect(x: 10, y: 520, width: finalScreenW - 20, height: 70))
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.layer.cornerRadius = 10
        view.layer.shadowOpacity = 0.3
        view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = .zero
        return view
    }()
    
    lazy var myBalanceLabel : UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 40, width: (headLabelW), height: headLabelH))
        label.textColor = .black
        label.text = "余额"
        label.font = UIFont(name: "Arial", size: 15.0)
        label.textAlignment = .center
        return label
    }()
    //余额num
    lazy var myBalanceNum : UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 10, width: (headLabelW), height: headLabelH))
        label.textColor = .black
//        label.text = "10.00"
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 20.0)
        return label
    }()
    lazy var myExpGroupLabel : UILabel = {
        let label = UILabel(frame: CGRect(x: (finalScreenW - 20) / 3, y: 40, width: (headLabelW ), height: headLabelH))
        label.textColor = .black
        label.text = "经验值"
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 15.0)
        return label
    }()
    lazy var myExpGroupDetail : UILabel = {
        let label = UILabel(frame: CGRect(x: (finalScreenW - 20) / 3, y: 10, width: (headLabelW ), height: headLabelH))
        label.textColor = .black
//        label.text = ""
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 20.0)
        return label
    }()
    lazy var myScoreLabel : UILabel = {
        let label = UILabel(frame: CGRect(x: (finalScreenW - 20) / 3 * 2, y: 40, width: (headLabelW), height: headLabelH))
        label.textColor = .black
        label.text = "积分"
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 15.0)
        return label
    }()
    //积分num
    lazy var myScoreNum : UILabel = {
        let label = UILabel(frame: CGRect(x: (finalScreenW - 20) / 3 * 2, y: 10, width: (headLabelW), height: headLabelH))
        label.textColor = .black
//        label.text = "0.00"
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 20.0)
        return label
    }()
    lazy var testSwitchButton : UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.frame = CGRect(x: finalScreenW / 3 + 10, y: 490, width: (headLabelW ), height: headLabelH)
        button.setTitle("Test data", for: UIControlState.normal)
        button.addTarget(self, action: #selector(testButtonClicked), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var settingBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "mycenter_navigation_setting_icon"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(pushToSetting), for: UIControlEvents.touchUpInside)
        return btn
    }()

    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //设置UI
        setUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tabBarController?.tabBar.isHidden = false
        initDatas()
    }

}
// MARK: - 设置UI界面
extension MyCenterViewController{
    private func setUI(){
        //0.初始化数据
        initDatas()
        //1.设置导航栏
        setupNavigationBar()
        //2.设置rootScrollView
        setupRootScrollView()
        //3.设置headView
        setupHeadView()
        //4.设置bodyView
        setupBodyView()
    }
    private func initDatas(){
        if AppDelegate.appUser?.id == -1 {
            headImageView.image = UIImage(named: "loading")
            myIDLabel.text = "登录/注册"
            myBalanceNum.text = "0.00"
            myScoreNum.text = "0"
            myExpGroupDetail.text = "0"
        }else {
            headImageView.kf.setImage(with: URL.init(string: BASE_URL + (AppDelegate.appUser?.head_ico)!), placeholder: UIImage.init(named: "loading"), options: nil, progressBlock: nil, completionHandler: nil)
            myIDLabel.text = AppDelegate.appUser?.username
            myBalanceNum.text = "\(AppDelegate.appUser?.balance ?? 0.00)"
            myScoreNum.text = "\(AppDelegate.appUser?.point ?? 0)"
            myExpGroupDetail.text = "\(AppDelegate.appUser?.exp ?? 0)"
        }
    }
    private func setupHeadView(){
        headView.backgroundColor = UIColor.init(named: "global_orange")
        headView.addSubview(headImageView)
        headView.addSubview(myIDLabel)
        headView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickHeadView(sender: )))
        headView.addGestureRecognizer(tapGesture)
        topInfoView.addSubview(myBalanceLabel)
        topInfoView.addSubview(myBalanceNum)
        topInfoView.addSubview(myExpGroupLabel)
        topInfoView.addSubview(myExpGroupDetail)
        topInfoView.addSubview(myScoreLabel)
        topInfoView.addSubview(myScoreNum)
        headView.addSubview(topInfoView)
        let lineV1 = UIView(frame: CGRect(x: finalScreenW / 3 - 0.5, y: 520, width: 1, height: 60))
        lineV1.backgroundColor = .white
        headView.addSubview(lineV1)
        let lineV2 = UIView(frame: CGRect(x: finalScreenW / 3 * 2 - 0.5, y: 520, width: 1, height: 60))
        lineV2.backgroundColor = .white
        headView.addSubview(lineV2)
        if testMode {
            headView.addSubview(testSwitchButton)
        }
    }
    private func setupBodyView(){
        bodyView.addSubview(myInfoColltionView)
    }
    private func setupRootScrollView(){
        rootScrollView.backgroundColor = .white
        rootScrollView.contentSize = CGSize(width: finalScreenW, height: rootScrollViewH)
        rootScrollView.alwaysBounceVertical = false
        rootScrollView.isScrollEnabled = true
        rootScrollView.showsVerticalScrollIndicator = true
    }
    private func setupNavigationBar(){
        navigationItem.title = "个人中心"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingBtn)
    }
}
//MARK: - UICollectionView->dataSource, delegate
extension MyCenterViewController :UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyInfoCellID, for: indexPath) as! MyCenterCell
        cell.layer.borderColor = UIColor(named: "line_gray")?.cgColor
        cell.layer.borderWidth = 0.5
        cell.backgroundColor = .white
        for index in 1...13 {
            if indexPath.row == index {
                cell.labelText?.text = faText[index - 1]
                cell.labelFA?.text = String.fontAwesomeIcon(name: fa[index - 1])
            }
        }
        switch indexPath.row {
        case 0:
            cell.removeSubviews()
            let labelFA = UILabel(frame: CGRect(x: 30, y: 25, width: 50, height: 50))
            let labelText = UILabel(frame: CGRect(x: 90, y: 35, width: 80, height: 30))
            //labelText.backgroundColor = .red
            labelText.text = "我的订单"
            labelText.textAlignment = .center
            labelText.font = UIFont(name: "Arial", size: 18.0)
            labelFA.text = String.fontAwesomeIcon(name: fa[0])
            labelFA.font = UIFont.fontAwesome(ofSize: 50, style: .solid)
            labelFA.textColor = myCenterColors.random()
            labelFA.textAlignment = NSTextAlignment.center
            labelFA.text = String.fontAwesomeIcon(name: .shoppingBag)
            cell.addSubview(labelText)
            cell.addSubview(labelFA)
        case 14:
            let line = UIView(frame: CGRect(x: 0, y: cell.bounds.height , width: cell.bounds.width, height: 0.5))
            line.backgroundColor = UIColor(named: "line_gray")
            cell.addSubview(line)
        case 17:
            let line = UIView(frame: CGRect(x: cell.bounds.width , y: 0, width: 0.5, height: cell.bounds.height))
            line.backgroundColor = UIColor(named: "line_gray")
            cell.addSubview(line)
        default: break
        }
        return cell
        
    }
    //设置cellSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: finalScreenW / 2, height: 100)
        }else{
            return CGSize(width: finalScreenW / 4, height: 100)
        }
    }
    
    //通过flowLayoutDelegate设置行列边距为0
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            //print("我的订单")
            let orderVC = MyOrdersViewController()
            pushToVC(vc: orderVC)
        case 1:
            //print("我的积分")
            let scoreVC = MyScoreViewController()
            pushToVC(vc: scoreVC)
        case 2:
            //print("我的代金券")
            let vouchersVC = MyVouchersViewController()
            pushToVC(vc: vouchersVC)
        case 3:
            //print("退款申请")
            let refundVC = MyRefundApplicationViewController()
            pushToVC(vc: refundVC)
        case 4:
            //print("站点建议")
            let suggestionVC = MySuggestionsViewController()
            pushToVC(vc: suggestionVC)
        case 5:
            //print("商品咨询")
            let advisoryVC = MyAdvisoryViewController()
            pushToVC(vc: advisoryVC)
        case 6:
            //print("商品评价")
            let evaluationVC = MyEvaluationViewController()
            pushToVC(vc: evaluationVC)
        case 7:
            //print("短信息")
            let messageVC = MyMessageViewController()
            pushToVC(vc: messageVC)
        case 8:
            //print("收藏夹")
            let collectionVC = MyCollectionViewController()
            pushToVC(vc: collectionVC)
        case 9:
            //print("账户余额")
            let balanceVC = MyBalanceViewController()
            pushToVC(vc: balanceVC)
        case 10:
            //print("在线充值")
            let rechargeVC = MyRechargeOnlineViewController()
            pushToVC(vc: rechargeVC)
        case 11:
            //print("地址管理")
            let addressVC = MyAddressViewController()
            pushToVC(vc: addressVC)
        case 12:
            //print("个人资料")
            let myInfoVC = MyInfoViewController()
            pushToVC(vc: myInfoVC)
        case 13:
            //print("修改密码")
            let changePasswordVC = ChangePasswordViewController()
            pushToVC(vc: changePasswordVC)
//        case 14:
//            print("发票管理")
//            let invoiceManage = MyInvoiceManageViewController()
//            pushToVC(vc: invoiceManage)
//        case 15:
//            print("我的推介")
//            let commendVc = MyCommendViewController()
//            pushToVC(vc: commendVc)
//        case 16:
//            print("我的下线成员")
//            let myMemberVC = MyMemberViewController()
//            pushToVC(vc: myMemberVC)
//        case 17:
//            print("我的佣金")
//            let commissionVC = MyCommissionViewController()
//            pushToVC(vc: commissionVC)
        default:
            break
        }
    }
}

//MARK: - click listener
extension MyCenterViewController{
    @objc func testButtonClicked(){
        myInfoColltionView.reloadData()
        headImageView.image = UIImage(named: "shopcart_top_home_left")
        myBalanceNum.text = "\(Float.random(between: 0.0, and: 10000.0))"
        myScoreNum.text = "\(Float.random(between: 20.0, and: 3000.0))"
        myIDLabel.text = "\(String.random(ofLength: 11))"
    }
    @objc func clickHeadView(sender: UITapGestureRecognizer){
        if AppDelegate.appUser?.id == -1 {
            pushToLogin()
        }else {
            pushToSetting()
        }
    }
    
    func pushToVC(vc: UIViewController){
        //vc.hidesBottomBarWhenPushed = true
        self.navigationController?.show(vc, sender: self)
    }
    
    @objc func pushToSetting(){
        let myInfoVC = MyInfoViewController()
        pushToVC(vc: myInfoVC)
    }
    
    func pushToLogin(){
        let loginVC = LoginViewController()
        pushToVC(vc: loginVC)
    }
}

