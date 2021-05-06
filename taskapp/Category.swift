//
//  Category.swift
//  taskapp
//
//  Created by 岩渕優児 on 2021/05/04.
//

import RealmSwift


class Category : Object {
    //管理用ID。プライマリーキー
    @objc dynamic var id = 0
    
    //カテゴリ
    @objc dynamic var categoryname = ""
    
    //idをプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}

