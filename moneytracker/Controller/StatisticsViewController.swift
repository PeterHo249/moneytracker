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
        barChartUpdate(month: currentMonth)
        lineChartUpdate(month: currentMonth)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let now = Date()
        let calendar = Calendar.current
        let currentMonth = "\(calendar.component(.month, from: now))/\(calendar.component(.year, from: now))"
        pieChartUpdate(forMonth: oneMonthTextField.text!)
        barChartUpdate(month: currentMonth)
        lineChartUpdate(month: currentMonth)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - Outlet
    @IBOutlet weak var oneMonthTextField: UITextField!
    @IBOutlet weak var oneMonthPieChart: PieChartView!
    @IBOutlet weak var overviewBarChart: BarChartView!
    @IBOutlet weak var savingLineChart: LineChartView!
    
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
        
        dataset.colors = colors
        oneMonthPieChart.usePercentValuesEnabled = true
        oneMonthPieChart.legend.enabled = false
        oneMonthPieChart.animate(xAxisDuration: 1.5, easingOption: .easeInOutQuint)
        dataset.valueColors = [UIColor.flatBlack()]
        
        oneMonthPieChart.chartDescription?.text = ""
        
        oneMonthPieChart.notifyDataSetChanged()
    }
    
    func lineChartUpdate(month: String) {
        let activities = SavingAct.allAndCalcInterest() as! [SavingAct]
        
        let components = CalendarHelper.getCalendarComponents(fromString: month)
        var beginning = ""
        if components[0] <= 4 {
            beginning = "\(components[0] + 8)/\(components[1] - 1)"
        } else {
            beginning = "\(components[0] - 4)/\(components[1])"
        }
        
        let beginningMonth = CalendarHelper.getCalendarComponents(fromString: beginning)[0]
        let beginningYear = CalendarHelper.getCalendarComponents(fromString: beginning)[1]
        var monthLabel:[String] = []
        
        for i in 0...4 {
            if beginningMonth + i > 12 {
                monthLabel.append("\(beginningMonth + i - 12)/\(beginningYear + 1)")
            } else {
                monthLabel.append("\(beginningMonth + i)/\(beginningYear)")
            }
        }
        
        var saving = 0
        var index = 0
        var savings = [0, 0, 0, 0, 0]
        
        for activity in activities.reversed() {
            if CalendarHelper.compareDateFromString(CalendarHelper.getString(fromDate: activity.date! as Date, format: "MM/yyyy"), monthLabel[index]) == .less || CalendarHelper.compareDateFromString(CalendarHelper.getString(fromDate: activity.date! as Date, format: "MM/yyyy"), monthLabel[index]) == .equal {
                if activity.type == "Deposit" {
                    saving += Int(activity.cost)
                } else {
                    saving -= Int(activity.cost)
                }
            } else if CalendarHelper.compareDateFromString(CalendarHelper.getString(fromDate: activity.date! as Date, format: "MM/yyyy"), monthLabel[index]) == .greater {
                while CalendarHelper.compareDateFromString(CalendarHelper.getString(fromDate: activity.date! as Date, format: "MM/yyyy"), monthLabel[index]) == .greater {
                    savings[index] = saving
                    index += 1
                }
                if activity.type == "Deposit" {
                    saving += Int(activity.cost)
                } else {
                    saving -= Int(activity.cost)
                }
            }
        }
        savings[4] = saving
        
        var lineChartEntry:[ChartDataEntry] = []
        for i in 1...4 {
            lineChartEntry.append(ChartDataEntry(x: Double(i), y: Double(savings[i])))
        }
        
        let lineChartDataSet = LineChartDataSet(values: lineChartEntry, label: "Saving")
        lineChartDataSet.colors = [UIColor.flatRed()]
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        savingLineChart.data = lineChartData
        savingLineChart.chartDescription?.text = ""
        savingLineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: monthLabel)
        savingLineChart.xAxis.labelPosition = .bottom
        savingLineChart.legend.enabled = false
    }
    
    func barChartUpdate(month: String) {
        let components = CalendarHelper.getCalendarComponents(fromString: month)
        let ending = month
        var beginning = ""
        if components[0] <= 4 {
            beginning = "\(components[0] + 8)/\(components[1] - 1)"
        } else {
            beginning = "\(components[0] - 4)/\(components[1])"
        }
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
        
        let legend = overviewBarChart.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.yOffset = 10.0;
        legend.xOffset = 10.0;
        legend.yEntrySpace = 0.0;
        
        let xaxis = overviewBarChart.xAxis
        xaxis.drawGridLinesEnabled = true
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = true
        xaxis.valueFormatter = IndexAxisValueFormatter(values:monthLabel)
        xaxis.granularity = 1
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        
        let yaxis = overviewBarChart.leftAxis
        yaxis.spaceTop = 0.5
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = false
        
        overviewBarChart.rightAxis.enabled = false
        
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        
        let groupCount = monthLabel.count
        let startNumber = 0
        
        chartData.barWidth = barWidth;
        overviewBarChart.xAxis.axisMinimum = Double(startNumber)
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        overviewBarChart.xAxis.axisMaximum = Double(startNumber) + gg * Double(groupCount)
        
        chartData.groupBars(fromX: Double(startNumber), groupSpace: groupSpace, barSpace: barSpace)
        
        overviewBarChart.animate(yAxisDuration: 1.5, easingOption: .easeInOutExpo)
        
        overviewBarChart.chartDescription?.text = ""
        
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
