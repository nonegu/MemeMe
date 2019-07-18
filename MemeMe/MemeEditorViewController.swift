//
//  ViewController.swift
//  MemeMe
//
//  Created by Ender Güzel on 17.07.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var pickedImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navbar: UINavigationBar!
    
    // MARK: Properties
    let memeTextAttributes: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.strokeWidth : -3.0
    ]
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareButton.isEnabled = false
        cancelButton.isEnabled = true
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        setTextFieldAttributes(topTextField)
        setTextFieldAttributes(bottomTextField)
    }
    
    func setTextFieldAttributes(_ textField: UITextField) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeToKeyboardNotifications()
    }
    
    // MARK: Create UIActivityController
    @IBAction func sharePressed(_ sender: UIBarButtonItem) {
        
        let memedImage = generateMemedImage()
        let item = [memedImage]
        let activityController = UIActivityViewController(activityItems: item, applicationActivities: nil)
        // MARK: To avoid IPads from crushing, sourceView must be implemented
        activityController.popoverPresentationController?.sourceView = self.view
        present(activityController, animated: true)
        // MARK: Completion Handler to dismiss Activity Controlller
        activityController.completionWithItemsHandler = { (activity, success, items, error) in
            if success && error == nil {
                self.save(image: memedImage)
                if activity == .saveToCameraRoll {
                    // presenting an alert controller if the save is selected and successfull
                    let ac = UIAlertController(title: "Saved!", message: "Your meme has been saved to your photos.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
                activityController.dismiss(animated: true, completion: nil)
            } else if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        pickedImageView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        navBarButtonsEnabled(false)
        dismiss(animated: true, completion: nil)
    }
    
    func navBarButtonsEnabled(_ status: Bool) {
        shareButton.isEnabled = status
        cancelButton.isEnabled = status
    }
    
    // MARK: Image Picking Methods
    @IBAction func pickAnImageFromAlbum(_ sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        // apple suggests that imagepickers that uses library, should be presented as popovers
        imagePicker.modalPresentationStyle = .popover
        // defining the popover
        let ppc = imagePicker.popoverPresentationController
        ppc?.barButtonItem = sender
        ppc?.permittedArrowDirections = .any
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            pickedImageView.image = editedImage
        }
        
        dismiss(animated: true) {
            self.navBarButtonsEnabled(true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: create a meme object and save it in the global array
    func save(image: UIImage) {
        
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: pickedImageView.image!, memedImage: image)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        
        hideNavigationControllers(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideNavigationControllers(false)
        
        return memedImage
    }
    
    func hideNavigationControllers(_ status: Bool) {
        toolbar.isHidden = status
        navbar.isHidden = status
    }
    
    // MARK: TextField Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if topTextField.isEditing {
            if topTextField.text == "" {
                topTextField.text = "TOP"
            }
        } else {
            if bottomTextField.text == "" {
                bottomTextField.text = "BOTTOM"
            }
        }
        textField.resignFirstResponder()
        return true
    }
    

}

