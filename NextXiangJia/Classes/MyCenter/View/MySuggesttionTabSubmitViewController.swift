//
//  MySuggesttionTabViewController.swift
//  NextXiangJia
//  发表建议
//  Created by DEV2018 on 2018/5/11.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import XLPagerTabStrip
private let textFieldW : CGFloat = finalScreenW / 10 * 9
private let textFieldH : CGFloat = 40
private let viewSpace :CGFloat = 20
private let buttonW: CGFloat = (finalScreenW - 80) / 3
class MySuggesttionTabSubmitViewController: UIViewController, IndicatorInfoProvider {
    //MARK: - 懒加载
    lazy var suggestionTitle: MyTextField = {
        let title = MyTextField(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 20, width: textFieldW, height: textFieldH))
        //        name.layer.borderColor = UIColor(named: "dark_gray")?.cgColor
        //        name.layer.borderWidth = 1
        
        title.placeholder = "建议标题"
        title.font = UIFont.systemFont(ofSize: 20)
        title.delegate = self
        title.layer.borderColor = UIColor.gray.lighten(by: 0.4).cgColor
        title.layer.borderWidth = 0.5
        title.backgroundColor = UIColor.random
        title.leftView?.size = CGSize(width: 15, height: textFieldH)
        return title
    }()
    
    lazy var suggestionContent: UITextView = {
        let content = UITextView(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 20 + textFieldH + viewSpace, width: textFieldW, height: textFieldH * 3))
        //        name.layer.borderColor = UIColor(named: "dark_gray")?.cgColor
        //        name.layer.borderWidth = 1
        //content.textAlignment = NSTextAlignment.center
        content.font = UIFont.systemFont(ofSize: 20)
        content.delegate = self
        content.layer.borderColor = UIColor.gray.lighten(by: 0.4).cgColor
        content.layer.borderWidth = 0.5
        content.placeholder = "建议内容"
        content.backgroundColor = UIColor.random
        return content
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.frame = CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 20 + textFieldH * 4 + viewSpace * 2 , width: textFieldW, height: textFieldH)
        button.setTitleForAllStates("找回密码")
        button.titleLabel?.textAlignment = .center
        button.setTitleColorForAllStates(.white)
        button.backgroundColor = UIColor(named: "global_orange")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.addTarget(self, action: #selector(submitButtonClicked), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var itemInfo: IndicatorInfo = "View"
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.setUI
        setUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for view in self.view.subviews{
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
extension MySuggesttionTabSubmitViewController{
    private func setUI(){
        self.view.backgroundColor = .white
        self.view.addSubview(suggestionTitle)
        self.view.addSubview(suggestionContent)
        self.view.addSubview(submitButton)
    }
}

extension MySuggesttionTabSubmitViewController : UITextFieldDelegate,UITextViewDelegate{
    
}

extension MySuggesttionTabSubmitViewController{
    @objc func submitButtonClicked(){
        
    }
}
