//
//  UpdateReadingViewController.swift
//  Gas Calculator
//
//  Created by Miguel Angel Moreno Armenteros on 12/11/14.
//  Copyright (c) 2014 Miguel Angel Moreno Armenteros. All rights reserved.
//

import UIKit

class UpdateReadingViewController: UIViewController {

    @IBOutlet weak var readingTextField: UITextField!
    @IBOutlet weak var readingDatePicker: UIDatePicker!
    @IBOutlet weak var providedReadingSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
