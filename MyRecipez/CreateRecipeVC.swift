//
//  CreateRecipeVC.swift
//  MyRecipez
//
//  Created by Dide van Berkel on 19-03-16.
//  Copyright © 2016 Gary Grape Productions. All rights reserved.
//

import UIKit
import CoreData

class CreateRecipeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var recipeTitle: UITextField!
    @IBOutlet weak var recipeIngredients: UITextField!
    @IBOutlet weak var recipeSteps: UITextField!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var addRecipeBtn: UIButton!
    @IBOutlet weak var addRecipeImgBtn: UIButton!
    
    var recipeTitleValueEdit: String!
    var recipeIngredientsValueEdit: String!
    var recipeStepsValueEdit: String!
    var recipeImageValueEdit: UIImage!
    
    var isInEditMode: Bool = false
    var imagePicker: UIImagePickerController!
    var indexRow: NSIndexPath!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        recipeImage.layer.cornerRadius = 5.0
        recipeImage.clipsToBounds = true
        
        if isInEditMode == true {
            addRecipeBtn.setTitle("Save", forState: .Normal)
            recipeTitle.text = recipeTitleValueEdit
            recipeSteps.text = recipeStepsValueEdit
            recipeIngredients.text = recipeIngredientsValueEdit
            recipeImage.image = recipeImageValueEdit
            addRecipeImgBtn.setTitle("Change Image", forState: .Normal)
        } else {
            addRecipeBtn.setTitle("Create recipe", forState: .Normal)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        recipeImage.image = image
    }
    
    @IBAction func addImage(sender: AnyObject!) {
        let alertController = UIAlertController(title: "Choose Image", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Destructive, handler: {(alert :UIAlertAction!) in
            self.openCamera()
        })
        alertController.addAction(cameraAction)
        
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
            self.openGallery()
        })
        alertController.addAction(galleryAction)
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = self.recipeImage.frame
        alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.Any
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.allowsEditing = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    
    @IBAction func createRecipe(sender: AnyObject!) {
        if isInEditMode == false {
            if let title = recipeTitle.text where title != "" {
                let app = UIApplication.sharedApplication().delegate as! AppDelegate
                let context = app.managedObjectContext
                let entity = NSEntityDescription.entityForName("Recipe", inManagedObjectContext: context)!
                let recipe = Recipe(entity: entity, insertIntoManagedObjectContext: context)
                recipe.title = title
                recipe.ingredients = recipeIngredients.text
                recipe.steps = recipeSteps.text
                recipe.setRecipeImage(recipeImage.image!)
                context.insertObject(recipe)
            
                do {
                    try context.save()
                } catch {
                    print("Could not save recipe")
                }
                self.navigationController?.popViewControllerAnimated(true)
            }
        } else if isInEditMode == true {
            if let title = recipeTitle.text where title != "" {
                let app = UIApplication.sharedApplication().delegate as! AppDelegate
                let context = app.managedObjectContext
                
                let fetchRequest = NSFetchRequest(entityName: "Recipe")
                do {
                    let results = try context.executeFetchRequest(fetchRequest)
                    let updatedRecipe = results[indexRow.row] as! NSManagedObject
                        updatedRecipe.setValue(recipeTitle.text, forKey: "title")
                        updatedRecipe.setValue(recipeIngredients.text, forKey: "ingredients")
                        updatedRecipe.setValue(recipeSteps.text, forKey: "steps")
                        let img = recipeImage.image
                        let data = UIImagePNGRepresentation(img!)
                        updatedRecipe.setValue(data, forKey: "image")
                    do {
                        try updatedRecipe.managedObjectContext?.save()
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    } catch {
                        let saveError = error as NSError
                        print(saveError)
                    }
                } catch let err as NSError {
                    print(err.debugDescription)
                }
            }
            isInEditMode = false
        }
    }
}
