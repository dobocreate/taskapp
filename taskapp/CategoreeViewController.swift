//
//  CategoreeViewController.swift
//  taskapp
//
//  Created by 岸田展明 on 2021/09/21.
//

import UIKit
import RealmSwift

class CategoreeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var CateGoreeView: UITableView!
    @IBOutlet weak var CategoreeTextField: UITextField!
    
    // Realmインスタンスを取得する
    let realm2 = try! Realm()
    


    // DB内のタスクが格納されるリスト。
    // idの近い順でソート：昇順
    // 以降内容をアップデートするとリスト内は自動的に更新される。
    // クラスを指定して、idでソートした一覧を取得する。
    var categoreeArray = try! Realm().objects(Categoree.self).sorted(byKeyPath: "id", ascending: true)
    
    
    // 追加ボタンがプッシュされたときに実行される
    @IBAction func add_categoree(_ sender: Any) {
        
        // Categoreeインスタンスを取得する
        let addCategoree: Categoree! = Categoree()
        
        let all_Categoree = realm2.objects(Categoree.self)
        
        if all_Categoree.count != 0 {
            
            addCategoree.id = all_Categoree.max(ofProperty: "id")! + 1
        }
        
        try! realm2.write {

            addCategoree.realm_categoree = self.CategoreeTextField.text!
            
            self.realm2.add(addCategoree, update: .modified)
            
            CateGoreeView.reloadData()
        }
        
    }
    
    // 削除ボタンがプッシュされたときに実行される
    @IBAction func delete_categoree(_ sender: Any) {
        
        let results = realm2.objects(Categoree.self).filter("realm_categoree == %@", CategoreeTextField.text!)
        
        // データの削除
        try! realm2.write {
            
            realm2.delete(results)
            
            CateGoreeView.reloadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        CateGoreeView.delegate = self
        CateGoreeView.dataSource = self
        
    }
    
    
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoreeArray.count
    }

    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能な cell を得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Cellに値（カテゴリー）を設定する
        let categoree = categoreeArray[indexPath.row]
        
        cell.textLabel?.text = categoree.realm_categoree
        
        return cell
    }

    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let categoree2 = categoreeArray[indexPath.row]
        
        CategoreeTextField.text = categoree2.realm_categoree
    }

    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }

    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            try! realm2.write {
                
                self.realm2.delete(self.categoreeArray[indexPath.row])
                tableView.deleteRows(at:[indexPath], with: .fade)
            }
        }
    }
    
    
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
