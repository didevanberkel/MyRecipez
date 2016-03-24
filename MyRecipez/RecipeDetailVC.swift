//
//  RecipeDetail.swift
//  MyRecipez
//
//  Created by Dide van Berkel on 19-03-16.
//  Copyright © 2016 Gary Grape Productions. All rights reserved.
//

import UIKit
import CoreData

class RecipeDetailVC: UIViewController {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeIngredients: UILabel!
    @IBOutlet weak var recipeSteps: UILabel!
    
    var recipeTitleValue: String!
    var recipeIngredientsValue: String!
    var recipeStepsValue: String!
    var recipeImageValue: UIImage!
    
    override func viewDidLoad() {
        recipeTitle.text = recipeTitleValue
        recipeIngredients.text = recipeIngredientsValue
        recipeSteps.text = recipeStepsValue
        recipeImage.image = recipeImageValue
        recipeImage.layer.cornerRadius = 5.0
        recipeImage.clipsToBounds = true
    }
    
    func configureRecipeData(recipe: Recipe) {
        recipeTitleValue = recipe.title!
        recipeIngredientsValue = recipe.ingredients!
        recipeStepsValue = recipe.steps!
        recipeImageValue = recipe.getRecipeImage()
    }
}

