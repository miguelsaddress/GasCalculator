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
    
    enum Defaults:Double {
        case KWH_PER_M3 = 10.643
        case PRICE_KWH = 0.057273
        case TAXES = 0.00234
        case FIX_DAILY_TERM = 0.144
        case METER_RENT_PER_BILL = 2.34
        case VAT = 21.0
    }
    
    @IBOutlet weak var kwhPerm3TextField: UITextField!
    @IBOutlet weak var priceKwhTextField: UITextField!
    @IBOutlet weak var taxesTextField: UITextField!
    @IBOutlet weak var fixDailyTermTextField: UITextField!
    @IBOutlet weak var meterRentTextField: UITextField!
    @IBOutlet weak var vatTextField: UITextField!
    
    
    var defaults:NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    var kwhPerm3:Double = Defaults.KWH_PER_M3.rawValue {
        didSet {
            self.defaults.setDouble(kwhPerm3, forKey: "kwhPerm3")
            self.kwhPerm3TextField.text = "\(self.kwhPerm3)"
        }
    }

    var priceKwh:Double = Defaults.PRICE_KWH.rawValue {
        didSet {
            self.defaults.setDouble(priceKwh, forKey: "priceKwh")
            self.priceKwhTextField.text = "\(self.priceKwh)"
        }
    }

    var taxes:Double = Defaults.TAXES.rawValue {
        didSet {
            self.defaults.setDouble(taxes, forKey: "taxes")
            self.taxesTextField.text = "\(self.taxes)"
        }
    }

    var fixDailyTerm:Double = Defaults.FIX_DAILY_TERM.rawValue {
        didSet {
            self.defaults.setDouble(fixDailyTerm, forKey: "fixDailyTerm")
            self.fixDailyTermTextField.text = "\(self.fixDailyTerm)"
        }
    }
    

    var meterRent:Double = Defaults.METER_RENT_PER_BILL.rawValue {
        didSet {
            self.defaults.setDouble(self.meterRent, forKey: "meterRent")
            self.meterRentTextField.text = "\(self.meterRent)"
        }
    }

    var vat:Double = Defaults.VAT.rawValue {
        didSet {
            self.defaults.setDouble(vat, forKey: "vat")
            self.vatTextField.text = "\(self.vat)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpValuesFromDefaults()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpValuesFromDefaults() {


        if let aux = self.defaults.objectForKey("kwhPerm3") as? Double {
            self.kwhPerm3TextField.text = "\(aux)"
        } else {
            self.kwhPerm3TextField.text = "\(Defaults.KWH_PER_M3.rawValue)"
        }
        
        if let aux = self.defaults.objectForKey("priceKwh") as? Double {
            self.priceKwhTextField.text = "\(aux)"
        } else {
            self.priceKwhTextField.text = "\(Defaults.PRICE_KWH.rawValue)"
        }

        if let aux = self.defaults.objectForKey("taxes") as? Double {
            self.taxesTextField.text = "\(aux)"
        } else {
            self.taxesTextField.text = "\(Defaults.TAXES.rawValue)"
        }

        if let aux = self.defaults.objectForKey("fixDailyTerm") as? Double {
            self.fixDailyTermTextField.text = "\(aux)"
        } else {
            self.fixDailyTermTextField.text = "\(Defaults.FIX_DAILY_TERM.rawValue)"
        }
        
        if let aux = self.defaults.objectForKey("meterRent") as? Double {
            self.meterRentTextField.text = "\(aux)"
        } else {
            self.meterRentTextField.text = "\(Defaults.METER_RENT_PER_BILL.rawValue)"
        }
        
        if let aux = self.defaults.objectForKey("vat") as? Double {
            self.vatTextField.text = "\(aux)"
        } else {
            self.vatTextField.text = "\(Defaults.VAT.rawValue)"
        }

    }
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        //save info to the NSDefaults
        
        self.kwhPerm3 = NSString(string:self.kwhPerm3TextField.text).doubleValue
        self.priceKwh = NSString(string:self.priceKwhTextField.text).doubleValue
        self.taxes = NSString(string:self.taxesTextField.text).doubleValue
        self.fixDailyTerm = NSString(string:self.fixDailyTermTextField.text).doubleValue
        self.meterRent = NSString(string:self.meterRentTextField.text).doubleValue
        self.vat = NSString(string:self.vatTextField.text).doubleValue
        
        self.defaults.setBool(true, forKey: "settings_set")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
