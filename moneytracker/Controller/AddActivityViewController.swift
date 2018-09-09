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
        
        if !isNew {
            let descRow:TextRow = form.rowBy(tag: tags.descTag)!
            descRow.value = sourceData.desc
            let costRow:IntRow = form.rowBy(tag: tags.costTag)!
            costRow.value = Int(sourceData.cost)
            let dateRow:DateRow = form.rowBy(tag: tags.dateTag)!
            dateRow.value = sourceData.date! as Date
            let typeRow:PushRow<String> = form.rowBy(tag: tags.typeTag)!
            typeRow.value = sourceData.type
            let cateRow:PushRow<String> = form.rowBy(tag: tags.cateTag)!
            cateRow.value = sourceData.category
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
        if errors.count != 0 { // Check whether row is blank
            let alert = UIAlertController(title: "Opps!", message: "Please complete all filed!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else {
            var balance = UserDefaults.standard.integer(forKey: balanceKeyName)
            var spent = UserDefaults.standard.integer(forKey: spentKeyName)
            
            let descRow:TextRow = form.rowBy(tag: tags.descTag)!
            let costRow:IntRow = form.rowBy(tag: tags.costTag)!
            let dateRow:DateRow = form.rowBy(tag: tags.dateTag)!
            let typeRow:PushRow<String> = form.rowBy(tag: tags.typeTag)!
            let cateRow:PushRow<String> = form.rowBy(tag: tags.cateTag)!
            
            let calendar = Calendar.current
            
            if isNew { // Check whether add new activity or view detail
                let cost = costRow.value!
                if FinActivity.fromString(string: typeRow.value!) == .Expense { // If add new expense
                    if cost <= balance { // Check if have enough money for expense
                        let newActicity = FinAct.create() as! FinAct
                        newActicity.desc = descRow.value
                        newActicity.cost = Int32(costRow.value!)
                        newActicity.date = dateRow.value! as NSDate
                        newActicity.type = typeRow.value
                        newActicity.category = cateRow.value
                        
                        balance = balance - cost
                        UserDefaults.standard.set(balance, forKey: balanceKeyName)
                        if calendar.component(.month, from: dateRow.value!) == UserDefaults.standard.integer(forKey: monthSpendKeyName) {
                            spent = spent + cost
                            UserDefaults.standard.set(spent, forKey: spentKeyName)
                        }
                        
                        DB.save()
                        sourceViewController.refreshFinStatement()
                        sourceViewController.reloadDataForTableView(type: sourceViewController.currentType, cate: sourceViewController.currentCate, fromMonth: sourceViewController.currentBeginningMonth, toMonth: sourceViewController.currentEndingMonth)
                        self.navigationController?.popViewController(animated: true)
                    } else { // Don't have enough money
                        let alert = UIAlertController(title: "Opps!", message: "You have less money than you need.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        
                        alert.addAction(okAction)
                        
                        present(alert, animated: true, completion: nil)
                    }
                } else { // Add new income
                    balance = balance + cost
                    UserDefaults.standard.set(balance, forKey: balanceKeyName)
                    
                    let newActicity = FinAct.create() as! FinAct
                    newActicity.desc = descRow.value
                    newActicity.cost = Int32(costRow.value!)
                    newActicity.date = dateRow.value! as NSDate
                    newActicity.type = typeRow.value
                    newActicity.category = cateRow.value
                    
                    DB.save()
                    sourceViewController.refreshFinStatement()
                    sourceViewController.reloadDataForTableView(type: sourceViewController.currentType, cate: sourceViewController.currentCate, fromMonth: sourceViewController.currentBeginningMonth, toMonth: sourceViewController.currentEndingMonth)
                    self.navigationController?.popViewController(animated: true)
                }
            } else { // Change existing activity
                let cost = costRow.value!
                let oldCost = Int(sourceData.cost)
                let oldMonth = calendar.component(.month, from: sourceData.date! as Date)
                let oldType = FinActivity.fromString(string: sourceData.type!)
                let type = FinActivity.fromString(string: typeRow.value!)
                let costDiff = cost - oldCost
                if type == oldType { // Check whether change type of activity
                    if type == .Expense {
                        if costDiff <= balance {
                            sourceData.desc = descRow.value
                            sourceData.cost = Int32(costRow.value!)
                            sourceData.date = dateRow.value! as NSDate
                            sourceData.type = typeRow.value
                            sourceData.category = cateRow.value
                            
                            balance = balance - costDiff
                            UserDefaults.standard.set(balance, forKey: balanceKeyName)
                            if calendar.component(.month, from: dateRow.value!) == UserDefaults.standard.integer(forKey: monthSpendKeyName) {
                                if calendar.component(.month, from: dateRow.value!) != oldMonth {
                                    spent = spent + cost
                                } else {
                                    spent = spent + costDiff
                                }
                                UserDefaults.standard.set(spent, forKey: spentKeyName)
                            }
                            
                            DB.save()
                            sourceViewController.refreshFinStatement()
                            sourceViewController.reloadDataForTableView(type: sourceViewController.currentType, cate: sourceViewController.currentCate, fromMonth: sourceViewController.currentBeginningMonth, toMonth: sourceViewController.currentEndingMonth)
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            let alert = UIAlertController(title: "Opps!", message: "You have less money than you need.", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                            
                            alert.addAction(okAction)
                            
                            present(alert, animated: true, completion: nil)
                        }
                    } else {
                        balance = balance + costDiff
                        UserDefaults.standard.set(balance, forKey: balanceKeyName)
                        
                        sourceData.desc = descRow.value
                        sourceData.cost = Int32(costRow.value!)
                        sourceData.date = dateRow.value! as NSDate
                        sourceData.type = typeRow.value
                        sourceData.category = cateRow.value
                        
                        DB.save()
                        sourceViewController.refreshFinStatement()
                        sourceViewController.reloadDataForTableView(type: sourceViewController.currentType, cate: sourceViewController.currentCate, fromMonth: sourceViewController.currentBeginningMonth, toMonth: sourceViewController.currentEndingMonth)
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    if type == .Expense {
                        balance = balance - oldCost
                        if cost <= balance {
                            sourceData.desc = descRow.value
                            sourceData.cost = Int32(costRow.value!)
                            sourceData.date = dateRow.value! as NSDate
                            sourceData.type = typeRow.value
                            sourceData.category = cateRow.value
                            
                            balance = balance - cost
                            UserDefaults.standard.set(balance, forKey: balanceKeyName)
                            if calendar.component(.month, from: dateRow.value!) == UserDefaults.standard.integer(forKey: monthSpendKeyName) {
                                if calendar.component(.month, from: dateRow.value!) != oldMonth {
                                    spent = spent + cost
                                } else {
                                    spent = spent + costDiff
                                }
                                UserDefaults.standard.set(spent, forKey: spentKeyName)
                            }
                            
                            DB.save()
                            sourceViewController.refreshFinStatement()
                            sourceViewController.reloadDataForTableView(type: sourceViewController.currentType, cate: sourceViewController.currentCate, fromMonth: sourceViewController.currentBeginningMonth, toMonth: sourceViewController.currentEndingMonth)
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            let alert = UIAlertController(title: "Opps!", message: "You cannot change type of activity.", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                            
                            alert.addAction(okAction)
                            
                            present(alert, animated: true, completion: nil)
                        }
                    } else {
                        balance = balance + oldCost + cost
                        UserDefaults.standard.set(balance, forKey: balanceKeyName)
                        
                        sourceData.desc = descRow.value
                        sourceData.cost = Int32(costRow.value!)
                        sourceData.date = dateRow.value! as NSDate
                        sourceData.type = typeRow.value
                        sourceData.category = cateRow.value
                        
                        DB.save()
                        sourceViewController.refreshFinStatement()
                        sourceViewController.reloadDataForTableView(type: sourceViewController.currentType, cate: sourceViewController.currentCate, fromMonth: sourceViewController.currentBeginningMonth, toMonth: sourceViewController.currentEndingMonth)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    // MARK: Variable
    var sourceViewController: SummaryViewController!
    var isNew = true
    var sourceData: FinAct!
    
}
