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
private let MyInfoCellID = "MyInfoCellID"
private let headViewRealH : CGFloat = 600 //实际高度600
private let headViewUsedH : CGFloat = 200 //可用高度200
private let headToBodyH : CGFloat = 20
private let bodyViewH : CGFloat = 505
private let headLabelW : CGFloat = finalScreenW / 3 - 20
private let headLabelH : CGFloat = 20
private let fa:[FontAwesome] = [.trophy,.tags,.reply,.file,.comment,.comments,.bell,.heart,.money,.signIn,.mapMarker,.table,.key,.ticket,.twitter,.sitemap,.creditCard]
private let faText = ["我的积分","我的代金券","退款申请","站点建议","商品咨询","商品评价","短信息","收藏夹","账户余额","在线充值","地址管理","个人资料","修改密码","发票管理","我的推介","我的下线成员","我的佣金"]
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
    lazy var headImageView : UIImageView = {[unowned self] in
        let imageView = UIImageView(frame: CGRect(x: 40, y: 420, width: 80, height: 80))
//        imageView.image = UIImage(named: "loading")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.layer.borderColor = UIColor(named: "head_view_border_color")?.cgColor
        imageView.layer.borderWidth = 5
        imageView.backgroundColor = .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickToLogin(sender: )))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
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
    lazy var myBalanceLabel : UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 520, width: (headLabelW), height: headLabelH))
        label.textColor = .white
        label.text = "余额"
        label.font = UIFont(name: "Arial", size: 15.0)
        label.textAlignment = .center
        return label
    }()
    //余额num
    lazy var myBalanceNum : UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 550, width: (headLabelW), height: headLabelH))
        label.textColor = .white
