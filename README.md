# NextXiangJia
使用pod下载ImageRow之后修改pod/ImageRow/ImageRow.swift中的按键名字符串以适配本地语言
使用pod下载CircleLabel之后修改CircleLabel.Swift，在成员变量定义中添加以下内容
   @IBInspectable public var font:UIFont = UIFont.systemFont(ofSize: 30){
        didSet{
            setCircleAndText()
        }
    }
    在private func circle(diameter: CGFloat, color: UIColor) -> UIImage?方法中添加
    label.font=font
