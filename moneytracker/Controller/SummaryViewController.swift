//
//  SummaryViewController.swift
//  moneytracker
//
//  Created by Peter Ho on 9/5/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import UIKit
import CoreData
import DZNEmptyDataSet
import ChameleonFramework

class SummaryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if UserDefaults.standard.bool(forKey: "user_balance_initialized") == false {
            initBalance()
            UserDefaults.standard.set(true, forKey: "user_balance_initialized")
        }
        
        let balance = UserDefaults.standard.integer(forKey: balanceKeyName)
        let spent = UserDefaults.standard.integer(forKey: spentKeyName)
        let budget = UserDefaults.standard.integer(forKey: budgetKeyName)
        balanceLabel.text = "\(balance)"
        budgetLabel.text = "\(spent)/\(budget)"
        
        // Init picker view
        typeCatePicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 215))
        typeCatePicker.delegate = self
        typeCatePicker.dataSource = self
        let typeCateToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let typeCateDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.onTypeCateDoneButtonPushed))
        let typeCateCancleButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.onTypeCateCancelButtonPushed))
        typeCateToolbar.items = [typeCateCancleButton, flexibleSpace, typeCateDoneButton]
        typeCateTextField.inputAccessoryView = typeCateToolbar
        typeCateTextField.inputView = typeCatePicker
        
        beginningMonthYearPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 215))
        beginningMonthYearPicker.delegate = self
        beginningMonthYearPicker.dataSource = self
        let beginningToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let beginningDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.onBeginningMonthDoneButtonPushed))
        let beginningCancleButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.onBeginningCancelButtonPushed))
        beginningToolbar.items = [beginningCancleButton, flexibleSpace, beginningDoneButton]
        beginningTimeTextField.inputAccessoryView = beginningToolbar
        beginningTimeTextField.inputView = beginningMonthYearPicker
        
        endingMonthYearPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 215))
        endingMonthYearPicker.delegate = self
        endingMonthYearPicker.dataSource = self
        let endingToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let endingDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.onEndingMonthDoneButtonPushed))
        let endingCancleButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.onEndingCancelButtonPushed))
        endingToolbar.items = [endingCancleButton, flexibleSpace, endingDoneButton]
        endingTimeTextField.inputAccessoryView = endingToolbar
        endingTimeTextField.inputView = endingMonthYearPicker
        
        cates = cateRef[0]
        
        // Init value for text field
        typeCateTextField.text = "All"
        let now = Date()
        let calendar = Calendar.current
        let currentMonth = "\(calendar.component(.month, from: now))/\(calendar.component(.year, from: now))"
        currentBeginningMonth = currentMonth
        currentEndingMonth = currentMonth
        beginningTimeTextField.text = currentMonth
        endingTimeTextField.text = currentMonth
        
        // Init data for tableview
        reloadDataForTableView(type: currentType, cate: currentCate, fromMonth: currentBeginningMonth, toMonth: currentEndingMonth)
        
        // Empty state
        //activityTableView.emptyDataSetSource = self
        //activityTableView.emptyDataSetDelegate = self
        activityTableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshFinStatement()
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
    
    var activities:[NSManagedObject] = []
    var currentType:String = "All"
    var currentCate:String = "All"
    var currentBeginningMonth: String = ""
    var currentEndingMonth: String = ""
    
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
        if type == "All" {
            typeCateTextField.text = "All"
            currentType = "All"
            currentCate = "All"
        } else {
            typeCateTextField.text = "\(type), \(cate)"
            currentType = type
            currentCate = cate
        }
        reloadDataForTableView(type: currentType, cate: currentCate, fromMonth: currentBeginningMonth, toMonth: currentEndingMonth)
        typeCateTextField.resignFirstResponder()
    }
    
    @objc func onTypeCateCancelButtonPushed() {
        typeCateTextField.resignFirstResponder()
    }
    
    @objc func onBeginningMonthDoneButtonPushed() {
        let month = beginningMonthYearPicker.selectedRow(inComponent: 0) + 1
        let year = beginningMonthYearPicker.selectedRow(inComponent: 1) + 2018
        beginningTimeTextField.text = "\(month)/\(year)"
        currentBeginningMonth = "\(month)/\(year)"
        if CalendarHelper.compareDateFromString(currentBeginningMonth, currentEndingMonth) == .greater {
            currentEndingMonth = currentBeginningMonth
            endingTimeTextField.text = currentEndingMonth
        }
        reloadDataForTableView(type: currentType, cate: currentCate, fromMonth: currentBeginningMonth, toMonth: currentEndingMonth)
        beginningTimeTextField.resignFirstResponder()
    }
    
    @objc func onBeginningCancelButtonPushed() {
        beginningTimeTextField.resignFirstResponder()
    }
    
    @objc func onEndingMonthDoneButtonPushed() {
        let month = endingMonthYearPicker.selectedRow(inComponent: 0) + 1
        let year = endingMonthYearPicker.selectedRow(inComponent: 1) + 2018
        if CalendarHelper.compareDateFromString(currentBeginningMonth, "\(month)/\(year)") == .less {
            endingTimeTextField.text = "\(month)/\(year)"
            currentEndingMonth = "\(month)/\(year)"
            reloadDataForTableView(type: currentType, cate: currentCate, fromMonth: currentBeginningMonth, toMonth: currentEndingMonth)
        }
        endingTimeTextField.resignFirstResponder()
    }
    
    @objc func onEndingCancelButtonPushed() {
        endingTimeTextField.resignFirstResponder()
    }
    
    weak var actionToEnable: UIAlertAction!
    
    @IBAction func onChangeButtonPushed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Budget", message: "Enter your budget for a month.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField(configurationHandler: {(textField: UITextField) in
            textField.placeholder = "e.g. 700000 (0 if not)"
            textField.keyboardType = .numberPad
            textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (_) -> Void in
            
        })
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (_) -> Void in
            let textfield = alert.textFields!.first!
            
            let newBudget = Int(textfield.text!)
            UserDefaults.standard.set(newBudget, forKey: budgetKeyName)
            let spent = UserDefaults.standard.integer(forKey: spentKeyName)
            self.budgetLabel.text = "\(spent)/\(newBudget ?? 0)"
        })
        
        alert.addAction(cancel)
        alert.addAction(action)
        
        self.actionToEnable = action
        action.isEnabled = false
        self.present(alert, animated: true, completion: nil)
    }
    
    func initBalance() {
        let alert = UIAlertController(title: "Balance", message: "Enter your current balance.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField(configurationHandler: {(textField: UITextField) in
            textField.placeholder = "e.g. 700000"
            textField.keyboardType = .numberPad
            textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (_) -> Void in
            UserDefaults.standard.set(0, forKey: balanceKeyName)
        })
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (_) -> Void in
            let textfield = alert.textFields!.first!
            
            UserDefaults.standard.set(Int(textfield.text!), forKey: balanceKeyName)
            self.balanceLabel.text = textfield.text
        })
        
        alert.addAction(cancel)
        alert.addAction(action)
        
        self.actionToEnable = action
        action.isEnabled = false
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func textChanged(_ sender:UITextField) {
        if Int(sender.text!) != nil {
            self.actionToEnable?.isEnabled  = true
        } else {
            self.actionToEnable?.isEnabled = false
        }
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desViewController = segue.destination as! AddActivityViewController
        desViewController.sourceViewController = self
        if segue.identifier == "newActivitySegue" {
            desViewController.isNew = true
        }
    }
    
    // MARK: Helper
    func reloadDataForTableView(type: String, cate: String = "", fromMonth beginningMonth: String = "", toMonth endingMonth: String = "") {
        if type == "All" {
            activities = FinAct.fetchData(fromMonth: beginningMonth, toMonth: endingMonth)
        } else {
            activities = FinAct.fetchData(fromMonth: beginningMonth, toMonth: endingMonth, type: type, cate: cate)
        }
        
        activityTableView.reloadData()
    }
    
    func refreshFinStatement() {
        let balance = UserDefaults.standard.integer(forKey: balanceKeyName)
        let spent = UserDefaults.standard.integer(forKey: spentKeyName)
        let budget = UserDefaults.standard.integer(forKey: budgetKeyName)
        
        balanceLabel.text = "\(balance)"
        budgetLabel.text = "\(spent)/\(budget)"
    }
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
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath)
        (cell as! ActivityTableViewCell).loadContent(activity: activities[indexPath.row] as! FinAct)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! AddActivityViewController
        detailVC.isNew = false
        detailVC.sourceViewController = self
        detailVC.sourceData = activities[indexPath.row] as! FinAct
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let activity = activities[indexPath.row] as! FinAct
            let type = FinActivity.fromString(string: activity.type!)
            var balance = UserDefaults.standard.integer(forKey: balanceKeyName)
            var spent = UserDefaults.standard.integer(forKey: spentKeyName)
            let calendar = Calendar.current
            
            if type == .Income {
                balance = balance - Int(activity.cost)
                UserDefaults.standard.set(balance, forKey: balanceKeyName)
            } else {
                balance = balance + Int(activity.cost)
                UserDefaults.standard.set(balance, forKey: balanceKeyName)
                if calendar.component(.month, from: activity.date! as Date) == UserDefaults.standard.integer(forKey: monthSpendKeyName) {
                    spent = spent - Int(activity.cost)
                    UserDefaults.standard.set(spent, forKey: spentKeyName)
                }
            }
            
            DB.MOC.delete(activities[indexPath.row])
            activities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            refreshFinStatement()
            DB.save()
        }
    }
    
}

extension SummaryViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "finAct")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "You have no activity."
        let attribs = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.flatGray()] as [NSAttributedStringKey : Any]
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Add new finance activity by pressing Add button."
        
        let para = NSMutableParagraphStyle()
        para.lineBreakMode = .byWordWrapping
        para.alignment = .center
        
        let attribs = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.flatGrayColorDark(), NSAttributedStringKey.paragraphStyle: para]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
}
