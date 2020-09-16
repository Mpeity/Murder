//
//  QuestionView.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/24.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

let QuestionViewCellId = "QuestionViewCellId"


class QuestionView: UIView {
    
    var room_id: Int?
    
    var script_node_id: Int?
    
    // 题目名称
    var subjectLabel: UILabel = UILabel()
    // 题目性质 单选/多选
    var propertyLabel: UILabel = UILabel()
    // 倒计时
//    private var timer: Timer?
    private var timerCount = 600
    // 倒计时
    var countLabel: UILabel = UILabel()
    // 题目选项
    private lazy var tableView: UITableView = UITableView()
    // confirm 确定按钮 / 提交按钮
    private var confirmBtn: GradienButton = GradienButton()
    // 上一题 previous
    private var previousBtn: UIButton = UIButton()
    
    // 单选/多选
    private var questionType = 0  // 0 单选 1 多选
    
    private var selectPath: IndexPath? //单选
    private var cellIndexPath: NSMutableArray? = NSMutableArray.init() //多选
    // 答案
    private var user_script_answer_ids: [Int]? = [Int]()
    
    // 答案记录
    private var answerList: [[String : AnyObject]]? = [[String : AnyObject]]()
    // 是否已经答题
    var isAnswer = false
    
    
    private var newArray: NSMutableArray? = NSMutableArray.init()
    
    // 题目数据
    var scriptQuestionList: [ScriptQuestionListModel]? {
        didSet {
            guard let scriptQuestionList = scriptQuestionList else {
                return
            }
            
            refreshUI()
            Log(scriptQuestionList)
        }
    }
    
    // 题目数量
    var subjectIndexPath: [AnyObject] = []
    
    // 选项数量
    var choiceArr: [ScriptAnswerModel]? {
        didSet {
            guard choiceArr != nil else {
                return
            }
            tableView.reloadData()
        }
    }
    // 当前第几道题
    var selectedIndex: Int = 0 {
        didSet {
            refreshUI()
            if selectedIndex == 0 {
                previousBtn.isHidden = true
                confirmBtn.snp.remakeConstraints { (make) in
                    make.right.equalToSuperview().offset(-37)
                    make.width.equalTo(FULL_SCREEN_WIDTH-37-37)
                    make.left.equalToSuperview().offset(37)
                    make.height.equalTo(50)
                    if #available(iOS 11.0, *) {
                       make.bottom.equalTo(self.safeAreaLayoutGuide.snp .bottom).offset(-10)
                    } else {
                       make.bottom.equalToSuperview().offset(-10)
                    }
                }
                
                confirmBtn.layoutIfNeeded()
                
//                confirmBtn.gradientClearLayerColor(cornerRadius: 25)
//                confirmBtn.setOtherGradienButtonColor(start: "#3522F2", end: "#934BFE", cornerRadius: 25)
                
//                confirmBtn.backgroundColor = HexColor(MainColor)
//                confirmBtn.layer.cornerRadius = 25
//                confirmBtn.layer.masksToBounds = true
                
            } else {
                if selectedIndex == scriptQuestionList!.count-1 {
                    confirmBtn.setTitle("提出", for: .normal)
                } else {
                    confirmBtn.setTitle("確認", for: .normal)
                }
                previousBtn.isHidden = false
                confirmBtn.snp.remakeConstraints { (make) in
                    make.width.equalTo(143)
                    make.left.equalToSuperview().offset(FULL_SCREEN_WIDTH-143-37)
                    make.height.equalTo(50)
                    if #available(iOS 11.0, *) {
                       make.bottom.equalTo(self.safeAreaLayoutGuide.snp .bottom).offset(-10)
                    } else {
                       // Fallback on earlier versions
                       make.bottom.equalToSuperview().offset(-10)
                    }
                }
                confirmBtn.layoutIfNeeded()
//                confirmBtn.gradientClearLayerColor(cornerRadius: 25)
//                confirmBtn.setOtherGradienButtonColor(start: "#3522F2", end: "#934BFE", cornerRadius: 25)
            }
        }
    }
    

        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
    }

}


