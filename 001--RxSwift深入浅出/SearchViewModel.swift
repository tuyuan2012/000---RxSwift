//
//  SearchViewModel.swift
//  001--RxSwift深入浅出
//
//  Created by Cooci on 2018/5/26.
//  Copyright © 2018年 Cooci. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

struct Reposity {
    let name: String
    let url:  String
}

class SearchViewModel: NSObject {

    let searchText = Variable("")
    //外部观察的searchBar.text <->searchText ---> 请求searData
    lazy var searData: Driver<[Reposity]> = {
        return self.searchText.asObservable()
        .throttle(0.5, scheduler: MainScheduler.instance)
        .distinctUntilChanged()
        .flatMapLatest(SearchViewModel.ReponsFor)
        .asDriver(onErrorJustReturn: [])
    }()
    
    
    //请求网络
    static func ReponsFor(_ githunId:String) -> Observable<[Reposity]>{
        
        guard !githunId.isEmpty,let url = URL(string: "https://api.github.com/users/\(githunId)/repos") else {
            return Observable.just([])
        }
        return URLSession.shared.rx.json(url: url)
                    .retry()
                    .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                    .map(SearchViewModel.parse)
    }
    
    
    //请求的数据格式化
    static func parse(json:Any) ->[Reposity]{
        guard let items = json as? [[String:Any]] else { return [] }
        var resps = [Reposity]()
        items.forEach { (item) in
            guard let name = item["name"] as? String,let url = item["html_url"] as? String else{ return}
            resps.append(Reposity(name: name, url: url))
        }
        return resps
    }

}
