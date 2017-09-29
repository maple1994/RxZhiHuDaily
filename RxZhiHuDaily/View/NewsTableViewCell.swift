//
//  NewsTableViewCell.swift
//  MPZhiHuDaily
//
//  Created by Maple on 2017/8/21.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit
import SnapKit

/// 新闻列表Cell
class NewsTableViewCell: UITableViewCell {

    var model: MPStoryModel? {
        didSet {
            if let myModel = model {
                titleLabel.text = myModel.title
                if let path = model?.images?.first {
                    iconImgView.kf.setImage(with: URL.init(string: path))
                    titleLabel.snp.updateConstraints({ (make) in
                        make.right.equalToSuperview().offset(-105)
                    })
                }else {
                    iconImgView.image = nil
                    titleLabel.snp.updateConstraints({ (make) in
                        make.right.equalToSuperview().offset(-15)
                    })
                }
                morePicIcon.isHidden = !myModel.multipic
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconImgView)
        contentView.addSubview(morePicIcon)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(iconImgView)
            make.right.equalToSuperview().offset(-105)
        }
        
        iconImgView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.width.equalTo(75)
            make.height.equalTo(60)
        }
        
        morePicIcon.snp.makeConstraints { (make) in
            make.bottom.equalTo(iconImgView)
            make.trailing.equalTo(iconImgView)
            make.width.equalTo(32)
            make.height.equalTo(14)
        }
    }
    
    // MARK: - View
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate lazy var iconImgView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    fileprivate lazy var morePicIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Home_Morepic")
        return iv
    }()
}








