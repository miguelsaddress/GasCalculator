//
//  SettingsViewController.swift
//  Gas Calculator
//
//  Created by Miguel Angel Moreno Armenteros on 12/11/14.
//  Copyright (c) 2014 Miguel Angel Moreno Armenteros. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    //textfields
    
    @IBOutlet weak var kwhPerm3TextField: UITextField!
    @IBOutlet weak var priceKwhTextField: UITextField!
    @IBOutlet weak var taxesTextField: UITextField!
    @IBOutlet weak var fixDailyTermTextField: UITextField!
    @IBOutlet weak var meterRentTextField: UITextField!
    @IBOutlet weak var vatTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        //save info to the NSDefaults
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