extension QuestionView {
    
    private func refreshUI() {
        let model = scriptQuestionList![selectedIndex]
        subjectLabel.text = model.questionTitle
        choiceArr = model.scriptAnswer!
        propertyLabel.text = model.questionType == 0 ? "（ 单選 ）" : "（ 多選 ）"
        user_script_answer_ids = []
        
        selectPath = nil
        cellIndexPath = []
        
        
        if newArray?.count != 0 && selectedIndex < newArray!.count {
            
            let item = newArray![selectedIndex]
            if model.questionType == 0{ // 单选
                selectPath = item as? IndexPath
            } else {
                cellIndexPath = item as? NSMutableArray
            }
        }

        
//        if isAnswer {
//            let item = newArray![selectedIndex]
//            if model.questionType == 0{ // 单选
//                selectPath = item as? IndexPath
//            } else {
//                cellIndexPath = item as? NSMutableArray
//            }
//        }
    }
    
    
    private func setUI() {
        
        self.frame = CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT)

        let bgView = UIView()
        bgView.backgroundColor = HexColor("#F5F5F5")
        self.addSubview(bgView)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            if #available(iOS 11.0, *) {
                let height = 537 + 34
                make.height.equalTo(height)
            } else {
                make.height.equalTo(537)
            }
           
        }
        bgView.layoutIfNeeded()
        bgView.viewWithCorner(byRoundingCorners: [UIRectCorner.topLeft,UIRectCorner.topRight], radii: 15)
        
        
        let view = UIView()
        view.backgroundColor = UIColor.white
        bgView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.right.left.equalToSuperview()
            make.height.equalTo(45)
            make.top.equalToSuperview()
        }
        let label = UILabel()
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        label.text = "質問"
        label.textColor = HexColor("#333333")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        let cancelBtn = UIButton()
        view.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.height.width.equalTo(40)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        cancelBtn.addTarget(self, action: #selector(hideView), for: .touchUpInside)
        cancelBtn.setImage(UIImage(named: "cancel_readscript"), for: .normal)
        
        
        subjectLabel.textAlignment = .center
        subjectLabel.text = "犯人を選んでください?"
        subjectLabel.textColor = HexColor(DarkGrayColor)
        subjectLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        self.addSubview(subjectLabel)
        subjectLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp_bottom).offset(30)
            make.right.leading.equalToSuperview()
            make.height.equalTo(28)
        }
        
        countLabel.textColor = HexColor(LightDarkGrayColor)
        countLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        countLabel.text = "カウントダウン：300s "
        self.addSubview(countLabel)
        countLabel.snp.makeConstraints { (make) in
            make.top.equalTo(subjectLabel.snp_bottom).offset(5)
            make.left.equalToSuperview().offset(108)
            make.height.equalTo(22)
        }
        
        
        propertyLabel.textAlignment = .center
        propertyLabel.textColor = HexColor(LightDarkGrayColor)
        propertyLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        self.addSubview(propertyLabel)
        propertyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(subjectLabel.snp_bottom).offset(5)
            make.left.equalTo(countLabel.snp_right).offset(10)
            make.height.equalTo(22)
        }
        
        

        confirmBtn.setTitleColor(UIColor.white, for: .normal)
        confirmBtn.setTitle("確認", for: .normal)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        confirmBtn.addTarget(self, action: #selector(confirmBtnAction), for: .touchUpInside)
        self.addSubview(confirmBtn)
        
        confirmBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-37)
            make.left.equalToSuperview().offset(37)
            make.height.equalTo(50)
            if #available(iOS 11.0, *) {
               make.bottom.equalTo(self.safeAreaLayoutGuide.snp .bottom).offset(-10)
            } else {
               // Fallback on earlier versions
               make.bottom.equalToSuperview().offset(-10)
            }
        }
        confirmBtn.layoutIfNeeded()
