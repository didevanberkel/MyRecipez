//
//  ViewController.swift
//  MyRecipez
//
//  Created by Dide van Berkel on 17-03-16.
//  Copyright © 2016 Gary Grape Productions. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var recipes = [Recipe]()
    var mySelection: Int?
    var searchController: UISearchController!
    var searchResult: [Recipe] = []
    var indexRow: Int!
    
    var banner: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search recipe"
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self;
        
        loadBanner()
        
        self.hideKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchAndSetResults()
        tableView.reloadData()
    }
    
    func loadBanner() {
        banner = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        banner.adUnitID = "ca-app-pub-3274698501837481/3467823252"
        banner.rootViewController = self
        let request: GADRequest = GADRequest()
        banner.load(request)
        banner.frame = CGRect(x: 0, y: view.bounds.height - banner.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
        self.view.addSubview(banner)
    }
    
    func fetchAndSetResults(){
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
        do {
            let results = try context.fetch(fetchRequest)
            self.recipes = results as! [Recipe]
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell") as? RecipeCell {
            let recipeList = searchController.isActive ? searchResult[indexPath.row] : recipes[indexPath.row]
            let recipe = recipeList
            cell.configureCell(recipe)
            return cell
        } else {
            return RecipeCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResult.count
        } else {
            return recipes.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mySelection = indexPath.row
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "RecipeDetail") {
            if let indexPath = tableView.indexPathForSelectedRow {
                let recipeDetailController = segue.destination as! RecipeDetailVC
                let recipe = searchController.isActive ? searchResult[indexPath.row] : recipes[indexPath.row]
                recipeDetailController.configureRecipeData(recipe)
                
                let indexPath = tableView.indexPathForSelectedRow
                recipeDetailController.indexRow = indexPath!
            }
        }
        searchController.isActive = false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            let app = UIApplication.shared.delegate as! AppDelegate
            let context = app.managedObjectContext
            
            context.delete(recipes[indexPath.row])
            app.saveContext()
            
            recipes.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchController.searchBar.text {
            if searchText != "" {
                filterContent(searchText)
                tableView.reloadData()
            } else {
                searchResult = recipes
                tableView.reloadData()
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func filterContent(_ searchText: String) {
        searchResult = recipes.filter({ (recipe: Recipe) -> Bool in
            let titleMatch = recipe.title?.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            let ingredientsMatch = recipe.ingredients?.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return titleMatch != nil || ingredientsMatch != nil
        })
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.endEditing(true)
    }
    
}

