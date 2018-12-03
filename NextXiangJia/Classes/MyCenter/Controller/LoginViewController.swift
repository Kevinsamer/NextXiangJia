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
    private let myCenterViewModel:MycenterViewModel = MycenterViewModel()
    private var loginErrorInfo:String?{
        didSet{
            if loginErrorInfo != nil && AppDelegate.appUser?.id == -1{
                YTools.showMyToast(rootView: self.view, message: loginErrorInfo ?? "系统错误")
            }
        }
    }
    var userMember:UserMemberModel?{
        didSet{
            if let user = userMember {
                AppDelegate.appUser?.id = Int32(user.id)
                AppDelegate.appUser?.username = user.username
                AppDelegate.appUser?.password = user.password
                AppDelegate.appUser?.head_ico = user.head_ico
                AppDelegate.appUser?.user_id = Int32(user.user_id)
                AppDelegate.appUser?.true_name = user.true_name
                AppDelegate.appUser?.telephone = user.telephone
                AppDelegate.appUser?.mobile = user.mobile
                AppDelegate.appUser?.area = user.area
                AppDelegate.appUser?.contact_addr = user.contact_addr
                AppDelegate.appUser?.qq = user.qq
                AppDelegate.appUser?.sex = Int32(user.sex)
                AppDelegate.appUser?.birthday = user.birthday
                AppDelegate.appUser?.group_id = Int32(user.group_id)
                AppDelegate.appUser?.exp = Int32(user.exp)
                AppDelegate.appUser?.point = Int32(user.point)
                AppDelegate.appUser?.message_ids = user.message_ids
                AppDelegate.appUser?.time = user.time
                AppDelegate.appUser?.zip = user.zip
                AppDelegate.appUser?.status = Int32(user.status)
                AppDelegate.appUser?.prop = user.prop
                AppDelegate.appUser?.balance = user.balance
                AppDelegate.appUser?.last_login = user.last_login
                AppDelegate.appUser?.custom = user.custom
                AppDelegate.appUser?.email = user.email
                AppDelegate.appUser?.local_pd = user.local_pd
                AppUserCoreDataHelper.AppUserHelper.modifyAppUser(appUser: AppDelegate.appUser!)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    //MARK: - 懒加载
    lazy var username: MyTextField = {
        let name = MyTextField(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + finalStatusBarH + finalNavigationBarH, width: textFieldW, height: textFieldH))
//        name.layer.borderColor = UIColor(named: "dark_gray")?.cgColor
//        name.layer.borderWidth = 1
        //name.textAlignment = NSTextAlignment.center
        name.placeholder = "请输入用户名"
        name.font = UIFont.systemFont(ofSize: 20)
        name.delegate = self
        name.layer.borderColor = UIColor.gray.lighten(by: 0.4).cgColor
        name.layer.borderWidth = 0.5
        name.clearButtonMode = UITextFieldViewMode.always
        //name.backgroundColor = UIColor.blue.lighten(by: 0.9)
        return name
    }()
    
    lazy var password: MyTextField = {
        let password = MyTextField(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH + viewSpace + finalStatusBarH + finalNavigationBarH, width: textFieldW, height: textFieldH))
//        password.layer.borderColor = UIColor(named: "dark_gray")?.cgColor
//        password.layer.borderWidth = 1
        //password.textAlignment = NSTextAlignment.center
        password.placeholder = "请输入密码"
        password.font = UIFont.systemFont(ofSize: 20)
        password.delegate = self
        password.layer.borderColor = UIColor.gray.lighten(by: 0.4).cgColor
        password.layer.borderWidth = 0.5
        //password.backgroundColor = UIColor.blue.lighten(by: 0.9)
        password.clearButtonMode = UITextFieldViewMode.always
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
        button.frame = CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH * 2 + viewSpace * 2 + finalStatusBarH + finalNavigationBarH, width: textFieldW, height: textFieldH)
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
        button.frame = CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH * 3 + viewSpace * 3 + finalStatusBarH + finalNavigationBarH, width: finalScreenW / 5, height: textFieldH)
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
        button.frame = CGRect(x: finalScreenW / 2 + (textFieldW / 2 - finalScreenW / 5), y: 100 + textFieldH * 3 + viewSpace * 3 + finalStatusBarH + finalNavigationBarH, width: finalScreenW / 5, height: textFieldH)
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
        let label = UILabel(frame: CGRect(x: finalScreenW / 2 - finalScreenW / 3 / 2, y: 100 + textFieldH * 4 + viewSpace * 4 + finalStatusBarH + finalNavigationBarH, width: finalScreenW / 3, height: textFieldH))
        label.text = "第三方账号登录"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "dark_gray")
        label.backgroundColor = .white
        return label
    }()
    //分隔线
    lazy var dividerLine: UIView = {
        let view = UIView(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH * 4 + viewSpace * 4 + 19.5 + finalStatusBarH + finalNavigationBarH, width: textFieldW, height: 1))
        view.backgroundColor = UIColor(named: "dark_gray")
        return view
    }()
    
    lazy var loginByQQ: UIButton = {
        let qq = UIButton(type: UIButtonType.custom)
        qq.frame = CGRect(x: 20, y: 100 + textFieldH * 5 + viewSpace * 5 + finalStatusBarH + finalNavigationBarH, width: buttonW, height: buttonW)
        //qq.setTitleForAllStates("QQ登录")
        qq.setImageForAllStates(UIImage(named: "ic_qq_70")!)
        qq.setButtonTitleImageStyle(padding: 5, style: TitleImageStyly.ButtonImageTitleStyleTop)
        qq.addTarget(self, action: #selector(loginByQQClicked), for: UIControlEvents.touchUpInside)
        return qq
    }()
    lazy var loginByWX: UIButton = {
        let wx = UIButton(type: UIButtonType.custom)
        wx.frame = CGRect(x: 40 + buttonW, y: 100 + textFieldH * 5 + viewSpace * 5 + finalStatusBarH + finalNavigationBarH, width: buttonW, height: buttonW)
        //wx.setTitleForAllStates("微信登录")
        wx.setImageForAllStates(UIImage(named: "ic_wx_70")!)
        wx.setButtonTitleImageStyle(padding: 5, style: TitleImageStyly.ButtonImageTitleStyleTop)
        wx.addTarget(self, action: #selector(loginByWXClicked), for: UIControlEvents.touchUpInside)
        return wx
    }()
    lazy var loginByWB: UIButton = {
        let wb = UIButton(type: UIButtonType.custom)
        wb.frame = CGRect(x: 60 + buttonW * 2, y: 100 + textFieldH * 5 + viewSpace * 5 + finalStatusBarH + finalNavigationBarH, width: buttonW, height: buttonW)
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
        let vc = RegistViewController()
        vc.sendData = self
        self.navigationController?.show(vc, sender: self)
    }
    
    @objc func forgetPasswordClicked(){
        print("changePassword")
        let vc = FindPasswordViewController()
        self.navigationController?.show(vc, sender: self)
    }
    @objc func loginButtonClicked(){
        //1.输入框验证
        if let usernameText = self.username.text {
            if let passwordText = self.password.text {
                let matcher = MyRegex(usernameRegex)
                if matcher.match(input: usernameText){
                    //匹配成功
                    if passwordText.count >= 6 && passwordText.count <= 32{
                        //密码正确
                        myCenterViewModel.requestLoginData(username: usernameText, password: passwordText) {
                            self.userMember = self.myCenterViewModel.userMember
                            self.loginErrorInfo = self.myCenterViewModel.errorInfo
                        }
                    }else {
                        YTools.showMyToast(rootView: self.view, message: "密码长度为6-32个字符")
                    }
                }else{
                    YTools.showMyToast(rootView: self.view, message: "用户名长度不能少于2个字符，可以为字母、数字、下划线、中文")
                }
            }else {
                YTools.showMyToast(rootView: self.view, message: "请填写密码")
            }
        }else {
            YTools.showMyToast(rootView: self.view, message: "请填写用户名/邮箱/手机号")
        }
        
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

extension LoginViewController:SendDataProtocol {
    func SendData(data: Any?) {
        if let username = data {
            self.username.text = username as? String
        }
    }
    
    
}