//        confirmBtn.gradientClearLayerColor(cornerRadius: 25)
//        confirmBtn.setOtherGradienButtonColor(start: "#3522F2", end: "#934BFE", cornerRadius: 25)
        
        confirmBtn.backgroundColor = HexColor(MainColor)
        confirmBtn.layer.cornerRadius = 25
        confirmBtn.layer.masksToBounds = true

        
        previousBtn.layer.borderColor = HexColor(MainColor).cgColor
        previousBtn.layer.borderWidth = 0.5
        previousBtn.layer.cornerRadius = 25
        previousBtn.layer.borderColor = HexColor(MainColor).cgColor
        previousBtn.layer.borderWidth = 0.5
        previousBtn.setTitleColor(HexColor(MainColor), for: .normal)
        previousBtn.setTitle("前へ", for: .normal)
        previousBtn.backgroundColor = UIColor.white
        previousBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        previousBtn.isHidden = true
        previousBtn.addTarget(self, action: #selector(previousBtnAction), for: .touchUpInside)
        self.addSubview(previousBtn)
        previousBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(37)
            make.width.equalTo(143)
            make.height.equalTo(50)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-10)
            } else {
                // Fallback on earlier versions
                make.bottom.equalToSuperview().offset(-10)
            }
        }

  
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "QuestionViewCell", bundle: nil), forCellReuseIdentifier: QuestionViewCellId)
        // 隐藏cell系统分割线
        tableView.separatorStyle = .none;
        tableView.rowHeight = 47
        tableView.backgroundColor = HexColor("#F5F5F5")
        bgView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(propertyLabel.snp.bottom).offset(19)
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(confirmBtn.snp_top).offset(-50)
        }
    }
}


extension QuestionView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return choiceArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
  
        let cell = tableView.dequeueReusableCell(withIdentifier: QuestionViewCellId, for: indexPath) as! QuestionViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = HexColor("#F5F5F5")
        cell.isSelected = false
        let model = choiceArr![indexPath.row]
        cell.itemModel = model
        
        let questionModel = scriptQuestionList![selectedIndex]
        questionType = questionModel.questionType!
        
        if questionType == 0 { // 单选
            
            if selectPath == indexPath {
                model.isCheck = true
            } else{
                model.isCheck = false
            }
        } else { // 多选
            if self.cellIndexPath != nil  {
                if self.cellIndexPath!.contains(indexPath) {
                    model.isCheck = true
                } else {
                    model.isCheck = false
                }
            }

        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isAnswer {
            return
        }
        let questionModel = scriptQuestionList![selectedIndex]
        questionType = questionModel.questionType!
        if questionType == 0 { // 单选
            for (index,item) in choiceArr!.enumerated() {
                let path = IndexPath(row: index, section: 0)
                let cell = tableView.cellForRow(at: path) as? QuestionViewCell
                if path == indexPath {
                     selectPath = indexPath
                    item.isCheck = true
                } else {
                    item.isCheck = false
                }
                cell?.itemModel = item
            }
            
        } else { // 多选
            let model = choiceArr![indexPath.row]
            let cell = tableView.cellForRow(at: indexPath) as? QuestionViewCell
            if cellIndexPath != nil {
                if self.cellIndexPath!.contains(indexPath) {
                    self.cellIndexPath!.remove(indexPath)
                    model.isCheck = false
                } else {
                    self.cellIndexPath!.add(indexPath)
                    model.isCheck = true
                }
            } else {
                self.cellIndexPath?.add(indexPath)
                model.isCheck = true
            }
            cell?.itemModel = model
        }
    }
}


extension QuestionView {
    @objc func hideView() {
        self.removeFromSuperview()
    }
    
