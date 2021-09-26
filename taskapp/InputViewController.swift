//
//  InputViewController.swift
//  taskapp
//
//  Created by 岸田展明 on 2021/09/19.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoreePicker: UIPickerView!
    

    @IBOutlet weak var categoree: UIPickerView!
    
    let realm = try! Realm()
    var task: Task!
    
    // Picker
    var dataList2 = try! Realm().objects(Categoree.self).sorted(byKeyPath: "id", ascending: true)
    
    var categoree_label:String = ""     // 選択したカテゴリを代入する変数
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Picker Delegateの設定
        categoree.delegate = self
        categoree.dataSource = self
        
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        
        self.view.addGestureRecognizer(tapGesture)

        titleTextField.text = task.title
        contentsTextView.text = task.contents
        
        datePicker.date = task.date

    }
    
    // 入力画面から戻ってきた時に TableView を更新させる
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // CategoreePickerを更新する
        dataList2 = try! Realm().objects(Categoree.self)
        categoreePicker.reloadAllComponents()
    }
    

    // Picker categoree
    // 列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    // 行数、リストの数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return dataList2.count
    }
    
    // 最初の表示
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return dataList2[row].realm_categoree
    }
    
    // Rowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        categoree_label = dataList2[row].realm_categoree
        
        print("カテゴリー数：\(dataList2.count)")
    }
    
    
    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    // viewが表示されないくなる直前に実行される
    override func viewWillDisappear(_ animated: Bool) {
        
       try! realm.write {
        
        self.task.title = self.titleTextField.text!
        self.task.contents = self.contentsTextView.text
        self.task.cateGoree = categoree_label
        self.task.date = self.datePicker.date
        self.realm.add(self.task, update: .modified)
       }

        setNotification(task: task)
        
       super.viewWillDisappear(animated)
    }
    
    func setNotification(task: Task) {
        
        let content = UNMutableNotificationContent()
        
        // タイトルと内容を設定(中身がない場合メッセージ無しで音だけの通知になるので「(xxなし)」を表示する)
        if task.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        if task.contents == "" {
            content.body = "(内容なし)"
        } else {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default

        // ローカル通知が発動するtrigger（日付マッチ）を作成
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        // identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）
        let request = UNNotificationRequest(identifier: String(task.id), content: content, trigger: trigger)

        // ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録 OK")  // error が nil ならローカル通知の登録に成功したと表示します。errorが存在すればerrorを表示します。
        }

        // 未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/---------------")
                print(request)
                print("---------------/")
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
