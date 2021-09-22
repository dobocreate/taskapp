//
//  Categoree.swift
//  taskapp
//
//  Created by 岸田展明 on 2021/09/21.
//

import RealmSwift

class Categoree: Object {
    
    // 管理用　ID。プライマリーキー
    @objc dynamic var id = 0
    
    // カテゴリー
    @objc dynamic var realm_categoree = ""
    
    // id をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        
        return "id"
    }
}
