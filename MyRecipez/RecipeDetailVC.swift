//
//  RecipeDetail.swift
//  MyRecipez
//
//  Created by Dide van Berkel on 19-03-16.
//  Copyright © 2016 Gary Grape Productions. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

class RecipeDetailVC: UIViewController {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeIngredients: UITextView!
    @IBOutlet weak var recipeSteps: UITextView!
    
    var recipeTitleValue: String!
    var recipeIngredientsValue: String!
    var recipeStepsValue: String!
    var recipeImageValue: UIImage!
    
    var indexRow: NSIndexPath!
    var recipes = [Recipe]()
    
    var banner: GADBannerView!
    
    override func viewDidLoad() {
        recipeTitle.text = recipeTitleValue
        recipeIngredients.text = recipeIngredientsValue
        recipeSteps.text = recipeStepsValue
        recipeImage.image = recipeImageValue
        recipeImage.layer.cornerRadius = 5.0
        recipeImage.clipsToBounds = true
        
        loadBanner()
    }
    
    func loadBanner() {
        banner = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        banner.adUnitID = "ca-app-pub-3274698501837481/3467823252"
        banner.rootViewController = self
        let request: GADRequest = GADRequest()
        banner.loadRequest(request)
        banner.frame = CGRectMake(0, view.bounds.height - banner.frame.size.height, banner.frame.size.width, banner.frame.size.height)
        self.view.addSubview(banner)
    }
    
    func configureRecipeData(recipe: Recipe) {
        recipeTitleValue = recipe.title!
        recipeIngredientsValue = recipe.ingredients!
        recipeStepsValue = recipe.steps!
        recipeImageValue = recipe.getRecipeImage()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "RecipeEdit") {
            let recipeEditController: CreateRecipeVC = segue.destinationViewController as! CreateRecipeVC
                recipeEditController.recipeTitleValueEdit = recipeTitleValue
                recipeEditController.recipeIngredientsValueEdit = recipeIngredientsValue
                recipeEditController.recipeStepsValueEdit = recipeStepsValue
                recipeEditController.recipeImageValueEdit = recipeImageValue
                recipeEditController.indexRow = indexRow
                recipeEditController.isInEditMode = true
        }
    }
}

