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
    
    let searchText = BehaviorRelay(value: "")
    
    lazy var data: Driver<[Repository]> = {
        
        return self.searchText.asObservable()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest(ViewModel.repositoriesBy)
            .asDriver(onErrorJustReturn: [])
    }()
    
    static func repositoriesBy(_ githubID: String) -> Observable<[Repository]> {
        guard !githubID.isEmpty,
            let url = URL(string: baseURL+usersExtensionURL+"/\(githubID)"+repositoryExtensionURL) else {
                return Observable.just([])
        }
        #if DEBUG
            print("URL: \(url)")
        #endif
        
        return URLSession.shared.rx.json(url: url)
            .retry(3)
            //.catchErrorJustReturn([])
            .map(parse)
    }
    
    static func parse(json: Any) -> [Repository] {
        guard let items = json as? [[String: Any]]  else {
            return []
        }
        
        var repositories = [Repository]()
        
        items.forEach{
            guard let repoName = $0["name"] as? String,
                let repoURL = $0["html_url"] as? String else {
                    return
            }
            repositories.append(Repository(repoName: repoName, repoURL: repoURL))
        }
        return repositories
    }
}
