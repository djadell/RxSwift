//
//  ViewModel.swift
//  GitHubInfo
//
//  Created by David Adell Echevarria on 31/08/2020.
//  Copyright © 2020 djadell. All rights reserved.
//

import RxSwift
import RxCocoa

class ViewModel {
    
    let searchText = BehaviorRelay(value: [])
    
    lazy var data: Driver<[Repository]> = {
        
        return Observable.of([Repository]()).asDriver(onErrorJustReturn: [])
    }()
}
