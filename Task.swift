//
//  Task.swift
//  taskapp
//
//  Created by 岩渕優児 on 2021/04/28.
//

import RealmSwift

class Task: Object {
    //管理用ID。プライマリーキー
    @objc dynamic var id = 0
    
    //タイトル
    @objc dynamic var title = ""
    
    //カテゴリー
    @objc dynamic var category = ""
    
    //内容
    @objc dynamic var contents = ""
    
    //日時
    @objc dynamic var date = Date()
    
    //idをプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }

}
    


