//
//  CreateRecipeVC.swift
//  MyRecipez
//
//  Created by Dide van Berkel on 19-03-16.
//  Copyright © 2016 Gary Grape Productions. All rights reserved.
//

import UIKit
import CoreData

class CreateRecipeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
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
    var indexRow: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeTitle.delegate = self
        recipeIngredients.delegate = self
        recipeSteps.delegate = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        recipeImage.layer.cornerRadius = 5.0
        recipeImage.clipsToBounds = true
        
        if isInEditMode == true {
            addRecipeBtn.setTitle("Save", for: UIControlState())
            recipeTitle.text = recipeTitleValueEdit
            recipeSteps.text = recipeStepsValueEdit
            recipeIngredients.text = recipeIngredientsValueEdit
            recipeImage.image = recipeImageValueEdit
            addRecipeImgBtn.setTitle("Change Image", for: UIControlState())
        } else {
            addRecipeBtn.setTitle("Create recipe", for: UIControlState())
        }
        
        self.hideKeyboard()
        
        if let font = UIFont(name: "Marker Felt", size: 15) {
            self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName:font], for: .normal)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismiss(animated: true, completion: nil)
        recipeImage.image = image
    }
    
    @IBAction func addImage(_ sender: AnyObject!) {
        let alertController = UIAlertController(title: "Choose Image", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.destructive, handler: {(alert :UIAlertAction!) in
            self.openCamera()
        })
        alertController.addAction(cameraAction)
        
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
            self.openGallery()
        })
        alertController.addAction(galleryAction)
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = self.recipeImage.frame
        alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        
        present(alertController, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func createRecipe(_ sender: AnyObject!) {
        if isInEditMode == false {
            if let title = recipeTitle.text, title != "" {
                let app = UIApplication.shared.delegate as! AppDelegate
                let context = app.managedObjectContext
                let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: context)!
                let recipe = Recipe(entity: entity, insertInto: context)
                recipe.title = title
                recipe.ingredients = recipeIngredients.text
                recipe.steps = recipeSteps.text
                recipe.setRecipeImage(recipeImage.image!)
                context.insert(recipe)
                
                do {
                    try context.save()
                } catch {
                    print("Could not save recipe")
                }
                self.navigationController?.popViewController(animated: true)
            }
        } else if isInEditMode == true {
            if let title = recipeTitle.text, title != "" {
                let app = UIApplication.shared.delegate as! AppDelegate
                let context = app.managedObjectContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
                do {
                    let results = try context.fetch(fetchRequest)
                    let updatedRecipe = results[indexRow.row] as! NSManagedObject
                    updatedRecipe.setValue(recipeTitle.text, forKey: "title")
                    updatedRecipe.setValue(recipeIngredients.text, forKey: "ingredients")
                    updatedRecipe.setValue(recipeSteps.text, forKey: "steps")
                    let img = recipeImage.image
                    let data = UIImagePNGRepresentation(img!)
                    updatedRecipe.setValue(data, forKey: "image")
                    do {
                        try updatedRecipe.managedObjectContext?.save()
                        self.navigationController?.popToRootViewController(animated: true)
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
