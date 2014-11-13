//
//  ReadingsViewController.swift
//  Gas Calculator
//
//  Created by Miguel Angel Moreno Armenteros on 12/11/14.
//  Copyright (c) 2014 Miguel Angel Moreno Armenteros. All rights reserved.
//

import UIKit
import CoreData

class ReadingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    
    //Label Elements for information
    @IBOutlet weak var lastReadingLabel: UILabel!
    @IBOutlet weak var m3ConsumedLabel: UILabel!
    @IBOutlet weak var daysBetweenReadingsLabel: UILabel!
    @IBOutlet weak var totalWithoutVATLabel: UILabel!
    @IBOutlet weak var totalWithVATLabel: UILabel!
    
    
    //variables
    var fetchedResultsController: NSFetchedResultsController = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.checkSettings()
        self.fetchedResultsController = self.getFetchedResultsController()
        self.fetchedResultsController.delegate = self
        self.fetchedResultsController.performFetch(nil)
        
        println(self.fetchedResultsController.fetchedObjects?.count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections!.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.sections![section].numberOfObjects
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if self.fetchedResultsController.sections![indexPath.section].numberOfObjects == 0 {
            var cell = self.tableView.dequeueReusableCellWithIdentifier("noReadingsYet", forIndexPath: indexPath) as UITableViewCell
            return cell
        } else {
            var cell = self.tableView.dequeueReusableCellWithIdentifier("readingsCell", forIndexPath: indexPath) as ReadingsCell
            var theItem = self.fetchedResultsController.objectAtIndexPath(indexPath) as ReadingItem
            cell.dateOfReadingLabel.text = Date.toString(theItem.date)
            cell.consumeLabel.text = "\(theItem.reading)"
            return cell
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {

            let item = self.fetchedResultsController.objectAtIndexPath(indexPath) as ReadingItem
            println("Deleting item: \(item) - [\(indexPath)]")

            let delegate: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
            let context: NSManagedObjectContext = delegate.managedObjectContext!
            context.deleteObject(item)
            delegate.saveContext()
        }
    }
    
    //NSFetchedResultsController delegate
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }

    
    
    //Helpers
    
    func checkSettings() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let settingsSet: Bool? = defaults.objectForKey("settings_set") as Bool?
        
        if settingsSet == nil {
            var alertController = UIAlertController(title: "Atención", message: "No hay datos en la configuración", preferredStyle: UIAlertControllerStyle.Alert)
            var OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                self.performSegueWithIdentifier("settingsSegue", sender: nil)
            })
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func getSortedByDateDescendingFetchRequest() -> NSFetchRequest {
        let request: NSFetchRequest = NSFetchRequest(entityName: "ReadingItem")
        let sortByDate: NSSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortByDate]
        return request
    }

    
    func getFetchedResultsController() -> NSFetchedResultsController {
        let context:NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        let fetchResultsController = NSFetchedResultsController(
            fetchRequest: self.getSortedByDateDescendingFetchRequest(),
            managedObjectContext: context!,
            sectionNameKeyPath: "provided",
            cacheName: nil
        )
        return fetchResultsController
    }

    
}
