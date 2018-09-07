//
//  SummaryViewController.swift
//  moneytracker
//
//  Created by Peter Ho on 9/5/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import UIKit
import CoreData

class SummaryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Init picker view
        typeCatePicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 215))
        typeCatePicker.delegate = self
        typeCatePicker.dataSource = self
        let typeCateToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let typeCateDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.onTypeCateDoneButtonPushed))
        typeCateToolbar.items = [flexibleSpace, typeCateDoneButton]
        typeCateTextField.inputAccessoryView = typeCateToolbar
        typeCateTextField.inputView = typeCatePicker
        
        beginningMonthYearPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 215))
        beginningMonthYearPicker.delegate = self
        beginningMonthYearPicker.dataSource = self
        let beginningToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let beginningDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.onBeginningMonthDoneButtonPushed))
        beginningToolbar.items = [flexibleSpace, beginningDoneButton]
        beginningTimeTextField.inputAccessoryView = beginningToolbar
        beginningTimeTextField.inputView = beginningMonthYearPicker
        
        endingMonthYearPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 215))
        endingMonthYearPicker.delegate = self
        endingMonthYearPicker.dataSource = self
        let endingToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let endingDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.onEndingMonthDoneButtonPushed))
        endingToolbar.items = [flexibleSpace, endingDoneButton]
        endingTimeTextField.inputAccessoryView = endingToolbar
        endingTimeTextField.inputView = endingMonthYearPicker
        
        cates = cateRef[0]
        
        // Init value for text field
        typeCateTextField.text = "All, All"
        let now = Date()
        let calendar = Calendar.current
        let currentMonth = "\(calendar.component(.month, from: now))/\(calendar.component(.year, from: now))"
        beginningTimeTextField.text = currentMonth
        endingTimeTextField.text = currentMonth
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Outlet
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var typeCateTextField: UITextField!
    @IBOutlet weak var beginningTimeTextField: UITextField!
    @IBOutlet weak var endingTimeTextField: UITextField!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var activityTableView: UITableView!
    
    var typeCatePicker: UIPickerView!
    var beginningMonthYearPicker: UIPickerView!
    var endingMonthYearPicker: UIPickerView!
    
    // MARK: Variable
    let typeRef = ["All", "Income", "Expense"]
    let cateRef = [["All"],["Salary", "Other"],["Food", "Travel", "Vehicle", "Utility", "Miscellaneous"]]
    var cates: [String]!
    
    // MARK: Action
    @IBAction func onTapRecognized(_ sender: UITapGestureRecognizer) {
        typeCateTextField.resignFirstResponder()
        beginningTimeTextField.resignFirstResponder()
        endingTimeTextField.resignFirstResponder()
    }
    
    @objc func onTypeCateDoneButtonPushed() {
        let type = typeRef[typeCatePicker.selectedRow(inComponent: 0)]
        let cate = cates[typeCatePicker.selectedRow(inComponent: 1)]
        typeCateTextField.text = "\(type), \(cate)"
        typeCateTextField.resignFirstResponder()
    }
    
    @objc func onBeginningMonthDoneButtonPushed() {
        let month = beginningMonthYearPicker.selectedRow(inComponent: 0) + 1
        let year = beginningMonthYearPicker.selectedRow(inComponent: 1) + 2018
        beginningTimeTextField.text = "\(month)/\(year)"
        beginningTimeTextField.resignFirstResponder()
    }
    
    @objc func onEndingMonthDoneButtonPushed() {
        let month = endingMonthYearPicker.selectedRow(inComponent: 0) + 1
        let year = endingMonthYearPicker.selectedRow(inComponent: 1) + 2018
        endingTimeTextField.text = "\(month)/\(year)"
        endingTimeTextField.resignFirstResponder()
    }
    
    @IBAction func onChangeButtonPushed(_ sender: UIButton) {
    }
    
    
    // MARK: Helper
}

extension SummaryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == beginningMonthYearPicker || pickerView == endingMonthYearPicker {
            if component == 0 {
                return 12
            } else {
                return 10
            }
        } else {
            if component == 0 {
                return 3
            } else {
                return cates.count
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == beginningMonthYearPicker || pickerView == endingMonthYearPicker {
            if component == 0 {
                return "\(row + 1)"
            } else {
                return "\(row + 2018)"
            }
        } else {
            if component == 0 {
                return typeRef[row]
            } else {
                return cates[row]
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == typeCatePicker {
            if component == 0 {
                let selectedType = row
                cates = cateRef[selectedType]
                pickerView.reloadComponent(1)
                pickerView.selectRow(0, inComponent: 1, animated: true)
            }
        }
    }
}

extension SummaryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ActivityTableViewCell")
        return cell
    }
    
    
}
