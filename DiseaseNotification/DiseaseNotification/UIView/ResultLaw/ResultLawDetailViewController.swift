//
//  ResultLawDetailViewController.swift
//  DiseaseNotification
//
//  Created by 정성윤 on 2023/11/22.
//

import Foundation
import UIKit

class ResultLawDetailViewController : UIViewController {
    let post : ResultPost
    //이니셜라이저를 사용하여 Post 객체를 전달받아 post 속성에 저장
    init(post: ResultPost) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(
            red: CGFloat((0x17ACFF & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((0x17ACFF & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(0x17ACFF & 0x0000FF) / 255.0,
            alpha: 1.0
        )
        self.title = post.bill_name // 질병 코드
        if let navigationBar = navigationController?.navigationBar {
                navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]}
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.backgroundColor = UIColor(
            red: CGFloat((0x17ACFF & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((0x17ACFF & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(0x17ACFF & 0x0000FF) / 255.0,
            alpha: 1.0
        )
        setupViews()
    }
    func setupViews() {
        let StackView = UIStackView()
        StackView.spacing = 10
        StackView.distribution = .fill
        StackView.axis = .vertical
        StackView.backgroundColor = UIColor(
            red: CGFloat((0x17ACFF & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((0x17ACFF & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(0x17ACFF & 0x0000FF) / 255.0,
            alpha: 1.0
        )
        
        let cntView = UIStackView()
        cntView.backgroundColor = .white
        cntView.layer.cornerRadius = 10
        cntView.layer.masksToBounds = true
        cntView.axis = .vertical
        cntView.distribution = .fill
        cntView.spacing = 10
        
        let view = UIView()
        view.backgroundColor = .white
        let cntLabel = UILabel()
        cntLabel.textColor = .black
        cntLabel.backgroundColor = .white
        cntLabel.font = UIFont.boldSystemFont(ofSize: 20)
        cntLabel.text = "심의결과 : "
        view.addSubview(cntLabel)
        cntLabel.snp.makeConstraints{ (make) in
            make.height.equalTo(20)
            make.top.equalToSuperview().offset(0)
            make.leading.equalToSuperview().inset(20)
        }
        cntView.addArrangedSubview(view)
        view.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(30)
            make.leading.equalToSuperview().offset(0)
        }
        let cntsubView = UIStackView()
        cntsubView.backgroundColor = .white
        cntsubView.layer.cornerRadius = 10
        cntsubView.layer.masksToBounds = true
        cntsubView.axis = .horizontal
        cntsubView.distribution = .fill
        cntsubView.spacing = 10
        let cntexplain = UILabel()
        cntexplain.textColor = .lightGray
        cntexplain.backgroundColor = .white
        cntexplain.font = UIFont.boldSystemFont(ofSize: 20)
        cntexplain.text = "Title : "
        cntsubView.addArrangedSubview(cntexplain)
        cntexplain.snp.makeConstraints{ (make) in
            make.height.equalTo(20)
            make.top.equalToSuperview().offset(0)
            make.leading.equalToSuperview().inset(0)
            make.width.equalToSuperview().dividedBy(1.5)
        }
        let cnt = UITextField()
        cnt.isEnabled = false
        cnt.text = "\(post.proc_result)"
        cnt.textColor = .black
        cnt.textAlignment = .left
        cnt.font = UIFont.boldSystemFont(ofSize: 23)
        cntsubView.addArrangedSubview(cnt)
        cnt.snp.makeConstraints{ (make) in
            make.height.equalTo(30)
            make.top.equalToSuperview().offset(0)
            make.width.equalToSuperview().dividedBy(2)
        }
        cntView.addArrangedSubview(cntsubView)
        cntsubView.snp.makeConstraints{(make) in
            make.height.equalTo(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(0)
        }
        
        let view2 = UIView()
        view2.backgroundColor = .white
        let riskView = UIStackView()
        riskView.backgroundColor = .white
        riskView.layer.cornerRadius = 10
        riskView.layer.masksToBounds = true
        riskView.axis = .vertical
        riskView.distribution = .fill
        let riskLabel = UILabel()
        riskLabel.textColor = .black
        riskLabel.backgroundColor = .white
        riskLabel.font = UIFont.boldSystemFont(ofSize: 20)
        riskLabel.text = "소관위원회 : "
        view2.addSubview(riskLabel)
        riskLabel.snp.makeConstraints{ (make) in
            make.height.equalTo(20)
            make.top.equalToSuperview().offset(0)
            make.leading.equalToSuperview().inset(20)
        }
        riskView.addArrangedSubview(view2)
        view2.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(30)
            make.leading.trailing.equalToSuperview().offset(0)
        }
        let risksubView = UIStackView()
        risksubView.backgroundColor = .white
        risksubView.layer.cornerRadius = 10
        risksubView.layer.masksToBounds = true
        risksubView.axis = .horizontal
        risksubView.distribution = .fill
        risksubView.spacing = 10
        let riskexplain = UILabel()
        riskexplain.textColor = .lightGray
        riskexplain.backgroundColor = .white
        riskexplain.font = UIFont.boldSystemFont(ofSize: 20)
        riskexplain.text = "Committe : "
        risksubView.addArrangedSubview(riskexplain)
        riskexplain.snp.makeConstraints{ (make) in
            make.height.equalTo(20)
            make.top.equalToSuperview().offset(0)
            make.leading.equalToSuperview().inset(0)
            make.width.equalToSuperview().dividedBy(1.4)
        }
        let riskcnt = UITextField()
        riskcnt.isEnabled = false
        riskcnt.text = post.committee
        
        riskcnt.font = UIFont.boldSystemFont(ofSize: 23)
        risksubView.addArrangedSubview(riskcnt)
        riskcnt.snp.makeConstraints{ (make) in
            make.height.equalTo(30)
            make.top.equalToSuperview().offset(0)
            make.width.equalToSuperview().dividedBy(2)
        }
        riskView.addArrangedSubview(risksubView)
        risksubView.snp.makeConstraints{(make) in
            make.height.equalTo(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        let view3 = UIView()
        view3.backgroundColor = .white
        let plnView = UIStackView()
        plnView.backgroundColor = .white
        plnView.layer.cornerRadius = 10
        plnView.layer.masksToBounds = true
        plnView.spacing = 30
        plnView.axis = .vertical
        plnView.distribution = .fill
        let plnLabel = UILabel()
        plnLabel.textColor = .black
        plnLabel.backgroundColor = .white
        plnLabel.font = UIFont.boldSystemFont(ofSize: 20)
        plnLabel.text = "법 상세 정보 : "
        view3.addSubview(plnLabel)
        plnLabel.snp.makeConstraints{ (make) in
            make.height.equalTo(30)
            make.top.equalToSuperview().offset(0)
            make.leading.equalToSuperview().inset(20)
        }
        plnView.addArrangedSubview(view3)
        view3.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(30)
            make.leading.trailing.equalToSuperview().offset(0)
        }
        let pln = UITextView()
        pln.isEditable = false
        pln.text = post.bill_name + "\n\n" + post.bill_no + "\n\n"  + post.committee + "\n\n" + post.proposer + "\n\n" + post.proc_result + "\n\n" + post.proc_dt
        pln.textColor = .lightGray
        pln.font = UIFont.boldSystemFont(ofSize: 15)
        plnView.addArrangedSubview(pln)
        pln.snp.makeConstraints{ (make) in
            make.height.equalTo(30)
            make.top.equalTo(plnLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        let hospitalBtn = UIButton()
        hospitalBtn.backgroundColor = .white
        hospitalBtn.setTitle("  관련 기사 찾아보기", for: .normal)
        hospitalBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        hospitalBtn.setTitleColor(UIColor(
            red: CGFloat((0x2D31AC & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((0x2D31AC & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(0x2D31AC & 0x0000FF) / 255.0,
            alpha: 1.0), for: .normal)
        hospitalBtn.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        hospitalBtn.addTarget(self, action: #selector(resultBtnTapped), for: .touchUpInside)
        plnView.addArrangedSubview(hospitalBtn)
        hospitalBtn.snp.makeConstraints{ (make) in
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-30)
        }
        let plnsp = UIView()
        plnsp.backgroundColor = .white
        plnView.addArrangedSubview(plnsp)
        
        let Spacing = UIView()
        Spacing.backgroundColor = .white
        StackView.addArrangedSubview(Spacing)
        StackView.addArrangedSubview(cntView)
        StackView.addArrangedSubview(riskView)
        let Spacing2 = UIView()
        Spacing2.backgroundColor = .white
        StackView.addArrangedSubview(plnView)
        StackView.addArrangedSubview(Spacing2)
        self.view.addSubview(StackView)
        StackView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(self.view.frame.height / 8.5)
            make.bottom.equalToSuperview().offset(-self.view.frame.height / 17.5)
            make.leading.trailing.equalToSuperview().inset(0)
        }
        cntView.snp.makeConstraints{ (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(0)
            make.height.equalToSuperview().dividedBy(5)
        }
        riskView.snp.makeConstraints{ (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(cntView.snp.bottom).offset(10)
            make.height.equalToSuperview().dividedBy(5)
        }
        plnView.snp.makeConstraints{ (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(riskView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-0)
        }
    }
    @objc func resultBtnTapped() {
        print("resultBtnTapped - called()")
        self.navigationController?.pushViewController(WebViewController(post: post.bill_name), animated: true)
    }
}
