//
//  CustomTableViewCell.swift
//  DiseaseNotification
//
//  Created by 정성윤 on 2023/11/20.
//

import Foundation
import UIKit

class CustomTableViewCell : UITableViewCell {
    // 제목, 내용, 이미지
    var titleLabel = UILabel()
    var commentLabel = UILabel()
    var dangerView = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupViews() {
        // titleLabel 설정
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        
        // commentLabel 설정
        commentLabel.numberOfLines = 0 //여러 줄의 텍스트를 표시하기 위해 설정
        commentLabel.font = UIFont.systemFont(ofSize: 15)
        commentLabel.textColor = .lightGray
        
        // stack으로 오토레이아웃 설정
        let AllStackView = UIStackView()
        AllStackView.axis = .horizontal
        AllStackView.distribution = .fill
        AllStackView.spacing = 10
        AllStackView.alignment = .fill
        // 제목, 내용, 시간에 대해 넣을 뷰
        let totalView = UIView()
        totalView.backgroundColor = .white
        totalView.addSubview(titleLabel)
        totalView.addSubview(commentLabel)
        AllStackView.addArrangedSubview(totalView)
        //이미지 설정
        dangerView.textColor = .black
        dangerView.backgroundColor = .white
        dangerView.font = UIFont.boldSystemFont(ofSize: 15)
        AllStackView.addArrangedSubview(dangerView)
        contentView.addSubview(AllStackView)
        
        //SnapKit으로 오토레이아웃 설정
        AllStackView.snp.makeConstraints{ (make) in
            make.top.bottom.leading.equalToSuperview().inset(0)
            make.trailing.equalToSuperview().offset(-20)
        }
        totalView.snp.makeConstraints{ (make) in
            make.top.bottom.leading.trailing.equalToSuperview().inset(0)
        }
        dangerView.snp.makeConstraints{ (make) in
            make.top.bottom.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().offset(0)
            make.width.equalTo(AllStackView.snp.width).dividedBy(4)
        }
        titleLabel.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset((20))
            make.width.equalTo(AllStackView.snp.width).dividedBy(1.5)
        }
        commentLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset((15))
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(AllStackView.snp.width).dividedBy(1.5)
            make.height.equalTo(30)
        }
    }
}
