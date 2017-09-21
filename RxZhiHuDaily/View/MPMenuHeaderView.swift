//
//  MPMenuHeaderView.swift
//  RxZhiHuDaily
//
//  Created by Maple on 2017/9/21.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit
import SnapKit

class MPMenuHeaderView: UIView {

    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    private func setupUI() {
        addSubview(headerImgView)
        addSubview(usernameLabel)
        addSubview(collectionButton)
        addSubview(msgButton)
        addSubview(settingButton)
        
        headerImgView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(35)
        }
        
        usernameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(headerImgView)
            make.leading.equalTo(headerImgView.snp.trailing).offset(10)
        }
        
        collectionButton.snp.makeConstraints { (make) in
            make.top.equalTo(headerImgView.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(44)
            make.bottom.equalToSuperview()
        }
        
        msgButton.snp.makeConstraints { (make) in
            make.leading.equalTo(collectionButton.snp.trailing)
            make.top.width.height.equalTo(collectionButton)
        }
        
        settingButton.snp.makeConstraints { (make) in
            make.leading.equalTo(msgButton.snp.trailing)
            make.top.width.height.equalTo(msgButton)
        }
    }
    
    // MARK: - View
    private lazy var headerImgView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Menu_Avatar")
        return iv
    }()
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Maple"
        label.textColor = UIColor.lightGray
        return label
    }()
    private lazy var collectionButton: UIButton = {
        let button = MPImageTopButton()
        button.setTitle("收藏", for: .normal)
        button.setImage(UIImage(named: "Menu_Icon_Collect"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        return button
    }()
    private lazy var msgButton: UIButton = {
        let button = MPImageTopButton()
        button.setTitle("消息", for: .normal)
        button.setImage(UIImage(named: "Menu_Icon_Message"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        return button
    }()
    private lazy var settingButton: UIButton = {
        let button = MPImageTopButton()
        button.setTitle("设置", for: .normal)
        button.setImage(UIImage(named: "Menu_Icon_Setting"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        return button
    }()
}

class MPMenuFooterView: UIView {
    
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        addSubview(offLineButton)
        addSubview(darkButton)
        
        offLineButton.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalToSuperview()
        }
        
        darkButton.snp.makeConstraints { (make) in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(offLineButton.snp.trailing)
            make.width.equalTo(offLineButton)
        }
    }
    
    private lazy var offLineButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("离线", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.setImage(UIImage(named: "Menu_Download"), for: .normal)
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0)
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15)
        return btn
    }()
    
    private lazy var darkButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("夜间", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.setImage(UIImage(named: "Menu_Dark"), for: .normal)
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0)
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15)
        return btn
    }()
    
}

/// 图片在文字上面的Button
class MPImageTopButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let label = titleLabel, let img = imageView else {
            return
        }
        img.frame.origin.y = (self.frame.height - img.frame.height - label.frame.height) * 0.5
        img.frame.origin.x = (self.frame.width - img.frame.size.width) * 0.5
        label.frame.origin.x = (self.frame.width - label.frame.size.width) * 0.5
        label.frame.origin.y = img.frame.maxY + 3
    }
}








