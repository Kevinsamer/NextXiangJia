//
//  MyBalanceViewController.swift
//  NextXiangJia
//  账户余额
//  Created by DEV2018 on 2018/4/27.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
private let topViewH:CGFloat = 120
private let bottomButtonH:CGFloat = 55
class MyBalanceViewController: UIViewController {
    var balance:Double?
    //MARK: - 懒加载
    lazy var topView: UIView = {
        //顶部蓝色
        let view = UIView(frame: CGRect(x: 0, y: finalNavigationBarH + finalStatusBarH, width: finalScreenW, height: topViewH))
        view.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.7568627451, blue: 0.8470588235, alpha: 1)
        return view
    }()
    
    lazy var balanceLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 30, width: finalScreenW, height: topViewH - 60))
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 40)
        label.adjustsFontSizeToFitWidth = true
        label.text = "￥\(balance ?? 0.00)"
        return label
    }()
    
    lazy var centerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: finalStatusBarH + finalNavigationBarH + topViewH, width: finalScreenW, height: UIDevice.current.isX() ? finalScreenH - finalNavigationBarH - finalStatusBarH - bottomButtonH - topViewH - IphonexHomeIndicatorH : finalScreenH - finalNavigationBarH - finalStatusBarH - bottomButtonH - topViewH))
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    
    lazy var noDataLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 80, width: finalScreenW, height: 50))
        label.text = "暂时没有账户变动记录"
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.5960784314, green: 0.5960784314, blue: 0.5960784314, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()
    
    lazy var buttomButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.frame = CGRect(x: 0, y: UIDevice.current.isX() ? finalScreenH - IphonexHomeIndicatorH - bottomButtonH : finalScreenH - bottomButtonH, width: finalScreenW, height: bottomButtonH)
        button.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.2431372549, blue: 0.4745098039, alpha: 1)
        button.setTitleForAllStates("申请提现")
        button.setTitleColorForAllStates(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.addTarget(self, action: #selector(buttonClicked), for: UIControlEvents.touchUpInside)
        return button
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
extension MyBalanceViewController {
    private func setUI(){
        //0.初始化数据
        initData()
        //1.设置navagationBar
        navigationItem.title = "账户余额"
        //2.设置bodyContent
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        //3.设置顶部view
        setupTopView()
        //4.设置中间view
        setupCenterView()
        //5.设置底部view
        setupBottomButton()
        
//        YTools.myPrint(content: "\(finalStatusBarH)", mode: testMode)
    }
    
    private func initData(){
        balance = 0.00
    }
    
    private func setupBottomButton(){
        self.view.addSubview(buttomButton)
    }
    
    private func setupCenterView(){
        centerView.addSubview(noDataLabel)
        self.view.addSubview(centerView)
    }
    
    private func setupTopView(){
        topView.addSubview(balanceLabel)
        self.view.addSubview(topView)
    }

}
//MARK: - 事件绑定
extension MyBalanceViewController {
    @objc private func buttonClicked(){
        let vc = TiXianViewController()
        self.navigationController?.show(vc, sender: self)
    }
}
