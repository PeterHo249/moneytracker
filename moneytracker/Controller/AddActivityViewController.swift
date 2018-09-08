//
//  AddActivityViewController.swift
//  moneytracker
//
//  Created by Peter Ho on 9/5/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import UIKit
import Eureka

struct FormTag {
    let descTag = "Description"
    let costTag = "Cost"
    let dateTag = "Date"
    let typeTag = "Type"
    let cateTag = "Category"
}

class AddActivityViewController: FormViewController {
    
    let tags = FormTag()
    let typeRef = ["Income", "Expense"]
    let cateRef = [["Salary", "Other"],["Food", "Travel", "Vehicle", "Utility", "Miscellaneous"]]
    var cates: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        form +++ Section()
            <<< TextRow(tags.descTag) {
                $0.title = tags.descTag
                $0.placeholder = "e.g. Have lunch"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnDemand
            }
            <<< IntRow(tags.costTag) {
                $0.title = tags.costTag
                $0.placeholder = "e.g. 45000"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnDemand
            }
            <<< DateRow(tags.dateTag) {
                $0.title = tags.dateTag
                $0.value = Date()
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnDemand
            }
            +++ Section()
            <<< PushRow<String>(tags.typeTag) {
                $0.title = tags.typeTag
                $0.options = FinActivity.strings
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnDemand
                $0.onChange { row in
                    let type = FinActivity.fromString(string: row.value!)
                    let cateRow: PushRow<String> = self.form.rowBy(tag: self.tags.cateTag)!
                    switch type {
                    case .Expense:
                        self.cates = ExpenseCate.strings
                    case .Income:
                        self.cates = IncomeCate.strings
                    }
                    cateRow.options = self.cates
                    cateRow.value = nil
                    cateRow.reload()
                }
            }
            <<< PushRow<String>(tags.cateTag) {
                $0.title = tags.cateTag
                $0.options = cates
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnDemand
            }
        
        // Init save button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(onSaveButtonPushed))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Action
    @objc func onSaveButtonPushed() {
        let errors = form.validate()
        print(errors)
        if errors.count != 0 {
            let alert = UIAlertController(title: "Opps!", message: "Please complete all filed!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else {
            if isNew {
                let newActicity = FinAct.create() as! FinAct
                let descRow:TextRow = form.rowBy(tag: tags.descTag)!
                newActicity.desc = descRow.value
                let costRow:IntRow = form.rowBy(tag: tags.costTag)!
                newActicity.cost = Int32(costRow.value!)
                let dateRow:DateRow = form.rowBy(tag: tags.dateTag)!
                newActicity.date = dateRow.value! as NSDate
                let typeRow:PushRow<String> = form.rowBy(tag: tags.typeTag)!
                newActicity.type = typeRow.value
                let cateRow:PushRow<String> = form.rowBy(tag: tags.cateTag)!
                newActicity.category = cateRow.value
            } else {
                
            }
            
            DB.save()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: Variable
    var sourceViewController: UIViewController!
    var isNew = true
    
}
