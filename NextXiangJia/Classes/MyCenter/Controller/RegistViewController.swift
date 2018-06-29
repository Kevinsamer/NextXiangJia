//
//  RegistViewController.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/5/4.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import Toast_Swift
private let textFieldW : CGFloat = finalScreenW / 10 * 9
private let textFieldH : CGFloat = 40
private let viewSpace :CGFloat = 20

class RegistViewController: UIViewController {
    //MARK: - 懒加载
    lazy var regUsername: MyTextField = {
        let old = MyTextField(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + finalStatusBarH + finalNavigationBarH, width: textFieldW, height: textFieldH))
        //        name.layer.borderColor = UIColor(named: "dark_gray")?.cgColor
        //        name.layer.borderWidth = 1
        //old.textAlignment = NSTextAlignment.center
        old.placeholder = "请输入用户名"
        old.font = UIFont.systemFont(ofSize: 20)
        old.delegate = self
        old.layer.borderColor = UIColor.gray.lighten(by: 0.4).cgColor
        old.layer.borderWidth = 0.5
        //old.backgroundColor = UIColor.blue.lighten(by: 0.9)
        return old
    }()
    
    lazy var regPassword: MyTextField = {
        let new = MyTextField(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH + viewSpace + finalStatusBarH + finalNavigationBarH, width: textFieldW, height: textFieldH))
        //        password.layer.borderColor = UIColor(named: "dark_gray")?.cgColor
        //        password.layer.borderWidth = 1
        //new.textAlignment = NSTextAlignment.center
        new.placeholder = "请输入密码"
        new.font = UIFont.systemFont(ofSize: 20)
        new.delegate = self
        new.layer.borderColor = UIColor.gray.lighten(by: 0.4).cgColor
        new.layer.borderWidth = 0.5
        //new.backgroundColor = UIColor.blue.lighten(by: 0.9)
        return new
    }()
    lazy var regPasswordAgain: MyTextField = {
        let newAgain = MyTextField(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH * 2 + viewSpace * 2 + finalStatusBarH + finalNavigationBarH, width: textFieldW, height: textFieldH))
        //        password.layer.borderColor = UIColor(named: "dark_gray")?.cgColor
        //        password.layer.borderWidth = 1
        //newAgain.textAlignment = NSTextAlignment.center
        newAgain.placeholder = "请再次输入新密码"
        newAgain.font = UIFont.systemFont(ofSize: 20)
        newAgain.delegate = self
        newAgain.layer.borderColor = UIColor.gray.lighten(by: 0.4).cgColor
        newAgain.layer.borderWidth = 0.5
        //newAgain.backgroundColor = UIColor.blue.lighten(by: 0.9)
        return newAgain
    }()
    lazy var authCodeInput: MyTextField = {
        let authCode = MyTextField(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH * 3 + viewSpace * 3 + finalStatusBarH + finalNavigationBarH, width: textFieldW * 2 / 5, height: textFieldH))
        //        password.layer.borderColor = UIColor(named: "dark_gray")?.cgColor
        //        password.layer.borderWidth = 1
        //authCode.textAlignment = NSTextAlignment.center
        authCode.placeholder = "请输入验证码"
        authCode.font = UIFont.systemFont(ofSize: 20)
        authCode.delegate = self
        authCode.layer.borderColor = UIColor.gray.lighten(by: 0.4).cgColor
        authCode.layer.borderWidth = 0.5
        //authCode.backgroundColor = UIColor.blue.lighten(by: 0.9)
        return authCode
    }()
    
    lazy var authCodePic: AuthCodeView = {
        let viewFrame = CGRect(x: finalScreenW / 2 - textFieldW / 10 + viewSpace, y: 100 + textFieldH * 3 + viewSpace * 3 + finalStatusBarH + finalNavigationBarH, width: textFieldW * 3 / 5 - viewSpace, height: textFieldH)
        let auth = AuthCodeView(frame: viewFrame, with: IdentifyingCodeType.defaultType)
        auth.kCharCount = 5
        auth.kLineCount = 9
        auth.isRotation = true
        return auth
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.frame = CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH * 4 + viewSpace * 4 + finalStatusBarH + finalNavigationBarH, width: textFieldW, height: textFieldH)
        button.setTitleForAllStates("立即注册")
        button.titleLabel?.textAlignment = .center
        button.setTitleColorForAllStates(.white)
        button.backgroundColor = UIColor(named: "global_orange")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.addTarget(self, action: #selector(registerButtonClicked), for: UIControlEvents.touchUpInside)
        return button
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
extension RegistViewController{
    func setUI(){
        self.view.backgroundColor = .white
        //1.设置navigationBar tabBar
        YTools.setNavigationBarAndTabBar(navCT: self.navigationController!, tabbarCT: self.tabBarController!, titleName: "用户注册", navItem:self.navigationItem)
        //2.bodyContent
        setupBodyContent()
        
    }
    func setupBodyContent(){
        self.view.addSubview(regUsername)
        self.view.addSubview(regPassword)
        self.view.addSubview(regPasswordAgain)
        self.view.addSubview(authCodeInput)
        self.view.addSubview(authCodePic)
        self.view.addSubview(registerButton)
        
    }
}

//MARK: - textFieldDelegete
extension RegistViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == regUsername {
            print("username")
            regUsername.resignFirstResponder()
            regPassword.becomeFirstResponder()
        }else if textField == regPassword {
            print("password")
            regPassword.resignFirstResponder()
            regPasswordAgain.becomeFirstResponder()
        }else if textField == regPasswordAgain {
            print("passwordAgain")
            regPasswordAgain.resignFirstResponder()
            authCodeInput.becomeFirstResponder()
        }else if textField == authCodeInput {
            print("authCode")
            authCodeInput.resignFirstResponder()
        }
        
        return true
    }
}

//MARK: - clickFunc
extension RegistViewController {
    @objc func registerButtonClicked(){
        YTools.showMyToast(rootView: self.view, message: "注册成功\(authCodePic.defaultString)")
        //self.navigationController?.popViewController(animated: true)
    }
}
