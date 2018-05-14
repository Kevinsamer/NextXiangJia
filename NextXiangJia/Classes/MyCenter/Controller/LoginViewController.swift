//
//  LoginViewController.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/4/28.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
private let textFieldW : CGFloat = finalScreenW / 10 * 9
private let textFieldH : CGFloat = 40
private let viewSpace :CGFloat = 20
private let buttonW: CGFloat = (finalScreenW - 80) / 3
private var usernameString = ""
private var passwordString = ""
class LoginViewController: UIViewController {
    //MARK: - 懒加载
    lazy var username: MyTextField = {
        let name = MyTextField(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100, width: textFieldW, height: textFieldH))
//        name.layer.borderColor = UIColor(named: "dark_gray")?.cgColor
//        name.layer.borderWidth = 1
        //name.textAlignment = NSTextAlignment.center
        name.placeholder = "请输入用户名"
        name.font = UIFont.systemFont(ofSize: 20)
        name.delegate = self
        name.layer.borderColor = UIColor.gray.lighten(by: 0.4).cgColor
        name.layer.borderWidth = 0.5
        //name.backgroundColor = UIColor.blue.lighten(by: 0.9)
        return name
    }()
    
    lazy var password: MyTextField = {
        let password = MyTextField(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH + viewSpace, width: textFieldW, height: textFieldH))
//        password.layer.borderColor = UIColor(named: "dark_gray")?.cgColor
//        password.layer.borderWidth = 1
        //password.textAlignment = NSTextAlignment.center
        password.placeholder = "请输入密码"
        password.font = UIFont.systemFont(ofSize: 20)
        password.delegate = self
        password.layer.borderColor = UIColor.gray.lighten(by: 0.4).cgColor
        password.layer.borderWidth = 0.5
        //password.backgroundColor = UIColor.blue.lighten(by: 0.9)
        return password
    }()
