//
//  StatisticsViewController.swift
//  moneytracker
//
//  Created by Peter Ho on 9/5/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import UIKit
import Charts

class StatisticsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        oneMonthYearPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 215))
        oneMonthYearPicker.delegate = self
        oneMonthYearPicker.dataSource = self
        let oneMonthToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let oneMonthDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
        oneMonthToolbar.items = [flexibleSpace, oneMonthDoneButton]
        oneMonthTextField.inputAccessoryView = oneMonthToolbar
        oneMonthTextField.inputView = oneMonthYearPicker
        
        beginningMonthYearPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 215))
        beginningMonthYearPicker.delegate = self
        beginningMonthYearPicker.dataSource = self
        let beginningToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let beginningDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
        beginningToolbar.items = [flexibleSpace, beginningDoneButton]
        beginningTimeTextField.inputAccessoryView = beginningToolbar
        beginningTimeTextField.inputView = beginningMonthYearPicker
        
        endingMonthYearPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 215))
        endingMonthYearPicker.delegate = self
        endingMonthYearPicker.dataSource = self
        let endingToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let endingDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
        endingToolbar.items = [flexibleSpace, endingDoneButton]
        endingTimeTextField.inputAccessoryView = endingToolbar
        endingTimeTextField.inputView = endingMonthYearPicker
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - Outlet
    @IBOutlet weak var oneMonthTextField: UITextField!
    @IBOutlet weak var oneMonthPieChart: PieChartView!
    @IBOutlet weak var beginningTimeTextField: UITextField!
    @IBOutlet weak var endingTimeTextField: UITextField!
    @IBOutlet weak var overviewBarChart: BarChartView!
    
    var oneMonthYearInputPickerView: UIView!
    var oneMonthYearPicker: UIPickerView!
    var beginningMonthYearInputPickerView: UIView!
    var beginningMonthYearPicker: UIPickerView!
    var endingMonthYearInputPickerView: UIView!
    var endingMonthYearPicker: UIPickerView!
    
    // MARK - Action
    @IBAction func onTapRegconized(_ sender: UITapGestureRecognizer) {
        oneMonthTextField.resignFirstResponder()
        beginningTimeTextField.resignFirstResponder()
        endingTimeTextField.resignFirstResponder()
    }
    
}

extension StatisticsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 12
        } else {
            return 10
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(row + 1)"
        } else {
            return "\(row + 2018)"
        }
    }
    
}
