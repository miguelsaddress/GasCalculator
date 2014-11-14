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
    var m3ConsumeFromLastProvidedReading: Double = 0.0
    var daysBetweenReadings:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.checkSettings()
        self.fetchedResultsController = self.getFetchedResultsController()
        self.fetchedResultsController.delegate = self
        self.fetchedResultsController.performFetch(nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = self.tableView.indexPathForSelectedRow() {
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }

        //set last reading
        let last = self.fetchedResultsController.fetchedObjects?.first as? ReadingItem
        if let date = last?.date {
            self.lastReadingLabel.text = Date.toString(date)
        } else {
            self.lastReadingLabel.text = "0.0"
        }
        
        
        self.calculateAndSetCosumeFromLastProvidedReading()
        self.calculateAndSetDaysFromLastProvidedReading()
//        self.tableView.reloadData()
        self.calculateConsume()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "updateReadingSegue" {
            let controller:UpdateReadingViewController = segue.destinationViewController as UpdateReadingViewController
            let indexPath:NSIndexPath = self.tableView.indexPathForSelectedRow()!
            controller.readingItem = self.fetchedResultsController.objectAtIndexPath(indexPath) as ReadingItem
        }
    }
    
    
    //UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections!.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.sections![section].numberOfObjects
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

            if theItem.provided as Bool {
                cell.backgroundColor = UIColor(red: 0.85, green: 0.92, blue: 0.83, alpha: 1.0)
            } else {
                cell.backgroundColor = UIColor.clearColor()
            }
            return cell
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {

            let item = self.fetchedResultsController.objectAtIndexPath(indexPath) as ReadingItem
            let delegate: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
            let context: NSManagedObjectContext = delegate.managedObjectContext!
            context.deleteObject(item)
            delegate.saveContext()
        }
    }
    
    //NSFetchedResultsController delegate
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
        self.calculateConsume()

//        self.calculateAndSetCosumeFromLastProvidedReading()
//        self.calculateAndSetDaysFromLastProvidedReading()
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
        let sortByReading: NSSortDescriptor = NSSortDescriptor(key: "reading", ascending: false)
        request.sortDescriptors = [sortByDate, sortByReading]
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
    
    func calculateAndSetCosumeFromLastProvidedReading() {
        //get last provided reading
        var mostRecentReading = 0.0
        var firstReading = 0.0
        var lastProvidedReading = 0.0
        
        if let auxMostRecentReading = self.fetchedResultsController.fetchedObjects?.first as? ReadingItem {
            mostRecentReading = auxMostRecentReading.reading as Double
        }

        if let auxFirstRecentReading = self.fetchedResultsController.fetchedObjects?.last as? ReadingItem {
            firstReading = auxFirstRecentReading.reading as Double
        }
        
        if var auxLastProvidedReading = self.getLastProvidedReading() {
            if auxLastProvidedReading.provided as Bool {
                if let auxPreviousLastProvidedReading = self.getPreviousLastProvidedReading() {
                    auxLastProvidedReading = auxPreviousLastProvidedReading
                }
            }
            lastProvidedReading = auxLastProvidedReading.reading as Double
        }


        var consume = abs(mostRecentReading - lastProvidedReading)
        if lastProvidedReading == 0.0 {
            consume = abs(mostRecentReading - firstReading)
        }
        self.m3ConsumeFromLastProvidedReading = consume as Double
        self.m3ConsumedLabel.text = String(format: "%.2f", consume)
    }
    
    func calculateAndSetDaysFromLastProvidedReading() {
        //get last provided reading
        var mostRecentReading = NSDate()
        var firstReading = NSDate()
        
        if let auxMostRecentReading = self.fetchedResultsController.fetchedObjects?.first as? ReadingItem {
            mostRecentReading = auxMostRecentReading.date
        }
        
        if let auxFirstRecentReading = self.fetchedResultsController.fetchedObjects?.last as? ReadingItem {
            firstReading = auxFirstRecentReading.date
        }
        
        var lastProvidedReading = firstReading
        
        if var auxLastProvidedReading = self.getLastProvidedReading() {
            if auxLastProvidedReading.provided as Bool {
                if let auxPreviousLastProvidedReading = self.getPreviousLastProvidedReading() {
                    auxLastProvidedReading = auxPreviousLastProvidedReading
                }
            }
            lastProvidedReading = auxLastProvidedReading.date
        }
        
        
        var days = Date.daysBetween(fromDate: mostRecentReading, toDate: lastProvidedReading)
        self.daysBetweenReadings = days
        self.daysBetweenReadingsLabel.text = "\(days)"
        
    }

    
    func getLastProvidedReading() -> ReadingItem? {
        var fetchRequest = self.getSortedByDateDescendingFetchRequest()
        fetchRequest.fetchLimit = 1
        var predicate:NSPredicate = NSPredicate(format: "provided = true", argumentArray: nil)
        fetchRequest.predicate = predicate
        let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
        let results = context.executeFetchRequest(fetchRequest, error: nil)
        let item:ReadingItem? = results?.last as? ReadingItem
        return item
    }
    
    func getPreviousLastProvidedReading() -> ReadingItem? {
        var fetchRequest = self.getSortedByDateDescendingFetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.fetchOffset = 1
        var predicate:NSPredicate = NSPredicate(format: "provided = true", argumentArray: nil)
        fetchRequest.predicate = predicate
        let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
        let results = context.executeFetchRequest(fetchRequest, error: nil)
        let item:ReadingItem? = results?.last as? ReadingItem
        return item
    }
    
    func calculateConsume() {
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let costOfConsume = (self.m3ConsumeFromLastProvidedReading as Double)
                            * (defaults.objectForKey("kwhPerm3") as Double)
                            * (defaults.objectForKey("priceKwh") as Double)
        //        println("Gasto consumo: \(costOfConsume)")
        
        
        let costOfTaxes = (self.m3ConsumeFromLastProvidedReading as Double)
                            * (defaults.objectForKey("kwhPerm3") as Double)
                            * (defaults.objectForKey("taxes") as Double)
        //        println("Impuesto hidrocarburos: \(costOfTaxes)")
        
        
        let costOfFixDailyTerm = Double(self.daysBetweenReadings)
                            * (defaults.objectForKey("fixDailyTerm") as Double)
        //        println("Coste del termino fijo: \(costOfFixDailyTerm)")
        
        
        let totalWithoutVAT = costOfConsume + costOfTaxes + costOfFixDailyTerm
                            + (defaults.objectForKey("meterRent") as Double)
        self.totalWithoutVATLabel.text = String(format: "%.2f", totalWithoutVAT)
        
        let vat = totalWithoutVAT * (defaults.objectForKey("vat") as Double ) / 100.0
        let totalWithVAT = totalWithoutVAT + vat
        
        self.totalWithVATLabel.text = String(format: "%.2f", totalWithVAT)
        
    }
}