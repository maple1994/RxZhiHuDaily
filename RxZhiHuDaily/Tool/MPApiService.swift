//
//  MPApiService.swift
//  RxZhiHuDaily
//
//  Created by Maple on 2017/9/28.
//  Copyright © 2017年 Maple. All rights reserved.
//

#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif
import Foundation
import Moya

class MPApiService {
    static let shareAPI = MPApiService()
    private let provider = RxMoyaProvider<ApiManager>()
    
    /// 加载菜单栏
    func loadMenuItemList() -> Observable<[MPMenuItemModel]> {
        return provider.request(.getThemeTypeList)
            .flatMapLatest { (reponse) -> Observable<[MPMenuItemModel]> in
                guard let dic = try? reponse.mapJSON() as? NSDictionary else {
                    return Observable.error(MPError.parseJsonError)
                }
                guard let otherArr = dic?["others"] as? [NSDictionary] else {
                    return Observable.error(MPError.parseJsonError)
                }
                var modelArr = [MPMenuItemModel]()
                var home = MPMenuItemModel()
                home.name = " 首页"
                modelArr.append(home)
                for dic in otherArr {
                    if let model = MPMenuItemModel.deserialize(from: dic) {
                        modelArr.append(model)
                    }
                }
                return Observable.just(modelArr)
            }
    }
    
    /// 获取首页新闻列表
    func loadHomeNewsList() -> Observable<MPStoryListModel>{
        return provider.request(.getHomeList)
            .flatMapLatest { (reponse) -> Observable<MPStoryListModel> in
                guard let dic = try? reponse.mapJSON() as? NSDictionary else {
                    return Observable.error(MPError.parseJsonError)
                }
                guard let list = MPStoryListModel.deserialize(from: dic) else {
                    return Observable.error(MPError.parseJsonError)
                }
                return Observable.just(list)
        }
    }
    
    /// 加载更多首页新闻
    func loadMoreHomeNewsList(date: String) -> Observable<MPStoryListModel> {
        return provider.request(.getMoreHomeList(date))
            .flatMapLatest { (reponse) -> Observable<MPStoryListModel> in
                guard let dic = try? reponse.mapJSON() as? NSDictionary else {
                    return Observable.error(MPError.parseJsonError)
                }
                guard let list = MPStoryListModel.deserialize(from: dic) else {
                    return Observable.error(MPError.parseJsonError)
                }
                return Observable.just(list)
        }
    }
    
    /// 获取话题列表
    func loadThemeList(ID: Int) -> Observable<[MPStoryModel]> {
        return provider.request(.getThemeList(ID))
            .flatMapLatest{ (reponse) -> Observable<[MPStoryModel]> in
                guard let dic = try? reponse.mapJSON() as? NSDictionary else {
                    return Observable.error(MPError.parseJsonError)
                }
                guard let list = MPStoryListModel.deserialize(from: dic) else {
                    return Observable.error(MPError.parseJsonError)
                }
                guard let arr = list.stories else {
                    return Observable.error(MPError.parseJsonError)
                }
                return Observable.just(arr)
            }
    }
    
    /// 获取话题详情
    func loadThemeDetail(ID: Int) -> Observable<MPStoryDetailModel> {
        return provider.request(.getThemeDetail(ID))
            .flatMapLatest { (reponse) -> Observable<MPStoryDetailModel> in
                guard let dic = try? reponse.mapJSON() as? NSDictionary else {
                    return Observable.error(MPError.parseJsonError)
                }
                guard let model = MPStoryDetailModel.deserialize(from: dic) else {
                    return Observable.error(MPError.parseJsonError)
                }
                return Observable.just(model)
        }
    }
}







