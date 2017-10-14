//
//  MPHomeViewController.swift
//  RxZhiHuDaily
//
//  Created by Maple on 2017/9/21.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif
import SnapKit
import Moya
import RxDataSources
import SwiftDate

class MPHomeViewController: UIViewController {
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, MPStoryModel>>()
    fileprivate let NewsID: String = "NewsID"
    fileprivate let provide = RxMoyaProvider<ApiManager>()
    fileprivate let modelArr = Variable([SectionModel<String, MPStoryModel>]())
    /// 用于加载历史数据的日期
    fileprivate var newsDate: String = ""
    fileprivate let titleNum = Variable(0)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        UIApplication.shared.statusBarStyle = .lightContent
        setupTaleView()
        setupHeader()
        observerScrollView()
    }
    
    /// 设置头部
    fileprivate func setupHeader() {
        menuBtn.rx.tap
            .subscribe(onNext: {
                self.slideMenuController()?.openLeft()
            })
            .addDisposableTo(disposeBag)
        
        loadNewData()
        
        bannerView.collectionView.rx
            .modelSelected(MPStoryModel.self)
            .asDriver()
            .drive(onNext: { model in
                let detailVC = MPNewsDetailViewController()
                detailVC.id = model.id
                self.navigationController?.pushViewController(detailVC, animated: true)
            })
            .addDisposableTo(disposeBag)
        
        titleNum.asDriver()
            .distinctUntilChanged()
            .drive(onNext: { num in
                if num == 0 {
                    self.navigationItem.title = "今日要闻"
                }else {
                    let date = DateInRegion.init(string: self.dataSource[num].model, format: DateFormat.custom("yyyyMMdd"))!
                    self.navigationItem.title = "\(date.month)月\(date.day)日 \(date.weekday.toWeekday())"
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    /// 设置tableView
    fileprivate func setupTaleView() {
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsID)
        dataSource.configureCell = { (dataSource, tableView, indexPath, model) in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.NewsID) as! NewsTableViewCell
            cell.model = model
            return cell
        }
        
        tableView.rx.modelSelected(MPStoryModel.self)
            .subscribe(onNext: { model in
                let detailVC = MPNewsDetailViewController()
                detailVC.id = model.id
                self.navigationController?.pushViewController(detailVC, animated: true)
            })
            .addDisposableTo(disposeBag)
        
        modelArr
            .asObservable()
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        tableView.rx.setDelegate(self).addDisposableTo(disposeBag)
    }
    
    /// 监听scrollView
    fileprivate func observerScrollView() {
        // tableView往下拖拽时，将offsetY绑定给bannerView的offY属性
        tableView.rx.contentOffset
            .filter { $0.y < 0 }
            .map { $0.y }
            .asDriver(onErrorJustReturn: 0)
            .drive(bannerView.offY)
            .addDisposableTo(disposeBag)
    }
    
    fileprivate func setupUI() {
        self.view.backgroundColor = UIColor.white
        
        barImg = (navigationController?.navigationBar.subviews.first)!
        barImg.alpha = 0
        navigationItem.title = "今日要闻"
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = menuBtn
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = UIColor.rgb(63, 141, 208)
        navigationController?.navigationBar.isTranslucent = false
        
        view.addSubview(tableView)
        view.addSubview(refreshView)
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-64)
            make.left.right.bottom.equalToSuperview()
        }
        
        refreshView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-37)
            make.centerX.equalToSuperview().offset(-45)
            make.height.width.equalTo(30)
        }
        
        bannerView.frame = CGRect(x: 0, y: 0, width: screenW, height: 200)
        tableView.tableHeaderView = bannerView
    }
    
    /// 请求最新数据
    fileprivate func loadNewData() {
        MPApiService.shareAPI.loadHomeNewsList()
            .asDriver(onErrorJustReturn: MPStoryListModel())
            .drive(onNext: { (model) in
                self.refreshView.endRefresh()
                if let storyArr = model.stories, let date = model.date {
                    self.newsDate = date
                    let section = SectionModel(model: date, items: storyArr)
                    self.modelArr.value = [section]
                }
                // 轮播图效果
                if let topArr = model.top_stories {
                    if topArr.count > 1 {
                        self.bannerView.imgUrlArr.value = [topArr.last!] + topArr + [topArr.first!]
                    }else {
                        self.bannerView.imgUrlArr.value = topArr
                    }
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    /// 加载更多首页数据
    fileprivate func loadMoreData() {
        MPApiService.shareAPI.loadMoreHomeNewsList(date: newsDate)
        .asDriver(onErrorJustReturn: MPStoryListModel())
            .drive(onNext: { (model) in
                if let stories = model.stories, let date = model.date {
                    self.modelArr.value.append(SectionModel(model: date, items: stories))
                    self.newsDate = date
                }
            })
        .addDisposableTo(disposeBag)
    }
    
    fileprivate func createSectionHeaderView(dateStr: String) -> UIView {
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 0, width: screenW, height: 38)
        label.backgroundColor = UIColor.rgb(63, 141, 208)
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        let date = DateInRegion.init(string: dateStr, format: DateFormat.custom("yyyyMMdd"))!
        label.text = "\(date.month)月\(date.day)日 \(date.weekday.toWeekday())"
        return label
    }
    
    // MARK: - View
    fileprivate lazy var refreshView = MPCircleRefreshView()
    fileprivate var barImg = UIView()
    fileprivate lazy var menuBtn: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: nil, action: nil)
        return item
    }()
    fileprivate lazy var tableView: UITableView = {
        let tb = UITableView(frame: CGRect.zero, style: .grouped)
        tb.rowHeight = 100
        return tb
    }()
    fileprivate lazy var bannerView: BannerView = {
        let view = BannerView()
        return view
    }()
    
}

extension MPHomeViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        barImg.alpha = scrollView.contentOffset.y / 200
        if scrollView.contentOffset.y < 0 {
            refreshView.pullToRefresh(progress: -scrollView.contentOffset.y / 64)
        }
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y <= -64 {
            refreshView.beginRefresh {
                self.loadNewData()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        refreshView.pullToRefresh(progress: 0)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 滚动到最后一个section的第一个元素时，加载更多数据
        if indexPath.section == modelArr.value.count - 1 && indexPath.row == 0 {
            loadMoreData()
        }
        // 获得当前列表显示的最小section
        DispatchQueue.global().async {
            if let value = (tableView.indexPathsForVisibleRows?.reduce(Int.max) { (result, ind) -> Int in return min(result, ind.section) }) {
                self.titleNum.value = value
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createSectionHeaderView(dateStr: dataSource[section].model)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 38
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

}




