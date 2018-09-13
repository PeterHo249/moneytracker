//
//  AddSavingViewController.swift
//  moneytracker
//
//  Created by Peter Ho on 9/8/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import UIKit
import  Eureka

class AddSavingViewController: FormViewController {
    
    let tags = FormTag()
    let userDefaults = UserDefaults(suiteName: "group.peterho.moneytracker")!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        form +++ Section()
            <<< TextRow(tags.descTag) {
                $0.title = tags.descTag
                $0.placeholder = "e.g. Saving 08/2018"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnDemand
        }
            <<< IntRow(tags.costTag) {
                $0.title = tags.costTag
                $0.placeholder = "e.g. 1000000"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnDemand
        }
            <<< DateRow(tags.dateTag) {
                $0.title = tags.dateTag
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnDemand
                $0.value = Date()
        }
            <<< PushRow<String>(tags.typeTag) {
                $0.title = tags.typeTag
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnDemand
                $0.options = SavingActivity.strings
                $0.onChange({row in
                    let type = SavingActivity.fromString(string: row.value!)
                    let savingSection = self.form.sectionBy(tag: self.tags.savingTag)
                    switch type {
                    case .Deposit:
                        savingSection?.hidden = false
                    case .Withdraw:
                        savingSection?.hidden = true
                    }
                    savingSection?.evaluateHidden()
                })
        }
        +++ Section(tags.savingTag) {
                $0.tag = self.tags.savingTag
                $0.hidden = true
            }
            <<< SwitchRow(tags.isInterestedTag) {
                $0.title = tags.isInterestedTag
                $0.onChange({row in
                    let rateRow:DecimalRow = self.form.rowBy(tag: self.tags.intRateTag)!
                    let periodRow:PushRow<String> = self.form.rowBy(tag: self.tags.periodTag)!
                    
                    if row.value == true {
                        rateRow.hidden = false
                        periodRow.hidden = false
                    } else {
                        rateRow.hidden = true
                        periodRow.hidden = true
                    }
                    
                    rateRow.evaluateHidden()
                    periodRow.evaluateHidden()
                })
        }
            <<< DecimalRow(tags.intRateTag) {
                $0.title = tags.intRateTag
                $0.placeholder = "e.g. 6.5"
                $0.hidden = true
        }
            <<< PushRow<String>(tags.periodTag) {
                $0.title = tags.periodTag
                $0.options = PeriodRef.strings
                $0.hidden = true
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(onSaveButtonPushed))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Action
    @objc func onSaveButtonPushed() {
        let errors = form.validate()
        if errors.count != 0 { // Check whether row is blank
            let alert = UIAlertController(title: "Opps!", message: "Please complete all filed!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else {
            let descRow:TextRow = form.rowBy(tag: tags.descTag)!
            let costRow:IntRow = form.rowBy(tag: tags.costTag)!
            let dateRow:DateRow = form.rowBy(tag: tags.dateTag)!
            let typeRow:PushRow<String> = form.rowBy(tag: tags.typeTag)!
            let isInterestedRow:SwitchRow = form.rowBy(tag: tags.isInterestedTag)!
            let rateRow:DecimalRow = form.rowBy(tag: tags.intRateTag)!
            let periodRow:PushRow<String> = form.rowBy(tag: tags.periodTag)!
            
            var currentSaving = userDefaults.integer(forKey: savingKeyName)
            if isNew{
                let savingActivity = SavingAct.create() as! SavingAct
                savingActivity.desc = descRow.value
                savingActivity.cost = Int32(costRow.value!)
                savingActivity.date = dateRow.value! as NSDate
                savingActivity.type = typeRow.value
                if typeRow.value! == "Deposit" {
                    savingActivity.isInterested = isInterestedRow.value!
                    if isInterestedRow.value == true {
                        savingActivity.rate = rateRow.value!
                        savingActivity.period = periodRow.value
                        savingActivity.startDate = dateRow.value! as NSDate
                    }
                    currentSaving += costRow.value!
                } else {
                    currentSaving -= costRow.value!
                }
                userDefaults.set(currentSaving, forKey: savingKeyName)
                
                DB.save()
                (sourceViewController as! SavingViewController).reloadDataForTableView()
                (sourceViewController as! SavingViewController).refreshSavingLabel()
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: Variable
    var sourceViewController: UIViewController!
    var isNew = true
    var sourceData: SavingAct!

}
