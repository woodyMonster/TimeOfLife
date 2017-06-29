//
//  TimeOfLifeTableViewController.swift
//  TimeOfLife
//
//  Created by 王志輝 on 2017/6/19.
//  Copyright © 2017年 Woody. All rights reserved.
//

import UIKit
import CoreData

class TimeOfLifeTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating{
    
    @IBAction func cancelButton(segue: UIStoryboardSegue) {
        
    }
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var fetchResultController: NSFetchedResultsController<TimeOfLifeMO>!
    var timeOfLife:[TimeOfLifeMO] = []
    var searchController: UISearchController!
    var searchResults:[TimeOfLifeMO] = []
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // searchBar 設定
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.placeholder = "搜尋地區或時間 ... "
        searchController.searchBar.tintColor = UIColor.white
        // sideMeun
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
        
    }
    
   
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let newIndexPaht = newIndexPath {
                tableView.insertRows(at: [newIndexPaht], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            timeOfLife = fetchedObjects as! [TimeOfLifeMO]
        }
        
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResults.count
        } else {
            return timeOfLife.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TimeOfLifeTableViewCell
        let timeOfLifeResult = (searchController.isActive) ? searchResults[indexPath.row] : timeOfLife[indexPath.row]
        
        cell.dateLabel.text = timeOfLifeResult.date
        cell.areaLabel.text = timeOfLifeResult.area
        cell.photoImageView.image = UIImage(data: timeOfLifeResult.image as! Data)
        
        

        // Configure the cell...

        return cell
    }
    
        // Cell 動畫
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 100, 0)
        cell.layer.transform = rotationTransform
        UIView.animate(withDuration: 1, animations:
            { cell.layer.transform = CATransform3DIdentity })

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! DetailViewController
                
                destinationController.timeOfLife = (searchController.isActive) ? searchResults[indexPath.row] : timeOfLife[indexPath.row]
                
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
 
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        } else {
            return true
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            timeOfLife.remove(at: indexPath.row)
        }
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func filterContent(for searchText: String) {
        searchResults = timeOfLife.filter({
            (timeOfLife) -> Bool in
            if let date = timeOfLife.date, let area = timeOfLife.area{
                let isMatch = date.localizedCaseInsensitiveContains(searchText) || area.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            return false
        })
    }
    

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // share
        let shareAction = UITableViewRowAction(style: .default, title: "Share", handler: {
            (action, indexPath) in
            let defaultText = self.timeOfLife[indexPath.row].descriptions!
            
            if let imageToShare = UIImage(data: self.timeOfLife[indexPath.row].image as! Data) {
                
                let activityController = UIActivityViewController(activityItems: [ defaultText, imageToShare ], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
           
        })
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: {
            ( action, indexPath ) in
            
            if let appDel = UIApplication.shared.delegate as? AppDelegate {
                let context = appDel.persistentContainer.viewContext
                let timeOfLifeToDelete = self.fetchResultController.object(at: indexPath)
                context.delete(timeOfLifeToDelete)
                appDel.saveContext()
            }
           
            
        })
        
        shareAction.backgroundColor = UIColor(red: 48.0/255.0, green: 173.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        return [ deleteAction, shareAction ]
        
    }
    
    

}
