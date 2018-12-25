//
//  MyInfoViewController.swift
//  NextXiangJia
//  个人资料
//  Created by DEV2018 on 2018/4/27.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import Eureka
import ImageRow
import Kingfisher
class MyInfoViewController: FormViewController {
    private var qq:Int?
    private var myCenterViewModel:MycenterViewModel = MycenterViewModel()
    //MARK: - 懒加载
    lazy var loginOutAlert: UIAlertController = {
        let alert = UIAlertController(style: UIAlertControllerStyle.alert, source: nil, title: nil, message: "是否退出登录？", tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action) in
            
        })
        
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.destructive, handler: { (action) in
            if AppDelegate.appUser?.id != -1 {
                //App退出登录
                AppUserCoreDataHelper.AppUserHelper.delAppUser {
                    //self.navigationController?.popViewController(animated: true)
                    //self.navigationController?.popViewController(animated: true)?.tabBarController?.selectedIndex = 0
                    self.tabBarController?.selectedIndex = 0
                    self.navigationController?.popToRootViewController(animated: true)
                }
                //发出退出登录的http请求
                self.myCenterViewModel.requestLoginOut()
                
            }
        })
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        return alert
    }()
    
    lazy var disGroup: DispatchGroup = {
        let group = DispatchGroup()
        return group
    }()
    
    lazy var mQueue: DispatchQueue = {
        let queue = DispatchQueue.init(label: "initData")
        return queue
    }()
    
    lazy var alphaView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: finalScreenW, height: 44 * 9))
        view.isUserInteractionEnabled = false
        view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        return view
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
extension MyInfoViewController {
    private func setUI(){
        //1.设置navigationBar
        navigationItem.title = "个人资料"
        //0.初始化数据
        disGroup.enter()
        mQueue.async(group: disGroup, qos: .default, flags: []) {
            self.initData()
        }
        
        
        //2.设置bodyContent
        disGroup.notify(queue: mQueue) {
            DispatchQueue.main.async {
                self.setupBodyContent()
            }
            
        }
        
    }
    
    private func initData(){
        myCenterViewModel.requestMyInfo { (userMember) in
            AppDelegate.appUser?.true_name = userMember.true_name
            AppDelegate.appUser?.sex = Int32(userMember.sex)
            AppDelegate.appUser?.birthday = userMember.birthday
            AppDelegate.appUser?.mobile = userMember.mobile
            AppDelegate.appUser?.telephone = userMember.telephone
            AppDelegate.appUser?.zip = userMember.zip
            AppDelegate.appUser?.qq = userMember.qq
            AppDelegate.appUser?.email = userMember.email
            AppUserCoreDataHelper.AppUserHelper.modifyAppUser(appUser: AppDelegate.appUser!)
            self.disGroup.leave()
        }
    }

