//
//  MoviesTableViewController.swift
//  MovieChecker
//
//  Created by user169883 on 4/17/20.
//  Copyright © 2020 user169883. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class TVShowsTableViewController: UITableViewController {
    
    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    var tvShows = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.rowHeight = 100;
        tvShows.removeAll()
        self.tableView.reloadData()
        
        let userId = user?.uid
        db.collection("series").whereField("userId", isEqualTo: userId ?? "")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                
                for document in documents {
                    self.tvShows.append(document.data())
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvShows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TVShowsTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TVShowsTableViewCell  else { fatalError("The dequeued cell is not an instance of TVShowsTableViewCell.") }
        
        let tvShow = tvShows[indexPath.row]
        
        cell.showName.text = tvShow["name"] as! String
        let imagePath = tvShow["image"] as! String
        
//        print("Image path")
//        print(imagePath)
        if (imagePath == "") {
            cell.showImage.image = UIImage(named: "20-512")
        } else {
            let imagesRef = storageRef.child(imagePath)
            
            var image: UIImage? = nil
            
            imagesRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                if let error = error {
                    print("Error occured when downloading the image")
                    
                    print(error)
                } else {
                    image = UIImage(data: data!)
                    
                    DispatchQueue.main.async {
                        cell.showImage.image = image
                    }
                }
            }
        }
        
        return cell
    }
    
    private func getImageFromPath(withPath path: String) -> UIImage? {
        let imagesRef = storageRef.child(path)
        
        var image: UIImage? = nil
        
        imagesRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error occured when downloading the image")
                
                print(error)
            } else {
                image = UIImage(data: data!)
                
            }
        }
        
        return image
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
}
