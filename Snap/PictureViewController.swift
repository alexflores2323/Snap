//
//  PictureViewController.swift
//  Snap
//
//  Created by Logan Caracci on 2/19/17.
//  Copyright © 2017 Logan Caracci. All rights reserved.
//

import UIKit
import Firebase

class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var uuid = NSUUID().uuidString
    var imagepicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagepicker.delegate = self
        nextButton.isEnabled = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        
        
        imageView.backgroundColor = UIColor.clear
        nextButton.isEnabled = true
        imagepicker.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    @IBAction func cameraTapped(_ sender: Any) {
        
        imagepicker.sourceType = .camera
        imagepicker.allowsEditing = false
        
        present(imagepicker, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func nextTapped(_ sender: Any) {
        
        nextButton.isEnabled = false
        
        let imagesFolder =
            FIRStorage.storage().reference().child("images")
        
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.1)!
        
        
        imagesFolder.child("\(uuid).jpg").put(imageData, metadata: nil, completion: {(mededata, error) in
            print("we tried so hard")
            if error != nil {
                print("we fucked up\(error)")
            } else {
                
                
                print(mededata?.downloadURL())
                
                self.performSegue(withIdentifier: "selectUser", sender: mededata?.downloadURL()!.absoluteString)
                
            }

        })

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let nextVC = segue.destination as! SelectFriendViewController
        nextVC.imageURL = sender as! String
        nextVC.descrip = descriptionTextField.text!
        nextVC.uuid = uuid
    

    }
}
