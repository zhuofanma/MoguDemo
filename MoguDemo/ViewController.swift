//
//  ViewController.swift
//  MoguDemo
//
//  Created by Zhuofan Ma on 11/23/16.
//  Copyright © 2016 Zhuofan Ma. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var appDelegate:AppDelegate!
    var fetchedResultsController:NSFetchedResultsController<Datum>!
    lazy var imageInProgress = [IndexPath:Operation]()
    lazy var imageQueue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.dropAllData()
        let fetchRequest = NSFetchRequest<Datum>(entityName: "Datum")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key:"createdAt",ascending:true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error while trying to perform a search:\(error)")
        }
        getData()
    }

    func getData() {
        let numberOfModules = 5
        
        let backgroundContext = appDelegate.backgroundContext
        backgroundContext.perform() {
            var array = [Datum]()
            for _ in 1...numberOfModules {
                let newDatum = Datum(insertInto: backgroundContext)
                array.append(newDatum)
            }
            
            let closure = { (succeeded:Bool, dict:[String:String], index:Int) in
                if succeeded {
                    array[index].loadingStatus = .succeeded
                    array[index].title = dict["title"]
                    array[index].imageURL = dict["imageURL"]
                } else {
                    array[index].loadingStatus = .failed
                }
                do {
                    try self.appDelegate.backgroundContext.save()
                } catch {
                    print("Error while saving backgroundContext:\(error)")
                }
            }
            
            API_One() { succeeded, dict in
                closure(succeeded, dict, 0)
            }
            API_Two() { succeeded, dict in
                closure(succeeded, dict, 1)
            }
            API_Three() { succeeded, dict in
                closure(succeeded, dict, 2)
            }
            API_Four() { succeeded, dict in
                closure(succeeded, dict, 3)
            }
            API_Five() { succeeded, dict in
                closure(succeeded, dict, 4)
            }
        }
    }
    
    //MARK: Update Cells
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    //MARK: Configure TableView Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let frc = fetchedResultsController {
            return frc.sections![section].numberOfObjects
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableViewCell ?? TableViewCell()
        if let frc = fetchedResultsController {
            let datum = frc.object(at: indexPath)
            if datum.loadingStatus == .failed {
                cell.activityIndicator.stopAnimating()
                cell.textLabel?.text = "加载失败"
                cell.imageView?.image = nil
            } else if datum.loadingStatus == .succeeded {
                cell.activityIndicator.stopAnimating()
                cell.textLabel?.text = datum.title
                if let actualData = datum.imageData {
                    cell.imageView?.image = UIImage(data: actualData)
                } else {
                    cell.imageView?.image = UIImage(named: "PlaceholderImage")
                    downloadImage(datum: datum, indexPath: indexPath)
                }
            } else if datum.loadingStatus == .loading {
                cell.activityIndicator.startAnimating()
                cell.textLabel?.text = ""
                cell.imageView?.image = nil
            }
        }
        return cell
    }
    
    //MARK: Only Load Onscreen Images
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        imageQueue.isSuspended = true
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImagesForOnscreenCells()
            imageQueue.isSuspended = false
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImagesForOnscreenCells()
        imageQueue.isSuspended = false
    }
    
    func loadImagesForOnscreenCells () {
        if let pathsArray = tableView.indexPathsForVisibleRows {
            let allPendingOperations = Set(imageInProgress.keys)
            
            var toBeCancelled = allPendingOperations
            let visiblePaths = Set(pathsArray)
            toBeCancelled.subtract(visiblePaths)
            
            var toBeStarted = visiblePaths
            toBeStarted.subtract(allPendingOperations)
            
            for indexPath in toBeCancelled {
                if let pendingDownload = imageInProgress[indexPath] {
                    pendingDownload.cancel()
                }
                imageInProgress.removeValue(forKey: indexPath)
            }
            
            for indexPath in toBeStarted {
                let datum = self.fetchedResultsController?.object(at: indexPath)
                if datum?.imageData == nil && datum?.imageURL != nil {
                    self.downloadImage(datum: datum!, indexPath: indexPath)
                }
            }
        }
    }
    
    func downloadImage(datum:Datum, indexPath:IndexPath) {
        let operation = BlockOperation {
            if self.imageQueue.isSuspended == true { return }
            if let url = URL(string: datum.imageURL!) {
                let imageData = try? Data(contentsOf: url)
                if self.imageQueue.isSuspended == true { return }
                self.appDelegate.persistentContainer.viewContext.perform {
                    if let actualData = imageData {
                        datum.imageData = actualData
                    }
                }
            }
        }
        operation.completionBlock = {
            if operation.isCancelled { return }
            self.imageInProgress.removeValue(forKey: indexPath)
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
        imageQueue.addOperation(operation)
        imageInProgress[indexPath] = operation
    }
}