    @objc func bottomBtnAction(button:UIButton) {
        button.isSelected = !button.isSelected
    }
    
    
    func saveAnswer() {
        if !isAnswer {
            let questionModel = scriptQuestionList![selectedIndex]
            if selectPath != nil {
                let index = selectPath?.row
                let model = choiceArr![index!]
                user_script_answer_ids?.append(model.scriptAnswerId!)
                var dic = [:] as? [String : AnyObject]
                if answerList?.count != 0  {
                    
                    for (index, item) in answerList!.enumerated() {
                        if selectedIndex == index {
                            answerList?.remove(at: index)
                            break
                        }
                    }
                    
                    if user_script_answer_ids != nil {
                        dic!["script_question_id"] = questionModel.scriptQuestionId as AnyObject?
                        dic!["user_script_answer_ids"] = user_script_answer_ids as AnyObject
                        answerList?.append(dic!)
                    }
                    newArray?.append(selectPath as Any)
                } else {
                    if user_script_answer_ids != nil {
                        dic!["script_question_id"] = questionModel.scriptQuestionId as AnyObject?
                        dic!["user_script_answer_ids"] = user_script_answer_ids as AnyObject
                        answerList?.append(dic!)
                    }
                    newArray?.append(selectPath as Any)
                }
                
                subjectIndexPath.append([selectPath] as AnyObject)
                user_script_answer_ids = nil
            }
            
            if cellIndexPath != nil, cellIndexPath != []  {
                var dic = [:] as? [String : AnyObject]
                for itemIndexPath in cellIndexPath! {
                    let index = (itemIndexPath as! IndexPath).row
                    let model = choiceArr![index]
                    user_script_answer_ids?.append(model.scriptAnswerId!)
                }
                if answerList?.count != 0  {
                    for (index, item) in answerList!.enumerated() {
                        if selectedIndex == index {
                            answerList?.remove(at: index)
                            break
                        }
                    }
                    if user_script_answer_ids != nil {
                        dic!["script_question_id"] = questionModel.scriptQuestionId as AnyObject?
                        dic!["user_script_answer_ids"] = user_script_answer_ids as AnyObject
                        answerList?.append(dic!)
                        newArray?.append(cellIndexPath as Any)
                    }
                    
                } else {
                    if user_script_answer_ids != nil {
                        dic!["script_question_id"] = questionModel.scriptQuestionId as AnyObject?
                        dic!["user_script_answer_ids"] = user_script_answer_ids as AnyObject
                        answerList?.append(dic!)
                        newArray?.append(cellIndexPath as Any)
                    }
                }
                
                subjectIndexPath.append(cellIndexPath as AnyObject)
                user_script_answer_ids = nil
            }
            selectPath = nil
            cellIndexPath = []
        }
    }
    
    
    // 上一题
    @objc func previousBtnAction() {
        
        // 最后一道题
        if selectedIndex == scriptQuestionList!.count - 1 {
            saveAnswer()
        }
        
        if selectedIndex == 0 {
            return
        }
        selectedIndex -= 1
//        let pre = subjectIndexPath[selectedIndex]
        
//        tableView.reloadRows(at: pre as! [IndexPath], with: .automatic)
        
        
        
    }
    
    
    
