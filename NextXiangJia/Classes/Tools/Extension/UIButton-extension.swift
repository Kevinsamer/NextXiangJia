//
//  UIButton-extension.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/5/3.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
enum TitleImageStyly{
    ///图片在左，文字在右，整体居中。
    case ButtonImageTitleStyleDefault
    //图片在左，文字在右，整体居中。
    case ButtonImageTitleStyleLeft
    ///图片在右，文字在左，整体居中。
    case ButtonImageTitleStyleRight
    ///图片在上，文字在下，整体居中。
    case ButtonImageTitleStyleTop
    ///图片在下，文字在上，整体居中。
    case ButtonImageTitleStyleBottom
    ///图片居中，文字在上距离按钮顶部。
    case ButtonImageTitleStyleCenterTop
    ///图片居中，文字在下距离按钮底部。
    case ButtonImageTitleStyleCenterBottom
    ///图片居中，文字在图片上面。
    case ButtonImageTitleStyleCenterUp
    ///图片居中，文字在图片下面。
    case ButtonImageTitleStyleCenterDown
    ///图片在右，文字在左，距离按钮两边边距
    case ButtonImageTitleStyleRightLeft
    ///图片在左，文字在右，距离按钮两边边距
    case ButtonImageTitleStyleLeftRight
}
extension UIButton {
    
    func setButtonTitleImageStyle(padding:CGFloat, style:TitleImageStyly){
        let padding:CGFloat = padding
        if self.imageView?.image != nil && self.titleLabel?.text != nil {
            //先还原
            self.titleEdgeInsets = UIEdgeInsets.zero;
            self.imageEdgeInsets = UIEdgeInsets.zero;
            
            let imageRect:CGRect = self.imageView!.frame;
            let titleRect:CGRect = self.titleLabel!.frame;
            
            let totalHeight:CGFloat = imageRect.size.height + padding + titleRect.size.height;
            let selfHeight:CGFloat = self.frame.size.height;
            let selfWidth:CGFloat = self.frame.size.width;
            
            switch style{
            case .ButtonImageTitleStyleLeft :
                if (padding != 0)
                {
                    self.titleEdgeInsets = UIEdgeInsetsMake(0,
                                                            padding/2,
                                                            0,
                                                            -padding/2);
                    
                    self.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                            -padding/2,
                                                            0,
                                                            padding/2);
                }
                
                break
            case .ButtonImageTitleStyleRight:
                //图片在右，文字在左
                self.titleEdgeInsets = UIEdgeInsetsMake(0,
                                                        -(imageRect.size.width + padding/2),
                                                        0,
                                                        (imageRect.size.width + padding/2));
                
                self.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                        (titleRect.size.width +  padding/2),
                                                        0,
                                                        -(titleRect.size.width + padding/2));
                break
                
            case .ButtonImageTitleStyleTop:
                //图片在上，文字在下
                self.titleEdgeInsets = UIEdgeInsetsMake(((selfHeight - totalHeight)/2 + imageRect.size.height + padding - titleRect.origin.y),
                                                        (selfWidth/2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                                        -((selfHeight - totalHeight)/2 + imageRect.size.height + padding - titleRect.origin.y),
                                                        -(selfWidth/2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
                
                self.imageEdgeInsets = UIEdgeInsetsMake(((selfHeight - totalHeight)/2 - imageRect.origin.y),
                                                        (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                                        -((selfHeight - totalHeight)/2 - imageRect.origin.y),
                                                        -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));
                
                break
                
            case .ButtonImageTitleStyleBottom:
                //图片在下，文字在上。
                self.titleEdgeInsets = UIEdgeInsetsMake(((selfHeight - totalHeight)/2 - titleRect.origin.y),
                                                        (selfWidth/2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                                        -((selfHeight - totalHeight)/2 - titleRect.origin.y),
                                                        -(selfWidth/2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
                
                self.imageEdgeInsets = UIEdgeInsetsMake(((selfHeight - totalHeight)/2 + titleRect.size.height + padding - imageRect.origin.y),
                                                        (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                                        -((selfHeight - totalHeight) / 2 + titleRect.size.height + padding - imageRect.origin.y),
                                                        -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));
                
                break
            case .ButtonImageTitleStyleCenterTop:
                self.titleEdgeInsets = UIEdgeInsetsMake(-(titleRect.origin.y - padding),
                                                        (selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                                        (titleRect.origin.y - padding),
                                                        -(selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
                
                self.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                        (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                                        0,
                                                        -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));
                
                break
            case .ButtonImageTitleStyleCenterBottom:
                self.titleEdgeInsets = UIEdgeInsetsMake((selfHeight - padding - titleRect.origin.y - titleRect.size.height),
                                                        (selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                                        -(selfHeight - padding - titleRect.origin.y - titleRect.size.height),
                                                        -(selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
                
                self.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                        (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                                        0,
                                                        -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));

                break
                
            case .ButtonImageTitleStyleCenterUp:
                self.titleEdgeInsets = UIEdgeInsetsMake(-(titleRect.origin.y + titleRect.size.height - imageRect.origin.y + padding),
                                                        (selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                                        (titleRect.origin.y + titleRect.size.height - imageRect.origin.y + padding),
                                                        -(selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
                
                self.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                        (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                                        0,
                                                        -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));

                break
                
            case .ButtonImageTitleStyleCenterDown:
                self.titleEdgeInsets = UIEdgeInsetsMake((imageRect.origin.y + imageRect.size.height - titleRect.origin.y + padding),
                                                        (selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                                        -(imageRect.origin.y + imageRect.size.height - titleRect.origin.y + padding),
                                                        -(selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
                
                self.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                        (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                                        0,
                                                        -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));

                break
                
            case .ButtonImageTitleStyleRightLeft:
                //图片在右，文字在左，距离按钮两边边距
                
                self.titleEdgeInsets = UIEdgeInsetsMake(0,
                                                        -(titleRect.origin.x - padding),
                                                        0,
                                                        (titleRect.origin.x - padding));
                
                self.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                        (selfWidth - padding - imageRect.origin.x - imageRect.size.width),
                                                        0,
                                                        -(selfWidth - padding - imageRect.origin.x - imageRect.size.width));

                break
                
            case .ButtonImageTitleStyleLeftRight:
                //图片在左，文字在右，距离按钮两边边距
                
                self.titleEdgeInsets = UIEdgeInsetsMake(0,
                                                        (selfWidth - padding - titleRect.origin.x - titleRect.size.width),
                                                        0,
                                                        -(selfWidth - padding - titleRect.origin.x - titleRect.size.width));
                
                self.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                        -(imageRect.origin.x - padding),
                                                        0,
                                                        (imageRect.origin.x - padding));
                break
            default: break
                
            }
        }else{
            self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
}
