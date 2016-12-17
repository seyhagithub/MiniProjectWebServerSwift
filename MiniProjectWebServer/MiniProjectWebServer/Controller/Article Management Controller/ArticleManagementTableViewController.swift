//
//  ArticleManagementTableViewController.swift
//  MiniProjectWebServer
//
//  Created by Hiem Seyha on 12/11/16.
//  Copyright © 2016 seyha. All rights reserved.
//

import UIKit
import ChameleonFramework
import Kingfisher
import PKHUD

class ArticleManagementTableViewController: UITableViewController {
    
    // MARK: ================ Global Varialbe ===================

    var articles = [Article]()
    var pagination: Pagination!
    var articlePresenter:ArticlePresenter?
    var searchController = UISearchController()
    var shouldSearchArticle = false

    
    // MARK: ================ UI Oulet  ===================
    @IBOutlet var articleTableView: UITableView!
    
    @IBOutlet weak var detailButton: UIButton!
    
    // MARK: ================ Button Action ===================
    @IBAction func backToMainButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toDetailButton(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toDeletailArticleSegue", sender: nil)
    }
    
    @IBAction func toAddButton(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toAddEditSegue", sender: nil)
    }
    
    func refresh(sender:AnyObject)
    {
       
        articleTableView.refreshControl?.beginRefreshing()
       
       articlePresenter?.loadArticles(search: "", page: 1, limit: 15)
    

    }
    
    // MARK: ============== Main Function  ================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HUD.hide()
        
        //======= calling configuration Search Controller =======
        configureUISearchController()
        
        //=========== pull to refresh =============
        articleTableView.refreshControl?.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //HUD.show(.progress)
        
        articlePresenter = ArticlePresenter()
        articlePresenter?.articlePresenterInterface = self
        
        articlePresenter?.loadArticles(search: "", page: 1, limit: 15)
    }

    // MARK: ================== Table View =====================

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
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            if let article_id = self.articles[indexPath.row].id {
                
                self.articles.remove(at: indexPath.row)
                self.articleTableView.deleteRows(at: [indexPath], with: .fade)
                self.articlePresenter?.deleteArticle(article_id:article_id)
                
                
            }
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            
            self.performSegue(withIdentifier: "toAddEditSegue", sender: self.articles[indexPath.row])
        }
        
        edit.backgroundColor = FlatGreen()
        
        return [delete, edit]
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView == tableView {
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {

                Pagination()
            }
        }
    }
    
    
    //================= Pagination =================
    func Pagination(){
        
        print("===========Compare page witb total page==========")
        print(pagination.page!)
        print(pagination.total_pages!)
        
        if pagination.page! <= pagination.total_pages! {
            pagination.page  = pagination.page! + 1
            
            print(pagination.page!)
            articlePresenter?.loadArticles(search: "", page: pagination.page!, limit: 15)
        }
    }
    
    
    func checkPagination(articles: [Article]){

       if self.articles.isEmpty {
        
         self.articles = articles
      
       } else {
       
            self.articles = articles
            self.articles.append(contentsOf: articles)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDeletailArticleSegue" {

            
            if let destinationView = segue.destination as? DetailArticleViewController {
            
                if let indexPath = articleTableView.indexPathForSelectedRow {
                   
                    destinationView.article = articles[indexPath.row]
                    
                    print(articles[indexPath.row])
                }
            
            }
        }
        
        if segue.identifier == "toAddEditSegue" {
            
            let destinationView = segue.destination as! AddEditArticleViewController
                
            if sender != nil {
                
                print("==========> edit")
                
                let article = sender as! Article
                
                destinationView.article = article
                
            } else {
                
                print("==============>add")
            }
        }
    }
    
    
    // MARK: =============== Configuration =========================

    func configureUISearchController() {
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.titleView = self.searchController.searchBar
        
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.placeholder = "Search ..."
    
        self.searchController.searchBar.showsCancelButton = true
        self.searchController.searchBar.sizeToFit()
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.obscuresBackgroundDuringPresentation = false
        
    }
    
    func configureCell(cell: CustomCellArticle, indexPath: NSIndexPath){
        
        let article = articles[indexPath.row]
        cell.configureCell(article: article)
        
    }
    
}

extension ArticleManagementTableViewController: ArticlePresenterInterface, UISearchResultsUpdating, UISearchBarDelegate {
    
    // MARK: ================= SEARCHING ====================
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.isActive {
            
            print("================= search controller is active ==========")
            self.articles.removeAll(keepingCapacity: false)
            
            if !(searchController.searchBar.text?.isEmpty)! {
                
                articlePresenter?.loadArticles(search: searchController.searchBar.text!.lowercased(), page: 1, limit: 15)

            }
            
        }
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
       
          print("======== searchBarTextDidBeginEditing =========")
    }
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
         print("======== searchBarCancelButtonClicked =========")
         articlePresenter?.loadArticles(search: "", page: 1, limit: 15)
        
    }
    
    
    // MARK: ================== Notify Complete Action =================
    func completeRequestArticle(articles: [Article], pagination:Pagination) {
        
       articleTableView.refreshControl?.endRefreshing()
        
        if (self.refreshControl?.isRefreshing)! {
            
            self.articles = articles
        }
        
        self.pagination = pagination
        
       checkPagination(articles: articles)
       
        
        print("=============\(self.articles)========")
        
        DispatchQueue.main.async {
            
            HUD.hide()
            
            print(articles)
            self.articleTableView.reloadData()
        }
    }

    func deleteArticleComplete() {
        
        articlePresenter?.loadArticles(search: "", page: 1, limit: 15)
        

    }
  }

