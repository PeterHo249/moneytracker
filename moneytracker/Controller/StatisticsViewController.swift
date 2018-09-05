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
        
        monthYearInputPickerView = UIView(frame: CGRect(x: 0, y: 100, width: 320, height: 130))
        monthYearPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 320, height: 130))
        monthYearPicker.delegate = self
        monthYearPicker.dataSource = self
        monthYearInputPickerView.addSubview(monthYearPicker)
        oneMonthTextField.inputView = monthYearInputPickerView
        beginningTimeTextField.inputView = monthYearInputPickerView
        endingTimeTextField.inputView = monthYearInputPickerView
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
    
    var monthYearInputPickerView: UIView!
    var monthYearPicker: UIPickerView!
    
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
