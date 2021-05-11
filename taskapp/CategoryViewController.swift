//
//  CategoryMenuViewController.swift
//  taskapp
//
//  Created by 岩渕優児 on 2021/05/05.
//

import UIKit
import RealmSwift

class CategoryViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate {

    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    var categoryList: Results<Category>!
    
    let realm = try! Realm()
    
    @IBAction func tapAddButton(_ sender: Any) {
            let instancedCategory:Category = Category()
            let allCategories = realm.objects(Category.self)
            if allCategories.count != 0 {
                  instancedCategory.id = allCategories.max(ofProperty: "id")! + 1
              }
        
            instancedCategory.category = self.categoryTextField.text!

            let realmInstance = try! Realm()
            try! realmInstance.write{
                realmInstance.add(instancedCategory)
                self.categoryTableView.reloadData()
            }
        }
    
    override func viewDidLoad() {
            super.viewDidLoad()
            // UITableViewDataSource を self に設定
            self.categoryTableView.dataSource = self
            // UITableViewDelegate を self に設定
            self.categoryTableView.delegate = self

            let realmInstance = try! Realm()
            self.categoryList = realmInstance.objects(Category.self)
            self.categoryTableView.reloadData()
        }
    
        
    }

    
    extension CategoryViewController: UITableViewDataSource{

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.categoryList.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let testCell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "testCell")!
            let category: Category = self.categoryList[(indexPath as NSIndexPath).row]
            testCell.textLabel?.text = category.category
            return testCell
        }

        // テーブルビューの編集を許可
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }

        // テーブルビューのセルとデータを削除
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == UITableViewCell.EditingStyle.delete {
                // データを削除
                let realmInstance = try! Realm()
                try! realmInstance.write {
                    realmInstance.delete(categoryList[indexPath.row])
                }
                // セルを削除
                tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            }
        }

        // テーブルビューのセルをクリックしたら、アラートコントローラを表示する処理
        func showAlertController(_ indexPath: IndexPath){
            let alertController: UIAlertController = UIAlertController(title: "\(String(indexPath.row + 1))番目のカテゴリーを編集", message: categoryList[indexPath.row].category, preferredStyle: .alert)
            // アラートコントローラにテキストフィールドを表示 テキストフィールドには入力された情報を表示させておく処理
            alertController.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.text = self.categoryList[indexPath.row].category})
            // アラートコントローラに"OK"ボタンを表示 "OK"ボタンをクリックした際に、テキストフィールドに入力した文字で更新する処理を実装
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                (action) -> Void in self.updateAlertControllerText(alertController,indexPath)
            }))
            // アラートコントローラに"Cancel"ボタンを表示
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("セル\(indexPath)が選択されました")
            showAlertController(indexPath)
        }

        // "OK"ボタンをクリックした際に、テキストフィールドに入力した文字で更新
        func updateAlertControllerText(_ alertcontroller:UIAlertController, _ indexPath: IndexPath) {
            // guard を利用して、nil チェック
            guard let textFields = alertcontroller.textFields else {return}
            guard let text = textFields[0].text else {return}

            // UIAlertController に入力された文字をコンソールに出力
            print(text)

            // Realm に保存したデータを UIAlertController に入力されたデータで更新
            let realmInstance = try! Realm()
            try! realmInstance.write{
                categoryList[indexPath.row].category = text
            }
            self.categoryTableView.reloadData()
        }
        
        
        
        
    }

    
    
    

  
