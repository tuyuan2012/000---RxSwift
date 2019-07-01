//
//  RxNewSearchVC.swift
//  001--RxSwift深入浅出
//
//  Created by Cooci on 2018/5/26.
//  Copyright © 2018年 Cooci. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class RxNewSearchVC: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchBar: UISearchBar{return searchController.searchBar}
    var myTableView:UITableView!
    let reuserId = "cell"
    let disposeB = DisposeBag()
    var shouldShowSearchResults = false //是否显示搜索结果
    var vm = SearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "搜索界面"
        self.view.backgroundColor = UIColor.orange
        myTableView = UITableView(frame: self.view.bounds, style: .plain)
        myTableView.register(SectionTableCell.self, forCellReuseIdentifier: SectionTableCell.description())
        self.view.addSubview(myTableView)
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "请输入你要搜索的内容"
        searchBar.showsCancelButton = true
        myTableView.tableHeaderView = searchController.searchBar
//        definesPresentationContext = true
        
        // 双向绑定 
        self.vm.searData.drive(myTableView.rx.items){ (tb,row,model) -> UITableViewCell in
            
            let cell = tb.dequeueReusableCell(withIdentifier: SectionTableCell.description()) as? SectionTableCell
            cell?.textLabel?.text = model.name;
            cell?.detailTextLabel?.text = model.url;
            return cell!
            }
            .disposed(by: disposeB)
        
        // kvo
        searchBar.rx.text.orEmpty
            .bind(to: vm.searchText)
            .disposed(by: disposeB)
        
        myTableView.rx.didEndDecelerating
            .subscribe(onNext: { () in
                self.searchBar.endEditing(true)
            })
            .disposed(by: disposeB)

        vm.searData.asDriver()
            .map {[weak self] (resp) -> String in
                return "\(String(describing: self?.searchBar.text))有resp\(resp.count)"
        }
            .drive(navigationItem.rx.title)
            .disposed(by: disposeB)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
