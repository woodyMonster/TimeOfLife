//
//  PhotosCollectionViewController.swift
//  TimeOfLife
//
//  Created by 王志輝 on 2017/6/26.
//  Copyright © 2017年 Woody. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class PhotosCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate{

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet var photosCollectionView: UICollectionView!
    
    
    
    var fetchResultController: NSFetchedResultsController<TimeOfLifeMO>!
    var timeOfLife:[TimeOfLifeMO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // sideMenu
        //addSideBarMenu(leftMenuButton: menuButton)
        
        let fetchRequest: NSFetchRequest<TimeOfLifeMO> = TimeOfLifeMO.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "address", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptors]
        
        if let appDel = UIApplication.shared.delegate as? AppDelegate {
            let context = appDel.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObject = fetchResultController.fetchedObjects {
                    timeOfLife = fetchedObject
                }
            } catch {
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return timeOfLife.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotosCollectionViewCell
        
        
        //cell.dateLabel.text = timeOfLife[indexPath.row].date
        cell.photosImage.image = UIImage(data: timeOfLife[indexPath.row].image as! Data)
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size
        let collectionViewArea = Double(collectionViewSize.width * collectionViewSize.height)
        
        let sideSize: Double = sqrt(collectionViewArea / (Double(timeOfLife.count))) - 30.0
        
        return CGSize(width: sideSize, height: sideSize)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
