//
//  StatisticsViewController.swift
//  moneytracker
//
//  Created by Peter Ho on 9/5/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import UIKit
import Charts
import CoreData
import ChameleonFramework

class StatisticsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        oneMonthYearPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 215))
        oneMonthYearPicker.delegate = self
        oneMonthYearPicker.dataSource = self
        let oneMonthToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let oneMonthDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onOneMonthDoneButtonPushed))
        let oneMonthCancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onOneMonthCancelButtonPushed))
        oneMonthToolbar.items = [oneMonthCancelButton, flexibleSpace, oneMonthDoneButton]
        oneMonthTextField.inputAccessoryView = oneMonthToolbar
        oneMonthTextField.inputView = oneMonthYearPicker
        
        // Init value for text field
        let now = Date()
        let calendar = Calendar.current
        let currentMonth = "\(calendar.component(.month, from: now))/\(calendar.component(.year, from: now))"
        oneMonthTextField.text = currentMonth
        currentOneMonth = currentMonth
        
        pieChartUpdate(forMonth: oneMonthTextField.text!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - Outlet
    @IBOutlet weak var oneMonthTextField: UITextField!
    @IBOutlet weak var oneMonthPieChart: PieChartView!
    @IBOutlet weak var overviewBarChart: BarChartView!
    
    var oneMonthYearPicker: UIPickerView!
    
    var currentOneMonth = ""
    
    // MARK - Action
    @IBAction func onTapRegconized(_ sender: UITapGestureRecognizer) {
        oneMonthTextField.resignFirstResponder()
    }
    
    @objc func onOneMonthDoneButtonPushed() {
        let month = oneMonthYearPicker.selectedRow(inComponent: 0) + 1
        let year = oneMonthYearPicker.selectedRow(inComponent: 1) + 2018
        oneMonthTextField.text = "\(month)/\(year)"
        pieChartUpdate(forMonth: oneMonthTextField.text!)
        oneMonthTextField.resignFirstResponder()
    }
    
    @objc func onOneMonthCancelButtonPushed() {
        oneMonthTextField.resignFirstResponder()
    }
    
    func pieChartUpdate(forMonth month:String) {
        let activities = FinAct.fetchData(forMonth: month, type: "Expense") as! [FinAct]
        
        var entries:[PieChartDataEntry] = []
        var colors:[UIColor] = []
        var expenseCost = [0, 0, 0, 0, 0]
        let colorRef = [UIColor.flatYellow(), UIColor.flatTeal(), UIColor.flatOrange(), UIColor.flatSandColorDark(), UIColor.flatRed()]
        
        for activity in activities {
            let cate = ExpenseCate.fromString(string: activity.category!)
            expenseCost[cate.rawValue] += Int(activity.cost)
        }
        
        var i = 0
        for cost in expenseCost {
            if cost != 0 {
                let label = ExpenseCate.init(rawValue: i)?.string()
                let entry = PieChartDataEntry(value: Double(cost), label: label)
                entries.append(entry)
                colors.append(colorRef[i]!)
            }
            i += 1
        }
        
        let dataset = PieChartDataSet(values: entries, label: "Expense Type")
        let data = PieChartData(dataSet: dataset)
        oneMonthPieChart.data = data
        oneMonthPieChart.chartDescription?.text = "Expense Cost"
        
        dataset.colors = colors
        oneMonthPieChart.usePercentValuesEnabled = true
        oneMonthPieChart.legend.enabled = false
        oneMonthPieChart.animate(xAxisDuration: 1.5, easingOption: .easeInOutQuint)
        dataset.valueColors = [UIColor.flatBlack()]
        
        oneMonthPieChart.notifyDataSetChanged()
    }
    
    func barChartUpdate(from beginning:String, to ending:String) {
        let activities = FinAct.fetchData(fromMonth: beginning, toMonth: ending) as! [FinAct]
        let calendar = Calendar.current
        
        let beginningMonth = CalendarHelper.getCalendarComponents(fromString: beginning)[0]
        var monthLabel:[String] = []
        
        for i in 0...4 {
            if beginningMonth + i > 12 {
                monthLabel.append("\(beginningMonth + i - 12)")
            } else {
                monthLabel.append("\(beginningMonth + i)")
            }
        }
        
        var incomeData:[Int] = [0, 0, 0, 0, 0]
        var expenseData:[Int] = [0, 0, 0, 0, 0]
        
        for activity in activities {
            var index = calendar.component(.month, from: activity.date! as Date) - beginningMonth
            if index < 0 {
                index += 12
            }
            if FinActivity.fromString(string: activity.type!) == .Income {
                incomeData[index] += Int(activity.cost)
            } else {
                expenseData[index] += Int(activity.cost)
            }
        }
        
        var incomeEntry:[BarChartDataEntry] = []
        var expenseEntry:[BarChartDataEntry] = []
        for i in 0...4 {
            incomeEntry.append(BarChartDataEntry(x: Double(i), y: Double(incomeData[i])))
            expenseEntry.append(BarChartDataEntry(x: Double(i), y: Double(expenseData[i])))
        }
        
        let incomeDataSet = BarChartDataSet(values: incomeEntry, label: "Income")
        let expenseDataSet = BarChartDataSet(values: expenseEntry, label: "Expense")
        incomeDataSet.colors = [UIColor.flatGreen()]
        expenseDataSet.colors = [UIColor.flatYellow()]
        
        let chartData = BarChartData(dataSets: [incomeDataSet, expenseDataSet])
        
        
        overviewBarChart.data = chartData
        overviewBarChart.notifyDataSetChanged()
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
