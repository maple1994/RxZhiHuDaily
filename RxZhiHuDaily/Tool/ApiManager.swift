//
//  APIManager.swift
//  RxZhiHuDaily
//
//  Created by Maple on 2017/9/21.
//  Copyright © 2017年 Maple. All rights reserved.
//

import Foundation
import Moya

enum ApiManager {
    /// 获取话题类型列表
    case getThemeTypeList
    /// 获取首页话题列表
    case getHomeList
    /// 获取某个话题列表
    case getThemeList(Int)
    /// 加载更多首页话题
    case getMoreHomeList(String)
}

extension ApiManager: TargetType {
    /// The target's base `URL`.
    var baseURL: URL {
        return URL.init(string: "http://news-at.zhihu.com/api/")!
    }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        switch self {
        case .getThemeTypeList:
            return "4/themes"
        case .getHomeList:
            return "4/news/latest"
        case let .getThemeList(id):
            return "4/theme/\(id)"
        case let .getMoreHomeList(date):
            return "4/news/before/\(date)"
        }
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method {
        return .get
    }
    
    /// The parameters to be encoded in the request.
    var parameters: [String: Any]? {
        return nil
    }
    
    /// The method used for parameter encoding.
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    /// Provides stub data for use in testing.
    var sampleData: Data {
        return Data()
    }
    
    /// The type of HTTP task to be performed.
    var task: Task {
        return .request
    }
    
    /// Whether or not to perform Alamofire validation. Defaults to `false`.
    var validate: Bool {
        return false
    }
}

enum MPError: Swift.Error {
    case parseJsonError
}