    // 确定
    @objc func confirmBtnAction() {
       
        if !isAnswer {
            let questionModel = scriptQuestionList![selectedIndex]

        
            if selectPath != nil {
                let index = selectPath?.row
                let model = choiceArr![index!]
                

                user_script_answer_ids?.append(model.scriptAnswerId!)
                
                var dic = [:] as? [String : AnyObject]
                if answerList?.count != 0  {
                    
                    for (index, item) in answerList!.enumerated() {
                        if selectedIndex == index {
//                            dic = item
//                            if user_script_answer_ids != nil {
//                                dic!["script_question_id"] = questionModel.scriptQuestionId as AnyObject?
//                                dic!["user_script_answer_ids"] = user_script_answer_ids as AnyObject
//                            }
//                            answerList![index] = dic!
//
//                            newArray![index] = selectPath as Any
//
//                            break
                            
                            answerList?.remove(at: index)
                            break
                        }
                    }
                    

                    if user_script_answer_ids != nil {
                        dic!["script_question_id"] = questionModel.scriptQuestionId as AnyObject?
                        dic!["user_script_answer_ids"] = user_script_answer_ids as AnyObject
                        answerList?.append(dic!)
                    }
                    newArray?.append(selectPath as Any)

                } else {
                    if user_script_answer_ids != nil {
                        dic!["script_question_id"] = questionModel.scriptQuestionId as AnyObject?
                        dic!["user_script_answer_ids"] = user_script_answer_ids as AnyObject
                        answerList?.append(dic!)
                    }
                    newArray?.append(selectPath as Any)
                }
                
                
                subjectIndexPath.append([selectPath] as AnyObject)
                user_script_answer_ids = nil
            }
            
            if cellIndexPath != nil, cellIndexPath != []  {
                var dic = [:] as? [String : AnyObject]
                for itemIndexPath in cellIndexPath! {
                    let index = (itemIndexPath as! IndexPath).row
                    let model = choiceArr![index]
                    user_script_answer_ids?.append(model.scriptAnswerId!)
                }
                
                if answerList?.count != 0  {
                    
                    for (index, item) in answerList!.enumerated() {
                        if selectedIndex == index {
//                            dic = item
//                            if user_script_answer_ids != nil {
//                                dic!["script_question_id"] = questionModel.scriptQuestionId as AnyObject?
//                                dic!["user_script_answer_ids"] = user_script_answer_ids as AnyObject
//                            }
//                            answerList![index] = dic!
//                            newArray![index] = cellIndexPath as Any

                            answerList?.remove(at: index)
                            
                            break
                        }
                    }
                    if user_script_answer_ids != nil {
                        dic!["script_question_id"] = questionModel.scriptQuestionId as AnyObject?
                        dic!["user_script_answer_ids"] = user_script_answer_ids as AnyObject
                        answerList?.append(dic!)
                        newArray?.append(cellIndexPath as Any)

                    }
                    
                } else {
                    if user_script_answer_ids != nil {
                        dic!["script_question_id"] = questionModel.scriptQuestionId as AnyObject?
                        dic!["user_script_answer_ids"] = user_script_answer_ids as AnyObject
                        answerList?.append(dic!)
                        newArray?.append(cellIndexPath as Any)

                    }
                }
                
                
//                if answerList?.count != 0 && answerList![selectedIndex] != nil  {
//                    if user_script_answer_ids != nil {
//                        dic!["script_question_id"] = questionModel.scriptQuestionId as AnyObject?
//                        dic!["user_script_answer_ids"] = user_script_answer_ids as AnyObject
//                    }
//                    answerList![selectedIndex] = dic!
//
//                } else {
//                    if user_script_answer_ids != nil {
//                        dic!["script_question_id"] = questionModel.scriptQuestionId as AnyObject?
//                        dic!["user_script_answer_ids"] = user_script_answer_ids as AnyObject
//                        answerList?.append(dic!)
//                    }
//                }
                
                
                subjectIndexPath.append(cellIndexPath as AnyObject)
                user_script_answer_ids = nil
                

            }
            
            if selectedIndex == scriptQuestionList!.count-1 {
                // 提交
                gameVote()
                return
            }
            
            selectPath = nil
            cellIndexPath = []
            selectedIndex += 1
        } else {
            if selectedIndex == scriptQuestionList!.count-1 {
                return
            }
            selectedIndex += 1
        }

        
    }
    
    private func gameVote() {
                
        let script_question = getJSONStringFromArray(array: answerList! as NSArray)
        gameVoteRequest(room_id: room_id!, script_node_id: script_node_id!, script_question: script_question) {[weak self] (result, error) in
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            if resultDic["code"]!.isEqual(1) {
                self?.isAnswer = true
                showToastCenter(msg: "お答えは既に提出しました")
            }
        }
    
    }
    
}

extension QuestionView {
    
    //MARK: - 倒计时
    @objc func countDown() {
        timerCount -= 1
        let string = "カウントダウン：\(timerCount)s"
        let ranStr = String(timerCount)
        let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:string)
        let str = NSString(string: string)
        let theRange = str.range(of: ranStr)
        attrstring.addAttribute(NSAttributedString.Key.foregroundColor, value: HexColor(LightDarkGrayColor), range: theRange)
        countLabel.attributedText = attrstring
        
        if timerCount == 0 {
            // 进入下一个阶段
            timerCount = 0
        }
        
    }

}
