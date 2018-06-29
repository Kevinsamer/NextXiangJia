//
//  FindPasswordTabViewController.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/5/10.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import XLPagerTabStrip
public let typePhone = "typePhone"
public let typeMail = "typeMail"
private let textFieldW : CGFloat = finalScreenW / 10 * 9
private let textFieldH : CGFloat = 40
private let viewSpace :CGFloat = 20
private let buttonW: CGFloat = (finalScreenW - 80) / 3
private var usernameString = ""
private var mailString = ""
private var phoneString = ""
class FindPasswordTabViewController: UIViewController, IndicatorInfoProvider {
    //MARK: - 懒加载
    lazy var username: MyTextField = {
        let name = MyTextField(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 60 + finalStatusBarH + finalNavigationBarH, width: textFieldW, height: textFieldH))
        //        name.layer.borderColor = UIColor(named: "dark_gray")?.cgColor
        //        name.layer.borderWidth = 1
        //name.textAlignment = NSTextAlignment.center
        name.placeholder = "请输入用户名"
        name.font = UIFont.systemFont(ofSize: 20)
        name.delegate = self
        name.layer.borderColor = UIColor.gray.lighten(by: 0.4).cgColor
        name.layer.borderWidth = 0.5
        //name.backgroundColor = UIColor.random.lighten(by: 0.9)
        return name
    }()
    
    lazy var mail: MyTextField = {
        let mail = MyTextField(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 60 + textFieldH + viewSpace + finalStatusBarH + finalNavigationBarH, width: textFieldW, height: textFieldH))
        //        password.layer.borderColor = UIColor(named: "dark_gray")?.cgColor
        //        password.layer.borderWidth = 1
        //mail.textAlignment = NSTextAlignment.center
        mail.placeholder = "请输入邮箱"
        mail.font = UIFont.systemFont(ofSize: 20)
        mail.delegate = self
        mail.layer.borderColor = UIColor.gray.lighten(by: 0.4).cgColor
        mail.layer.borderWidth = 0.5
        //mail.backgroundColor = UIColor.random.lighten(by: 0.9)
        return mail
    }()
    
    lazy var phone: MyTextField = {
        let phone = MyTextField(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 60 + textFieldH + viewSpace + finalStatusBarH + finalNavigationBarH, width: textFieldW, height: textFieldH))
        //        password.layer.borderColor = UIColor(named: "dark_gray")?.cgColor
        //        password.layer.borderWidth = 1
        //phone.textAlignment = NSTextAlignment.center
        phone.placeholder = "请输入手机号"
        phone.font = UIFont.systemFont(ofSize: 20)
        phone.delegate = self
        phone.layer.borderColor = UIColor.gray.lighten(by: 0.4).cgColor
        phone.layer.borderWidth = 0.5
        //phone.backgroundColor = UIColor.random.lighten(by: 0.9)
        return phone
    }()
    
    lazy var authCode: MyTextField = {
        let authCode = MyTextField(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 60 + textFieldH * 2 + viewSpace * 2 + finalStatusBarH + finalNavigationBarH, width: textFieldW / 2 - 10, height: textFieldH))
        //        password.layer.borderColor = UIColor(named: "dark_gray")?.cgColor
        //        password.layer.borderWidth = 1
        //authCode.textAlignment = NSTextAlignment.center
        authCode.placeholder = "手机验证码"
        authCode.font = UIFont.systemFont(ofSize: 20)
        authCode.delegate = self
        authCode.layer.borderColor = UIColor.gray.lighten(by: 0.4).cgColor
        authCode.layer.borderWidth = 0.5
        //authCode.backgroundColor = UIColor.random.lighten(by: 0.95)
        return authCode
    }()
    
    lazy var sendAuthCode: UIButton = {
        let authCode = UIButton(type: UIButtonType.custom)
        authCode.frame = CGRect(x: finalScreenW / 2 + 10, y: 60 + textFieldH * 2 + viewSpace * 2 + finalStatusBarH + finalNavigationBarH, width: textFieldW / 2 - 10, height: textFieldH)
        //        password.layer.borderColor = UIColor(named: "dark_gray")?.cgColor
        //        password.layer.borderWidth = 1
        authCode.titleLabel?.textAlignment = NSTextAlignment.center
        authCode.setTitleForAllStates("发送手机验证码")
        authCode.layer.borderColor = UIColor.gray.lighten(by: 0.4).cgColor
        authCode.layer.borderWidth = 0.5
        authCode.backgroundColor = UIColor(named: "line_gray")
        authCode.setTitleColor(.black, for: .normal)
        authCode.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        authCode.addTarget(self, action: #selector(sendAuthCodeClicked), for: UIControlEvents.touchUpInside)
        return authCode
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
    lazy var findButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.frame = CGRect(x: finalScreenW / 2 - textFieldW / 2, y: self.type == typePhone ? 60 + textFieldH * 3 + viewSpace * 3 + finalStatusBarH + finalNavigationBarH: 60 + textFieldH * 2 + viewSpace * 2 + finalStatusBarH + finalNavigationBarH, width: textFieldW, height: textFieldH)
        button.setTitleForAllStates("找回密码")
        button.titleLabel?.textAlignment = .center
        button.setTitleColorForAllStates(.white)
        button.backgroundColor = UIColor(named: "global_orange")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.addTarget(self, action: #selector(findButtonClicked), for: UIControlEvents.touchUpInside)
        return button
    }()
    init(itemInfo: IndicatorInfo,type: String) {
        self.itemInfo = itemInfo
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var itemInfo: IndicatorInfo = "View"
    var type: String?
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view.
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

extension FindPasswordTabViewController{
    private func setUI(){
        self.view.removeSubviews()
        if self.type == typePhone {
            findByPhone()
        }else if self.type == typeMail{
            findByMail()
        }
    }
    private func findByPhone(){
        self.view.addSubview(username)
        self.view.addSubview(phone)
        self.view.addSubview(authCode)
        self.view.addSubview(sendAuthCode)
        self.view.addSubview(findButton)
    }
    private func findByMail(){
        self.view.addSubview(username)
        self.view.addSubview(mail)
        self.view.addSubview(findButton)
    }
}

extension FindPasswordTabViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if type == typeMail {
            if textField == username {
                print("username")
                username.resignFirstResponder()
                mail.becomeFirstResponder()
            }else if textField == mail {
                print("mail")
                mail.resignFirstResponder()
            }
        }else if type == typePhone {
            if textField == username {
                print("username")
                username.resignFirstResponder()
                phone.becomeFirstResponder()
            }else if textField == phone {
                print("phone")
                phone.resignFirstResponder()
            }else if textField == authCode {
                textField.resignFirstResponder()
            }
        }
        
        return true
    }
}
//MARK: - clicked
extension FindPasswordTabViewController{
    @objc func findButtonClicked(){
        YTools.showMyToast(rootView: self.view, message: "找回密码")
        //self.navigationController?.popViewController(animated: true)
    }
    @objc func sendAuthCodeClicked(){
        YTools.showMyToast(rootView: self.view, message: "发送手机验证码")
        authCode.becomeFirstResponder()
    }
}
