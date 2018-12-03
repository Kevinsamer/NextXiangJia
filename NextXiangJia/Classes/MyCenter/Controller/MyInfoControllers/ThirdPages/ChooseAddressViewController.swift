//
//  ChooseAddressViewController.swift
//  NextXiangJia
//  ChooseAddressViewController选择地址
//  Created by DEV2018 on 2018/11/2.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import PullToRefreshKit
private let addressCellID = "addressCellID"
private var addressNums = 0
private let newAddressButtonH:CGFloat = 40
class ChooseAddressViewController: UIViewController {
    var sendDataProtocol:SendDataProtocol?
    var myCenterViewModel:MycenterViewModel = MycenterViewModel()
    var currentIndex:Int = -1//当前要操作的cell的indexPath.row
    var userAddressModel:[MyAddressModel]?{
        didSet{
            //打印当前账号所有地址的id
            //            for address in userAddressModel! {
            //                print(address.province)
            //            }
            if userAddressModel?.count == 0{
                self.addressCollectionView.addSubview(noAddressButton)
            }else{
                self.noAddressButton.removeFromSuperview()
            }
            self.addressCollectionView.reloadData {
                self.addressCollectionView.switchRefreshHeader(to: .normal(.success, 0.5))
            }
        }
    }
    //MARK: - 懒加载
    lazy var delAlert: UIAlertController = {
        let alert = UIAlertController(style: UIAlertControllerStyle.alert)
        alert.title = "是否删除"
        let okAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.default, handler: {[unowned self] (action) in
            //确认删除
            if self.currentIndex != -1 {
                self.myCenterViewModel.requestDelUserAddress(id: self.userAddressModel![self.currentIndex].id) {[unowned self] in
                    self.initDatas()
                }
            }
        })
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        return alert
    }()
    lazy var noAddressButton: UIButton = {
        let imageB = UIButton(type: UIButtonType.custom)
        imageB.frame.size = CGSize(width: finalScreenW, height: finalScreenW-30)
        imageB.center = CGPoint(x: self.addressCollectionView.centerX, y: self.addressCollectionView.centerY/2)
        //        imageB.frame = CGRect(origin: self.addressCollectionView.center, size: CGSize(width: finalScreenW /  2, height: finalScreenW / 2))
        imageB.setTitleForAllStates("您还没有收货地址哦！")
        imageB.setTitleColorForAllStates(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        imageB.setImageForAllStates(UIImage(named: "no_address")!)
        imageB.imageView?.size = CGSize(width: 110, height: 110)
        imageB.setButtonTitleImageStyle(padding: 10, style: TitleImageStyly.ButtonImageTitleStyleTop)
        //imageB.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        return imageB
    }()
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
    lazy var newAddressButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.frame = CGRect(x: 20, y: finalStatusBarH + YTools.getCurrentNavigationBarHeight(navCT: self.navigationController!) + finalContentViewNoTabbarH - newAddressButtonH, width: finalScreenW - 40, height: newAddressButtonH)
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
        layout.itemSize = CGSize(width: finalScreenW, height: 150)
        layout.minimumLineSpacing = 0
        //coll的高度为导航栏以下新建按钮以上
        let coll = UICollectionView(frame: CGRect.init(x: 0, y: YTools.getCurrentNavigationBarHeight(navCT: self.navigationController!) + finalStatusBarH, width: finalScreenW, height: finalContentViewNoTabbarH - newAddressButtonH), collectionViewLayout: layout)
        coll.backgroundColor = UIColor(named: "line_gray")
        coll.isScrollEnabled = true
        coll.dataSource  = self
        coll.delegate = self
        coll.contentInsetAdjustmentBehavior = .never
        coll.alwaysBounceVertical = true
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initDatas()
    }
    
}
//MARK: - 设置ui
extension ChooseAddressViewController {
    private func setUI(){
        //1.设置navigationBar
        navigationItem.title = "收货地址管理"
        //2.初始化数据
        initDatas()
        //3.设置bodyContent
        setupBodyContent()
    }
    private func initDatas(){
        if let userID = AppDelegate.appUser?.user_id{
            myCenterViewModel.requestUserAddress(id: Int(userID)) {
                self.userAddressModel = self.myCenterViewModel.userAddressInfo
            }
        }
        
    }
    private func setupBodyContent(){
        //        let label = UILabel(frame: CGRect(x: finalScreenW / 2 - 50, y: finalScreenH / 2 - 20, width: 100, height: 40))
        //        label.textAlignment = .center
        //        label.text = "MyAddressPage"
        //        self.view.addSubview(label)
        self.view.backgroundColor = UIColor(named: "line_gray")
        //1.设置collectionView
        setupAddressCollection()
        //2.设置添加地址button
        setupNewAddressButton()
    }
    private func setupAddressCollection(){
        self.view.addSubview(addressCollectionView)
        addressCollectionView.configRefreshHeader(with: header, container: self) {
            [unowned self] in
            self.initDatas()
        }
    }
    private func setupNewAddressButton(){
        self.view.addSubview(newAddressButton)
    }
}

extension ChooseAddressViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userAddressModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: addressCellID, for: indexPath) as! AddressCell
        cell.addressLabel.text = "\(self.userAddressModel![indexPath.row].province)\(self.userAddressModel![indexPath.row].city)\(self.userAddressModel![indexPath.row].area)  \(self.userAddressModel![indexPath.row].address)"
        cell.nameLabel.text = "\(self.userAddressModel![indexPath.row].accept_name)"
        cell.phoneLabel.text = "\(self.userAddressModel![indexPath.row].mobile)"
        cell.addressSelectButton.isSelected = self.userAddressModel![indexPath.row].is_default == 1 ? true : false
        //使用button的tag标记当前要操作的地址数组下表
        cell.delAddressButton.tag = indexPath.row
        cell.editAddressButton.tag = indexPath.row
        cell.addressSelectButton.tag = indexPath.row
        cell.delAddressButton.addTarget(self, action: #selector(delAddress(_:)), for: .touchUpInside)
        cell.editAddressButton.addTarget(self, action: #selector(editAddress(_:)), for: .touchUpInside)
        cell.addressSelectButton.addTarget(self, action: #selector(setAddressDefault(_:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //点击后回调数据
        //print(self.userAddressModel![indexPath.row].province)
        self.sendDataProtocol?.SendData(data: self.userAddressModel![indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
//MARK: - 点击事件
extension ChooseAddressViewController {
    @objc func delAddress(_ button:UIButton){
        currentIndex = button.tag
        
        delAlert.show()
        
        
    }
    @objc func editAddress(_ button:UIButton){
        let vc = EditAddressController()
        let address = self.userAddressModel![button.tag]
        vc.addressID = address.id
        vc.currentAddress = (address.province,address.city,address.area)
        vc.telNum = address.telphone
        vc.phoneNum = address.mobile
        vc.zipCode = address.zip
        vc.detailedAddress = address.address
        vc.name = address.accept_name
        self.navigationController?.show(vc, sender: self)
    }
    @objc func setAddressDefault(_ button:UIButton){
        self.myCenterViewModel.requestDefaultUserAddress(id: self.userAddressModel![button.tag].id, is_default:.yes) {[unowned self] in
            self.initDatas()
        }
    }
    
    @objc func addNewAddress(){
        //TODO HERE
        let vc = AddNewAddressViewController()
        self.navigationController?.show(vc, sender: self)
    }
}

