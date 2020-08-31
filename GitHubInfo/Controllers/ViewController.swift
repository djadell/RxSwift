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

class ViewController: UIViewController {
    
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
        
    }
    
    func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchBar.showsCancelButton = true
        searchBar.text = "NavdeepSinghh"
        searchBar.placeholder = "Enter GitHub ID, e.g., \"NavdeepSinghh\""
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
}

