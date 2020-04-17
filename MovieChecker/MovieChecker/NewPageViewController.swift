//
//  NewPageViewController.swift
//  MovieChecker
//
//  Created by user169883 on 4/15/20.
//  Copyright © 2020 user169883. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class NewPageViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameTxt: UITextField!
    
    @IBOutlet weak var itemTypePicker: UIPickerView!
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var changeImageBtn: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var itemType = ""
    var changedImage = false
    var newImage: URL? = nil
    
    let storageRef = Storage.storage().reference()
    let firestoreRef = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+100)
        
        // Connect data:
        self.itemTypePicker.delegate = self
        self.itemTypePicker.dataSource = self
        
        self.nameTxt.delegate = self
    }
    
    @IBAction func saveChanges(_ sender: UIButton) {
        if (nameTxt.text == "") {
            showAlert(message: "You must specify a name for the " + itemType)
            return
        }
        
        var newItem = [
            "name": nameTxt.text!,
            "userId": user!.uid,
            "image": ""
        ]
        let collection = itemType == "Movie" ? "movies" : "series"
        
        if (changedImage) {
            let imageName = user!.uid + "_" + String(NSDate().timeIntervalSince1970) + ".jpg"
            uploadImage(imageName: imageName)
            newItem.updateValue("images/" + imageName, forKey: "image")
        }
        
        saveToFirebase(collection, newItem)
        showToast(message: "The " + itemType + " has been successfully saved")
        redirectToHomeTab()
    }
    
    @IBAction func changeImage(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){

            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    private func redirectToHomeTab() {
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let mainTabBarController = mainStoryboard.instantiateViewController(withIdentifier: "mainTabBarController") as? MainTabBarController else {
            return
        }
        
        mainTabBarController.selectedIndex = 0
        present(mainTabBarController, animated: true, completion: nil)
    }
    
    private func saveToFirebase(_ collection: String, _ newItem: [String : String]) {
        firestoreRef.collection(collection).addDocument(data: newItem) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added successfully")
            }
        }
    }
    
    private func uploadImage(imageName: String) {
        let imageRef = storageRef.child("images/" + imageName)
        imageRef.putFile(from: newImage!, metadata: nil)
    }
    
    private func showAlert(message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
    
    private func makeImageRound() {
        self.itemImage.layer.masksToBounds = true
        self.itemImage.layer.cornerRadius = self.itemImage.bounds.width / 2
    }

    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (row == 0) {
            itemType = "Movie"
        } else {
            itemType = "TV Show"
        }
        
        return itemType
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            itemImage.image = image
            changedImage = true
            newImage = (info[UIImagePickerController.InfoKey.imageURL] as? URL)!
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // Hide keyboard when user touches outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Hide keyboard when user presses return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
