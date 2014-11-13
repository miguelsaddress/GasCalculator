//
//  ReadingsViewController.swift
//  Gas Calculator
//
//  Created by Miguel Angel Moreno Armenteros on 12/11/14.
//  Copyright (c) 2014 Miguel Angel Moreno Armenteros. All rights reserved.
//

import UIKit
import CoreData

class ReadingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    //Label Elements for information
    @IBOutlet weak var lastReadingLabel: UILabel!
    @IBOutlet weak var m3ConsumedLabel: UILabel!
    @IBOutlet weak var daysBetweenReadingsLabel: UILabel!
    @IBOutlet weak var totalWithoutVATLabel: UILabel!
    @IBOutlet weak var totalWithVATLabel: UILabel!
    
    
    //variables
    var readingsArray = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //fill up array of readings
        let request: NSFetchRequest = NSFetchRequest(entityName: "ReadingItem")
        let sortByDate: NSSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortByDate]
        let context:NSManagedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!

        self.readingsArray = context.executeFetchRequest(request, error: nil)!
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.readingsArray.count == 0 {
            //to display no readings yet cell
            return 1
        } else {
            return self.readingsArray.count
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if self.readingsArray.count == 0 {
            var cell = self.tableView.dequeueReusableCellWithIdentifier("noReadingsYet", forIndexPath: indexPath) as UITableViewCell
            return cell
        } else {
            var theCell = self.tableView.dequeueReusableCellWithIdentifier("readingsCell", forIndexPath: indexPath) as ReadingsCell
            var theItem = self.readingsArray[indexPath.row] as ReadingItem
            theCell.dateOfReadingLabel.text = Date.toString(theItem.date)
            theCell.consumeLabel.text = "\(theItem.reading)"
            return theCell
        }
    }
    
}
