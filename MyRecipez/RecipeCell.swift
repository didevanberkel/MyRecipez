//
//  RecipeCell.swift
//  MyRecipez
//
//  Created by Dide van Berkel on 19-03-16.
//  Copyright © 2016 Gary Grape Productions. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {
    
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    func configureCell(_ recipe: Recipe) {
        recipeTitle.text = recipe.title
        recipeImage.image = recipe.getRecipeImage()
    }
}
