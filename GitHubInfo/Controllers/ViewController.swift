//
//  ViewController.swift
//  GitHubInfo
//
//  Created by David Adell Echevarria on 31/08/2020.
//  Copyright © 2020 djadell. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchBar: UISearchBar { return searchController.searchBar }
    
    var viewModel = ViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        viewModel.data.drive(tableView.rx.items(cellIdentifier: "Cell")) { _, Repository, cell in
            cell.textLabel?.text = Repository.repoName
            cell.detailTextLabel?.text = Repository.repoURL
        }
        .disposed(by: disposeBag)
        
        searchText()
        viewModel.data.asDriver().map {"\($0.count) Repositories"}.drive(navigationItem.rx.title).disposed(by: disposeBag)
    }
    
    func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchBar.showsCancelButton = true
        searchBar.text = ""
        searchBar.placeholder = "Enter GitHub ID, ex: \"djadell\""
        searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
    
    func searchText(){
        searchBar.rx.text.orEmpty.bind(to: viewModel.searchText).disposed(by: disposeBag)
        tableView.reloadData()
    }
    
    //MARK: - searchBar Delegates
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchText()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        print("Reset")
    }
}

