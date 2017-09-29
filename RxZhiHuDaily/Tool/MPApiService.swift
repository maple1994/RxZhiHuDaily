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
}
