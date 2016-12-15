//
//  ArticleManagementTableViewController.swift
//  MiniProjectWebServer
//
//  Created by Hiem Seyha on 12/11/16.
//  Copyright © 2016 seyha. All rights reserved.
//

import UIKit
import ChameleonFramework

class ArticleManagementTableViewController: UITableViewController {
    
    @IBOutlet var articleTableView: UITableView!
    
    @IBOutlet weak var detailButton: UIButton!
    
    @IBAction func toDetailButton(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toDeletailArticleSegue", sender: nil)
    }
    
    var articles = [Article]()
    
    var articlePresenter:ArticlePresenter?
    
    var searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        detailButton.backgroundColor = .clear
//        detailButton.layer.cornerRadius = 5
//        detailButton.layer.borderWidth = 1
//        detailButton.layer.borderColor = FlatGreen().cgColor
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        
        self.searchController.searchBar.sizeToFit()
        self.navigationItem.titleView = self.searchController.searchBar
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        
        
        articlePresenter = ArticlePresenter()
        
        articlePresenter?.articlePresenterInterface = self
        
        articlePresenter?.loadArticles(search: "", page: 1, limit: 15)
        
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
       return self.articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! CustomCellArticle
        
        if articles.count > 0 {
            
             configureCell(cell: cell,indexPath: indexPath as NSIndexPath)
        }
       
        
        return cell
            
        
    }
    
    
    func configureCell(cell: CustomCellArticle, indexPath: NSIndexPath){
        
        let article = articles[indexPath.row]
        cell.configureCell(article: article)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("segue")
        if segue.identifier == "toDeletailArticleSegue" {
            
            print("segue")
            
           let destinationView = segue.destination as! DetailArticleViewController
            
            if let indexPath = articleTableView.indexPathForSelectedRow {
               
                
                destinationView.article = articles[indexPath.row]
                
                print(articles[indexPath.row])
            }
        }
    }
    
}

extension ArticleManagementTableViewController: ArticlePresenterInterface, UISearchResultsUpdating {
    
    func completeRequestArticle(articles: [Article]) {
        
        self.articles = articles
        
        DispatchQueue.main.async {
            
            self.articleTableView.reloadData()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        
        if searchController.isActive {
            
            self.articles.removeAll(keepingCapacity: false)
            
            
            
            if !(searchController.searchBar.text?.isEmpty)! {
                
                articlePresenter?.loadArticles(search: searchController.searchBar.text!.lowercased(), page: 1, limit: 15)
                
            }
            
        }
        
    }
}

