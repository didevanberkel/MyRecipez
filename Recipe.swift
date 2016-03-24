//
//  Recipe.swift
//  MyRecipez
//
//  Created by Dide van Berkel on 19-03-16.
//  Copyright © 2016 Gary Grape Productions. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Recipe: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    func setRecipeImage(img: UIImage) {
        let data = UIImagePNGRepresentation(img)
        self.image = data
    }
    
    func getRecipeImage() -> UIImage {
        let img = UIImage(data: self.image!)!
        return img
    }
}
