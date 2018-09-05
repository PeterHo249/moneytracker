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
        typeCateInputPickerView = UIView(frame: CGRect(x: 0, y: 100, width: 320, height: 130))
        typeCatePicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 320, height: 130))
        typeCatePicker.delegate = self
        typeCatePicker.dataSource = self
        typeCateInputPickerView.addSubview(typeCatePicker)
        typeCateTextField.inputView = typeCateInputPickerView
        
        monthYearInputPickerView = UIView(frame: CGRect(x: 0, y: 100, width: 320, height: 130))
        monthYearPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 320, height: 130))
        monthYearPicker.delegate = self
        monthYearPicker.dataSource = self
        monthYearInputPickerView.addSubview(monthYearPicker)
        beginningTimeTextField.inputView = monthYearInputPickerView
        endingTimeTextField.inputView = monthYearInputPickerView
        
        cates = cateRef[0]
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
    @IBOutlet weak var changeBudgetButton: UIButton!
    @IBOutlet weak var activityTableView: UITableView!
    
    var typeCateInputPickerView: UIView!
    var typeCatePicker: UIPickerView!
    var monthYearInputPickerView: UIView!
    var monthYearPicker: UIPickerView!
    
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
    
    
    // MARK: Helper
}

extension SummaryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == monthYearPicker {
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
        if pickerView == monthYearPicker {
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