//    lazy var dividerLineUsername: UIView = {
//        let view = UIView(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH, width: textFieldW, height: 1))
//        view.backgroundColor = UIColor(named: "dark_gray")
//        return view
//    }()
//    lazy var dividerLinePassword: UIView = {
//        let view = UIView(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH * 2 + viewSpace, width: textFieldW, height: 1))
//        view.backgroundColor = UIColor(named: "dark_gray")
//        return view
//    }()
    lazy var loginButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.frame = CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH * 2 + viewSpace * 2, width: textFieldW, height: textFieldH)
        button.setTitleForAllStates("登录")
        button.titleLabel?.textAlignment = .center
        button.setTitleColorForAllStates(.white)
        button.backgroundColor = UIColor(named: "global_orange")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.addTarget(self, action: #selector(loginButtonClicked), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.frame = CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH * 3 + viewSpace * 3, width: finalScreenW / 5, height: textFieldH)
//        button.backgroundColor = .orange
//        button.setTitleColorForAllStates(.white)
        button.setTitleForAllStates("注册")
        button.setTitleColorForAllStates(UIColor(named: "dark_gray")!)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        button.addTarget(self, action: #selector(registerClicked), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var forgetPasswordButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.frame = CGRect(x: finalScreenW / 2 + (textFieldW / 2 - finalScreenW / 5), y: 100 + textFieldH * 3 + viewSpace * 3, width: finalScreenW / 5, height: textFieldH)
//        button.backgroundColor = .orange
//        button.setTitleColorForAllStates(.white)
        button.setTitleForAllStates("忘记密码")
        button.setTitleColorForAllStates(UIColor(named: "dark_gray")!)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        button.addTarget(self, action: #selector(forgetPasswordClicked), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var signInWithLabel: UILabel = {
        //第三方账号登录promptLabel
        let label = UILabel(frame: CGRect(x: finalScreenW / 2 - finalScreenW / 3 / 2, y: 100 + textFieldH * 4 + viewSpace * 4, width: finalScreenW / 3, height: textFieldH))
        label.text = "第三方账号登录"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "dark_gray")
        label.backgroundColor = .white
        return label
    }()
    //分隔线
    lazy var dividerLine: UIView = {
        let view = UIView(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH * 4 + viewSpace * 4 + 19.5, width: textFieldW, height: 1))
        view.backgroundColor = UIColor(named: "dark_gray")
        return view
    }()
    
    lazy var loginByQQ: UIButton = {
        let qq = UIButton(type: UIButtonType.custom)
        qq.frame = CGRect(x: 20, y: 100 + textFieldH * 5 + viewSpace * 5, width: buttonW, height: buttonW)
        //qq.setTitleForAllStates("QQ登录")
        qq.setImageForAllStates(UIImage(named: "ic_qq_70")!)
        qq.setButtonTitleImageStyle(padding: 5, style: TitleImageStyly.ButtonImageTitleStyleTop)
        qq.addTarget(self, action: #selector(loginByQQClicked), for: UIControlEvents.touchUpInside)
        return qq
    }()
    lazy var loginByWX: UIButton = {
        let wx = UIButton(type: UIButtonType.custom)
        wx.frame = CGRect(x: 40 + buttonW, y: 100 + textFieldH * 5 + viewSpace * 5, width: buttonW, height: buttonW)
        //wx.setTitleForAllStates("微信登录")
        wx.setImageForAllStates(UIImage(named: "ic_wx_70")!)
        wx.setButtonTitleImageStyle(padding: 5, style: TitleImageStyly.ButtonImageTitleStyleTop)
        wx.addTarget(self, action: #selector(loginByWXClicked), for: UIControlEvents.touchUpInside)
        return wx
    }()
    lazy var loginByWB: UIButton = {
        let wb = UIButton(type: UIButtonType.custom)
        wb.frame = CGRect(x: 60 + buttonW * 2, y: 100 + textFieldH * 5 + viewSpace * 5, width: buttonW, height: buttonW)
        //wb.setTitleForAllStates("微博登录")
        wb.setImageForAllStates(UIImage(named: "ic_sina_70")!)
        wb.setButtonTitleImageStyle(padding: 5, style: TitleImageStyly.ButtonImageTitleStyleTop)
        wb.addTarget(self, action: #selector(loginByWBClicked), for: UIControlEvents.touchUpInside)
        return wb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //1.setUI
        setUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for view in self.view.subviews {
            view.resignFirstResponder()
        }
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

//MARK: - setUI
extension LoginViewController{
    func setUI(){
        self.view.backgroundColor = .white
        //1.设置navigationBar tabBar
        YTools.setNavigationBarAndTabBar(navCT: self.navigationController!, tabbarCT: self.tabBarController!, titleName: "登录", navItem:self.navigationItem)
        //2.bodyContent
        setupBodyContent()
    }
    func setupBodyContent(){
        self.view.addSubview(username)
        self.view.addSubview(password)
        self.view.addSubview(loginButton)
        self.view.addSubview(registerButton)
        self.view.addSubview(forgetPasswordButton)
        self.view.addSubview(dividerLine)
        self.view.addSubview(signInWithLabel)
        self.view.addSubview(loginByQQ)
        self.view.addSubview(loginByWX)
        self.view.addSubview(loginByWB)
//        self.view.addSubview(dividerLinePassword)
//        self.view.addSubview(dividerLineUsername)
    }
    
}
//MARK: - UITextFieldDelegete
extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == username {
            print("username")
            username.resignFirstResponder()
            password.becomeFirstResponder()
        }else if textField == password {
            print("password")
            password.resignFirstResponder()
        }
        
        return true
    }
}
//MARK: - clickFunc
extension LoginViewController {
    @objc func registerClicked(){
        print("register")
        var vc = RegistViewController()
        self.navigationController?.show(vc, sender: self)
    }
    
    @objc func forgetPasswordClicked(){
        print("changePassword")
        var vc = FindPasswordViewController()
        self.navigationController?.show(vc, sender: self)
    }
    @objc func loginButtonClicked(){
        YTools.showMyToast(rootView: self.view, message: "登录成功")
        //self.navigationController?.popViewController(animated: true)
    }
    @objc func loginByQQClicked(){
        YTools.showMyToast(rootView: self.view, message: "QQ登录")
    }
    @objc func loginByWXClicked(){
        YTools.showMyToast(rootView: self.view, message: "WX登录")
    }
    @objc func loginByWBClicked(){
        YTools.showMyToast(rootView: self.view, message: "WB登录")
    }
    
}
