//
//  CommentsViewCell.swift
//  Murder
//
//  Created by 马滕亚 on 2020/10/27.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit


let CommentsCellId = "CommentsCellId"

class CommentsViewCell: UITableViewCell {
    
    private var myTableView: UITableView?

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
         setUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension CommentsViewCell {
    private func setUI() {
        if myTableView == nil {
//            myTableView = UITableView(frame: CGRect.zero)
            myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: 80))
            myTableView?.delegate = self
            myTableView?.dataSource = self
            myTableView?.register(UINib.init(nibName: "CommentsCell", bundle: nil), forCellReuseIdentifier: CommentsCellId)
            self.contentView.addSubview(myTableView!)
        }
    }
    
    
}

extension CommentsViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentsCellId, for: indexPath) as! CommentsCell
        cell.selectionStyle = .none
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}
