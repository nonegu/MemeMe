//
//  ViewController.swift
//  MemeMe
//
//  Created by Ender Güzel on 17.07.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var pickedImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var navBarBackgroundImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var itemToEdit: Int?
    
    let memeTextAttributes: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.strokeWidth : -3.0
    ]
    
    // MARK: to hide the status bar, info.plist also needs to be updated
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    // MARK: Lifetime Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarButtonsEnabled(false)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        setTextFieldAttributes(topTextField)
        setTextFieldAttributes(bottomTextField)
        self.scrollView.minimumZoomScale = 0.2
        self.scrollView.maximumZoomScale = 5.0
        self.scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let itemToEdit = itemToEdit {
            tabBarController?.tabBar.isHidden = true
            navigationController?.navigationBar.isHidden = true
            cancelButton.title = "Done"
            setUpItemToEdit(itemToEdit)
        }
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeToKeyboardNotifications()
    }
    
    func setTextFieldAttributes(_ textField: UITextField) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    // MARK: ScrollView Zoom & Pan Functionality
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.pickedImageView
    }
    
    // MARK: Setting Up the Meme Editor for Editing
    func setUpItemToEdit(_ itemToEdit: Int) {
        let memeToEdit = appDelegate.memes[itemToEdit]
        pickedImageView.image = memeToEdit.originalImage
        pickedImageView.contentMode = .scaleAspectFit
        topTextField.text = memeToEdit.topText
        bottomTextField.text = memeToEdit.bottomText
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
                self.dismiss(animated: true, completion: nil)
            } else if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    // MARK: NavBar Buttons' Methods
    // MARK: The left BarButtonItem will rename to "Done" in editing mode.
    @IBAction func cancelOrDonePressed(_ sender: UIBarButtonItem) {
        if itemToEdit != nil {
            saveEditedImage()
            navigationController?.navigationBar.isHidden = false
            tabBarController?.tabBar.isHidden = false
            navigationController?.popToRootViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func refreshPressed(_ sender: Any) {
        if let itemToEdit = itemToEdit {
            setUpItemToEdit(itemToEdit)
        } else {
            pickedImageView.image = nil
            pickedImageView.backgroundColor = UIColor.lightGray
            topTextField.text = "TOP"
            bottomTextField.text = "BOTTOM"
        }
        navBarButtonsEnabled(false)
    }
    
    func navBarButtonsEnabled(_ status: Bool) {
        shareButton.isEnabled = status
        refreshButton.isEnabled = status
    }
    
    //MARK: Save Function to save the edited image.
    func saveEditedImage() {
        
        let editedMeme = Meme(topText: (topTextField.text)!, bottomText: bottomTextField.text!, originalImage: pickedImageView.image!, memedImage: generateMemedImage())
        appDelegate.memes[itemToEdit!] = editedMeme
    }
    
    // MARK: Image Picking Methods
    @IBAction func pickAnImageFromAlbum(_ sender: UIBarButtonItem) {
        
        pickAnImage(source: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: UIBarButtonItem) {
        
        pickAnImage(source: .camera)
    }
    
    func pickAnImage(source: UIImagePickerController.SourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = source
        if source == .photoLibrary {
            // apple suggests that imagepickers that uses library, should be presented as popovers
            imagePicker.modalPresentationStyle = .popover
            // defining the popover
            let ppc = imagePicker.popoverPresentationController
            ppc?.barButtonItem = albumButton
            ppc?.permittedArrowDirections = .any
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            pickedImageView.backgroundColor = UIColor.white
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
        
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: pickedImageView.image!, memedImage: image)
        
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        
        hideNavigationControllers(true)
        
        // Render view to an image
        let memedImage = view.asImage(frame: scrollView.frame)
        
        hideNavigationControllers(false)
        
        return memedImage
    }
    
    func hideNavigationControllers(_ status: Bool) {
        
            toolbar.isHidden = status
            navbar.isHidden = status
            navBarBackgroundImageView.isHidden = status
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

extension UIView {
    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage(frame: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: frame)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