//        label.text = "10.00"
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 15.0)
        return label
    }()
    lazy var myMemberGroupLabel : UILabel = {
        let label = UILabel(frame: CGRect(x: finalScreenW / 3 + 10, y: 520, width: (headLabelW ), height: headLabelH))
        label.textColor = .white
        label.text = "我的会员组"
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 15.0)
        return label
    }()
    lazy var myMemberGroupDetail : UILabel = {
        let label = UILabel(frame: CGRect(x: finalScreenW / 3 + 10, y: 550, width: (headLabelW ), height: headLabelH))
        label.textColor = .white
//        label.text = ""
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 15.0)
        return label
    }()
    lazy var myScoreLabel : UILabel = {
        let label = UILabel(frame: CGRect(x: finalScreenW / 3 * 2 + 10, y: 520, width: (headLabelW), height: headLabelH))
        label.textColor = .white
        label.text = "我的会员积分"
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 15.0)
        return label
    }()
    //积分num
    lazy var myScoreNum : UILabel = {
        let label = UILabel(frame: CGRect(x: finalScreenW / 3 * 2 + 10, y: 550, width: (headLabelW), height: headLabelH))
        label.textColor = .white
//        label.text = "0.00"
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 15.0)
        return label
    }()
    lazy var testSwitchButton : UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.frame = CGRect(x: finalScreenW / 3 + 10, y: 490, width: (headLabelW ), height: headLabelH)
        button.setTitle("Test data", for: UIControlState.normal)
        button.addTarget(self, action: #selector(testButtonClicked), for: UIControlEvents.touchUpInside)
        return button
    }()
    private lazy var searchBar:UISearchBar = {
        //搜索栏
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: finalScreenW, height: 64))
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchBar.barStyle = UIBarStyle.black
        searchBar.autocapitalizationType = .words
        searchBar.delegate = self
        searchBar.placeholder = "请输入搜索内容"
        return searchBar
    }()
    private lazy var alphaView : UIControl = {
        //UISearchBar的蒙层
        let view = UIControl(frame: CGRect(x: 0, y: 0, width: finalScreenW, height: rootScrollViewH))
        view.backgroundColor = .black
        view.alpha = 0.3
        view.addTarget(self, action: #selector(dismissAlphaViewAndSearchBar), for: .touchUpInside)
        return view
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
        self.tabBarController?.tabBar.isHidden = false
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
        headImageView.image = UIImage(named: "loading")
        myIDLabel.text = "This is My ID"
        myBalanceNum.text = "111.00"
        myScoreNum.text = "0.00"
        myMemberGroupDetail.text = ""
    }
    private func setupHeadView(){
        headView.backgroundColor = UIColor.init(named: "global_orange")
        headView.addSubview(headImageView)
        headView.addSubview(myIDLabel)
        headView.addSubview(myBalanceLabel)
        headView.addSubview(myBalanceNum)
        headView.addSubview(myMemberGroupLabel)
        headView.addSubview(myMemberGroupDetail)
        headView.addSubview(myScoreLabel)
        headView.addSubview(myScoreNum)
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
        title.text = "个人中心"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBtn)
        if showSearchButton {
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        }
        //navigationItem.rightBarButtonItem = UIBarButtonItem.init(imageName: "home_top_search_right")
        navigationItem.title = "个人中心"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18)]
        //navigationItem.titleView = title
        navigationController?.navigationBar.barTintColor = UIColor.init(named: "global_orange")
        navigationController?.navigationBar.barStyle = UIBarStyle.default
        navigationController?.navigationBar.isTranslucent = false
    }
}
//MARK: - collection->dataSource, delegate
extension MyCenterViewController :UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyInfoCellID, for: indexPath) as! MyCenterCell
        cell.layer.borderColor = UIColor(named: "line_gray")?.cgColor
        cell.layer.borderWidth = 0.5
        cell.backgroundColor = .white
        for index in 1...17 {
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
            labelFA.font = UIFont.fontAwesome(ofSize: 50)
            labelFA.textColor = UIColor.random.lighten(by: 0.5)
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
            print("我的订单")
            let orderVC = MyOrdersViewController()
            self.navigationController?.show(orderVC, sender: self)
        case 1:
            print("我的积分")
            let scoreVC = MyScoreViewController()
            self.navigationController?.show(scoreVC, sender: self)
        case 2:
            print("我的代金券")
            let vouchersVC = MyVouchersViewController()
            self.navigationController?.show(vouchersVC, sender: self)
        case 3:
            print("退款申请")
            let refundVC = MyRefundApplicationViewController()
            self.navigationController?.show(refundVC, sender: self)
        case 4:
            print("站点建议")
            let suggestionVC = MySuggestionsViewController()
            self.navigationController?.show(suggestionVC, sender: self)
        case 5:
            print("商品咨询")
            let advisoryVC = MyAdvisoryViewController()
            self.navigationController?.show(advisoryVC, sender: self)
        case 6:
            print("商品评价")
            let evaluationVC = MyEvaluationViewController()
            self.navigationController?.show(evaluationVC, sender: self)
        case 7:
            print("短信息")
            let messageVC = MyMessageViewController()
            self.navigationController?.show(messageVC, sender: self)
        case 8:
            print("收藏夹")
            let collectionVC = MyCollectionViewController()
            self.navigationController?.show(collectionVC, sender: self)
        case 9:
            print("账户余额")
            let balanceVC = MyBalanceViewController()
            self.navigationController?.show(balanceVC, sender: self)
        case 10:
            print("在线充值")
            let rechargeVC = MyRechargeOnlineViewController()
            self.navigationController?.show(rechargeVC, sender: self)
        case 11:
            print("地址管理")
            let addressVC = MyAddressViewController()
            self.navigationController?.show(addressVC, sender: self)
        case 12:
            print("个人资料")
            let myInfoVC = MyInfoViewController()
            self.navigationController?.show(myInfoVC, sender: self)
        case 13:
            print("修改密码")
            let changePasswordVC = ChangePasswordViewController()
            self.navigationController?.show(changePasswordVC, sender: self)
        case 14:
            print("发票管理")
            let invoiceManage = MyInvoiceManageViewController()
            self.navigationController?.show(invoiceManage, sender: self)
        case 15:
            print("我的推介")
            let commendVc = MyCommendViewController()
            self.navigationController?.show(commendVc, sender: self)
        case 16:
            print("我的下线成员")
            let myMemberVC = MyMemberViewController()
            self.navigationController?.show(myMemberVC, sender: self)
        case 17:
            print("我的佣金")
            let commissionVC = MyCommissionViewController()
            self.navigationController?.show(commissionVC, sender: self)
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
    @objc func clickToLogin(sender: UITapGestureRecognizer){
        let loginVC = LoginViewController()
        self.navigationController?.show(loginVC, sender: self)
        print("login")
    }
}
//MARK: - 设置searchBar的Delegate
extension MyCenterViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        alphaView.removeFromSuperview()
        searchBtnClicked()
        searchContent = (searchBar.textField?.text)!
        print(searchContent)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.rootScrollView.addSubview(alphaView)
        return true
    }
}
//MARK: - NavigationBarIetm点击事件
extension MyCenterViewController {
    @objc private func searchBtnClicked(){
        if searchBarState == 1 {
            //隐藏
            searchBar.removeFromSuperview()
            alphaView.removeFromSuperview()
            searchBarState = 2
        }else if searchBarState == 2 {
            //显示
            view.addSubview(searchBar)
            searchBar.becomeFirstResponder()
            view.addSubview(alphaView)
            searchBarState = 1
        }
    }
    
    @objc func dismissAlphaViewAndSearchBar(){
        alphaView.removeFromSuperview()
        searchBar.resignFirstResponder()
        searchBtnClicked()
    }
}
