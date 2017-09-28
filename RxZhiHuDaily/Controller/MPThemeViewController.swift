//
//  MPOtherTypeViewController.swift
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

/// 主题列表控制器
class MPThemeViewController: UIViewController {
    
    fileprivate let disposeBag = DisposeBag()
    
    /// 菜单栏Item
    var themeModel: MPMenuItemModel? {
        didSet{
            navigationItem.title = themeModel?.name
            if let urlString = themeModel?.thumbnail {
                headerImg.kf.setImage(with: URL.init(string: urlString))
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        backBtn.rx.tap
            .subscribe(onNext: {
                self.slideMenuController()?.openLeft()
            })
            .addDisposableTo(disposeBag)
    }
    
    fileprivate func setupUI() {
        view.addSubview(headerImg)
        view.addSubview(tableView)
        headerImg.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(-64)
            make.height.equalTo(64)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(headerImg.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        // 设置导航栏
        navigationController?.navigationBar.subviews.first?.alpha = 0
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        backBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 60))
        backBtn.setImage(UIImage.init(named: "Back_White"), for: .normal)
        backBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -20, bottom: 0, right: 60)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)
    }
    
    // MARK: - View
    fileprivate lazy var tableView = UITableView()
    fileprivate var backBtn: UIButton!
    fileprivate lazy var headerImg = UIImageView()
}