    private func setupBodyContent(){
        
        
        
        form +++ Section()
            
        <<< ImageRow("icon") { row in
            row.title = "头像"
            //row.imageURL = URL.init(string: BASE_URL + (AppDelegate.appUser?.head_ico ?? "/views/iwebmall/skin/default/images/front/user_ico.gif"))
            //row.placeholderImage = UIImage(named: "my_head")!
            row.sourceTypes = [.PhotoLibrary, .Camera]
            row.clearAction =  .no
            
            row.cell.accessoryView?.layer.cornerRadius = 20
            row.cell.accessoryView?.frame = CGRect(x: finalScreenW - 40, y: 0, width: 40, height: 40)
            (row.cell.accessoryView as! UIImageView).kf.setImage(with: URL.init(string: BASE_URL + (AppDelegate.appUser?.head_ico ?? "/views/iwebmall/skin/default/images/front/user_ico.gif")), placeholder: UIImage(named: "user_ico"))
            }.cellSetup { cell, row in
                
                //cell.imageView?.kf.setImage(with: URL.init(string: BASE_URL + ("/views/iwebmall/skin/default/images/front/user_ico.gif")), placeholder: UIImage(named: "my_head"))
            }.cellUpdate({ (cell, row) in
                //cell.addSubview(self.alphaView)
                if row.value == nil {
                    (row.cell.accessoryView as! UIImageView).kf.setImage(with: URL.init(string: BASE_URL + (AppDelegate.appUser?.head_ico ?? "/views/iwebmall/skin/default/images/front/user_ico.gif")), placeholder: UIImage(named: "user_ico"))
                }
            })
        <<< TextRow("username"){ row in
            
            row.title = "姓名"
            //row.tag = "username"
            row.placeholder = "请输入姓名"
            row.value = AppDelegate.appUser?.true_name
            row.add(rule: RuleRequired())
            }.cellUpdate({ (cell, row) in
                if !row.isValid{
                    cell.titleLabel?.textColor = .red
                    row.placeholder = "用户名不能为空"
                }
            })
        <<< PickerInputRow<String>("sex"){
            $0.title = "性别"
            $0.options = ["男","女"]
            $0.value = AppDelegate.appUser?.sex == 1 ? $0.options.first : $0.options.last
            //$0.add(rule: RuleRequired())
            //$0.tag = "sex"
        }
        <<< DateRow("birthday"){
            $0.title = "生日"
            $0.cell.datePicker.locale = Locale.init(identifier: "zh_CN")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 0)
            dateFormatter.locale = .current
            $0.dateFormatter = dateFormatter
            $0.value = dateFormatter.date(from: (AppDelegate.appUser?.birthday)!)
            //$0.tag = "date"
            
            }.cellUpdate({ (cell, row) in
                
            })
        <<< PhoneRow("phone"){
            $0.title = "手机"
            $0.placeholder = "请输入手机号"
            $0.add(rule: RuleRequired())
            $0.value = AppDelegate.appUser?.mobile
            //$0.tag = "phone"
            }.cellUpdate({ (cell, row) in
                if !row.isValid{
                    cell.titleLabel?.textColor = .red
                    row.placeholder = "手机号不能为空"
                }
            })
        <<< PhoneRow("tel"){
            $0.title = "电话"
            $0.placeholder = "请输入电话号码"
            $0.value = AppDelegate.appUser?.telephone
            //$0.tag = "tel"
        }
        <<< PhoneRow("zipCode"){
            $0.title = "邮编"
            $0.placeholder = "请输入邮编"
            $0.value = AppDelegate.appUser?.zip
            //$0.tag = "zipCode"
        }
        <<< PhoneRow("qq"){
            $0.title = "QQ"
            $0.placeholder = "请输入QQ"
            $0.value = AppDelegate.appUser?.qq
            
            //$0.tag = "qq"
        }
        <<< EmailRow("email"){
            $0.title = "邮箱"
            $0.placeholder = "请输入邮箱"
            $0.value = AppDelegate.appUser?.email
            //$0.tag = "email"
        }
        <<< ButtonRow("confirm"){
            $0.title = "修改个人资料"
            
            }.onCellSelection({ (cell, row) in
                if row.title == "确认"{
                    let nameRow:TextRow = self.form.rowBy(tag: "username")!
                    let sexRow:PickerInputRow<String> = self.form.rowBy(tag: "sex")!
                    let dateRow:DateRow = self.form.rowBy(tag: "birthday")!
                    let phoneRow:PhoneRow = self.form.rowBy(tag: "phone")!
                    let telRow:PhoneRow = self.form.rowBy(tag: "tel")!
                    let zipCodeRow:PhoneRow = self.form.rowBy(tag: "zipCode")!
                    let qqRow:PhoneRow = self.form.rowBy(tag: "qq")!
                    let emailRow:EmailRow = self.form.rowBy(tag: "email")!
//                    let icon : ImageRow = self.form.rowBy(tag: "icon")!
//                    let values = self.form.values()
//                    print("\(values)--\(icon.value ?? UIImage.init(named: "my_head")!)--\(nameRow.value ?? "no name")--\(YTools.dateToString(date: dateRow.value!).substring(to: 10))")
                    row.title = "修改个人资料"
                    row.updateCell()
                    self.myCenterViewModel.requestInfoEditAct(true_name: nameRow.value ?? "", sex: sexRow.value ?? "", birthday: YTools.dateToString(date: dateRow.value!).substring(to: 10), mobile: phoneRow.value ?? "", email: emailRow.value ?? "", zip: zipCodeRow.value ?? "", teltphone: telRow.value ?? "", qq: qqRow.value ?? "", finishCallback: { (resultCode) in
                        /// resultCode对应关系如下
                        /// 1. 邮箱已被注册
                        /// 2. 手机已被注册
                        /// 3. 资料修改成功
                        if resultCode == 1{
                            YTools.showMyToast(rootView: self.view, message: "邮箱已被注册")
                        }else if resultCode == 2{
                            YTools.showMyToast(rootView: self.view, message: "手机已被注册")
                        }else if resultCode == 3{
                            YTools.showMyToast(rootView: self.view, message: "资料修改成功")
                        }
                    })
                }else if row.title == "修改个人资料"{
                    row.title = "确认"
                    row.updateCell()
                }
                
                
        }).cellSetup({ (cell, row) in
            cell.backgroundColor = UIColor(named: "save_blue")
            cell.tintColor = .white
            
        })
        <<< ButtonRow("loginOut"){
            $0.title = "退出登录"
        }.cellSetup({ (cell, row) in
            cell.backgroundColor = UIColor(named: "line_gray")
            cell.tintColor = UIColor(named: "dark_gray")
        }).onCellSelection({ (cell, row) in
//            print("退出登录")
            
            self.loginOutAlert.show()
            
        })
        
        // 开启导航辅助，并且遇到被禁用的行就隐藏导航
        navigationOptions = RowNavigationOptions.Enabled.union(.StopDisabledRow)
        // 开启流畅地滚动到之前没有显示出来的行
        animateScroll = true
        // 设置键盘顶部和正在编辑行底部的间距为20
        rowKeyboardSpacing = 20
    }
}
