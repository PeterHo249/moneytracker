//
//  AddActivityViewController.swift
//  moneytracker
//
//  Created by Peter Ho on 9/5/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import UIKit
import Eureka

class AddActivityViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        form +++ Section("Acticity Info")
            <<< TextRow() {
                $0.title = "Name"
                $0.placeholder = "Enter activity title"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
            }
            <<< IntRow() {
                $0.title = "Cost"
                $0.placeholder = "Enter money cost"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
            }
            <<< DateRow() {
                $0.title = "Date"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
