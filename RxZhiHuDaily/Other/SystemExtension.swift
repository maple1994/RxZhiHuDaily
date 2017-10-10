//
//  SystemExtension.swift
//  RxZhiHuDaily
//
//  Created by Maple on 2017/9/21.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit
import Moya
import HandyJSON
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

let screenW: CGFloat = UIScreen.main.bounds.width
let screenH: CGFloat = UIScreen.main.bounds.height

extension Response {
    /// 将json解析为单个的Model
    public func mapObject<T: HandyJSON>(_ type: T.Type) throws -> T {
        guard let dic = try self.mapJSON() as? NSDictionary else {
            throw MoyaError.jsonMapping(self)
        }
        guard let obj = T.deserialize(from: dic) else {
            throw MoyaError.jsonMapping(self)
        }
        return obj
    }
}

extension ObservableType where E == Response {
    /// 这个是将JSON解析为Observable类型的Model
    public func mapObject<T: HandyJSON>(_ type: T.Type) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.mapObject(T.self))
        }
    }
}

extension UIColor {
    class func colorWithHexString (_ hex:String,alpha:CGFloat = 1.0) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.lengthOfBytes(using: String.Encoding.utf8) != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    class func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        return UIColor.init(red: r / 255,
                            green: g / 255,
                            blue: b / 255,
                            alpha: 1.0)
    }
}

extension Int {
    func toWeekday() -> String {
        switch self {
        case 2:
            return "星期一"
        case 3:
            return "星期二"
        case 4:
            return "星期三"
        case 5:
            return "星期四"
        case 6:
            return "星期五"
        case 7:
            return "星期六"
        case 1:
            return "星期日"
        default:
            return ""
        }
    }
}
