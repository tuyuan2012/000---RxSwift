//
//  ViewController.swift
//  001--RxSwift深入浅出
//
//  Created by Cooci on 2018/5/26.
//  Copyright © 2018年 Cooci. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    let disposB = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testUI()
    }
    
    func testRxSwiftCreat(){
        //产生序列 -- Swift
        let ob = Observable<Any>.create { (anyObser) -> Disposable in
            print("**************")
            print(anyObser)
            //发送
            anyObser.onNext("我与世界只差一个你")
            anyObser.onError(MyError.errorB)
            anyObser.onCompleted()
            return Disposables.create()
        }
        
        //订阅
        ob.subscribe(onNext: { (signal) in
            print(signal)
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            print("完成了")
        }) {
            print("销毁了")
        }.disposed(by: disposB)

    }
    
    func testUI(){
        let textf = UITextField(frame: CGRect(x: 50, y: 50, width: 100, height: 30))
        textf.borderStyle = UITextBorderStyle.roundedRect
        self.view.addSubview(textf)
        
        let label = UILabel(frame: CGRect(x: 50, y: 90, width: 200, height: 30))
        label.textColor = UIColor.orange
        self.view.addSubview(label)
        
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: 50, y: 120, width: 100, height: 30)
        btn.setTitle("登录", for:UIControlState.normal)
        self.view.addSubview(btn)
        
        //rac_textsignal，封装成相应的序列类型
        let inputTFOb = textf.rx.text
            .orEmpty
            .asDriver() // error
            .throttle(0.5)//每个一段时间 才发送
    
        //绑定到label
        inputTFOb.map {"当前输入的是:\($0)"} //$0取第一个值
            .drive(label.rx.text) //绑定到label上去
            .dispose() //dispose回收，及时回收
        
        //绑定到Button.ieEnable
//        inputTFOb.map{$0.count>5} //闭包
//            .drive(btn.rx.isEnabled)
//            .disposed(by: disposB)
        
        //绑定到Button
//        inputTFOb.asObservable()
//            .bind(to: btn.rx.title()) //btn.rx.拓展
//            .disposed(by: disposB)
        
        //双向绑定操作符
//        let text = Variable("希望")
//        _ = inputTFOb.rx.textInput <-> text //<->进行双向绑定，对等绑定
        
        // oc -- rac
        // swift -- rxswift √
        //按钮点击事件
        //[weak self]  [own self]
        btn.rx.tap.subscribe(onNext: { [weak self]() in
            self?.view.backgroundColor = UIColor.orange
            print("点击了")
            self?.navigationController?.pushViewController(TableViewTestVC(), animated: true)
        })
        .disposed(by: disposB)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

enum MyError:Error {
    case errorA
    case errorB
    var errorType: String{
        switch self {
        case .errorA:
            return "this is A error"
        case .errorB:
            return "this is B error"
        }
    }
    
}



