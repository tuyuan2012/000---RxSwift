//
//  RxSwiftNetWorkingVC.swift
//  001--RxSwift深入浅出
//
//  Created by Cooci on 2018/5/26.
//  Copyright © 2018年 Cooci. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxSwiftNetWorkingVC: UIViewController {

    let surStr = "https://www.douban.com/j/app/radio/channels"
    let disposeB = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(pushNewSearchVC))
        self.title = "RxSwiftNetWorkingVC"
        self.view.backgroundColor = UIColor.orange

//        textResponse()
//        textData()
        textJson()
    }

    @objc func pushNewSearchVC(){
        self.navigationController?.pushViewController(RxNewSearchVC(), animated: true)
    }
    
    func textJson(){
        let url = URL(string: surStr)
        URLSession.shared.rx.json(url: url!)
            .subscribe(onNext: { (jsonData) in
                print("******************************")
                print("jsonData = \(jsonData)\n")
            }, onError: { (error) in
                print("******************************")
                print(error)
            })
            .disposed(by: disposeB)
    }

    
    func textData(){
        let url = URL(string: surStr)
        
        URLSession.shared.rx.data(request: URLRequest(url: url!))
            .subscribe(onNext: { (data) in
                print("******************************")
                print("data = \(data)\n")

            }, onError: { (error) in
                print("******************************")
                print(error)
            })
            .disposed(by: disposeB)
    }
    
    func textResponse(){
        
        let url = URL(string: surStr)
        URLSession.shared.rx.response(request: URLRequest(url: url!))
            .subscribe(onNext: { (resp,data) in
                print("******************************")
                print("reponse = \(resp)\n")
                print("******************************")
                print("data = \(data)\n")

            }, onError: { (error) in
                print("******************************")
                print(error)
            })
            .disposed(by: disposeB)
        
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
