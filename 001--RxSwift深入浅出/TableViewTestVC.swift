//
//  TableViewTestVC.swift
//  001--RxSwift深入浅出
//
//  Created by Cooci on 2018/5/26.
//  Copyright © 2018年 Cooci. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TableViewTestVC: UIViewController {

    let disposeBag = DisposeBag()
    var tableView : UITableView!
    let reuserId = "reuserId"

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
//        testUITableView()
        self.title = "一般的table"
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: MyTableViewCell.description())
        self.view.addSubview(tableView)
        
        let items = Observable.just(InfoViewModel().arr)
        // 架构模式 datasource
        // model --> UI
        items.bind(to: self.tableView.rx.items){(tb,row,model) -> UITableViewCell in
            
            let cell = tb.dequeueReusableCell(withIdentifier: MyTableViewCell.description()) as? MyTableViewCell
            cell?.titlteLabel?.text = model.despStr;
            cell?.nameLabel?.text = model.nameStr;
            return cell!
        }.disposed(by: disposeBag)

        //行操作
//        tableView.isEditing = true
        
        tableView.rx.modelSelected(DataModel.self).subscribe(onNext: { (model) in
            print(model)
        })
        .disposed(by: disposeBag)
        
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexpath in
            print("点击了 \(indexpath)")
            self?.navigationController?.pushViewController(SectionTableViewVC(), animated: true)
        })
            .disposed(by: disposeBag)
        
        
        tableView.rx.itemDeleted.subscribe(onNext: { (indexPath) in
            print("删除+++\(indexPath)")
        })
            .disposed(by: disposeBag)

        
        tableView.rx.itemMoved.subscribe(onNext: { (soureceIndex,desIndex) in
            print("从\(soureceIndex)移动到 \(desIndex)")
        })
            .disposed(by: disposeBag)

    }

    func testUITableView(){
        
//        tableView = UITableView(frame: self.view.bounds, style: .plain)
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: MyTableViewCell.description())
//        self.view.addSubview(tableView)

    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.description(), for: indexPath) as? MyTableViewCell
//        cell?.getvalue(titleStr: "\(indexPath.row)", nameStr: "  Cooci  \(indexPath.row)")
//        return cell!
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class MyTableViewCell: UITableViewCell {
    
    var titlteLabel:UILabel?
    var nameLabel:UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.titlteLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: self.contentView.bounds.height))
        self.contentView.addSubview(self.titlteLabel!)
        
        self.nameLabel = UILabel(frame: CGRect(x: self.titlteLabel!.bounds.maxX, y: 0, width: 100, height: self.contentView.bounds.height))
        self.contentView.addSubview(self.nameLabel!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getvalue(titleStr:String,nameStr:String){
        self.titlteLabel?.text = titleStr
        self.nameLabel?.text = nameStr
    }
    
}

