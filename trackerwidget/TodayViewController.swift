//
//  TodayViewController.swift
//  trackerwidget
//
//  Created by Peter Ho on 9/13/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        displayContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        displayContent()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    // MARK: Outlet
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var spentLabel: UILabel!
    @IBOutlet weak var spentProgress: UIProgressView!
    
    let balanceKeyName = "user_balance"
    let budgetKeyName = "user_budget"
    let spentKeyName = "user_spent"
    let userDefaults = UserDefaults(suiteName: "group.peterho.moneytracker")!
    
    func displayContent() {
        let balance = userDefaults.integer(forKey: balanceKeyName)
        let budget = userDefaults.integer(forKey: budgetKeyName)
        let spent = userDefaults.integer(forKey: spentKeyName)
        
        balanceLabel.text = "\(balance)"
        spentLabel.text = "\(spent)/\(budget)"
        
        if budget == 0 {
            spentProgress.progress = 1
            spentProgress.tintColor = UIColor.red
        } else {
            let progress:Float = Float(spent) / Float(budget)
            spentProgress.progress = progress
            if progress <= 0.6 {
                spentProgress.tintColor = UIColor.green
            } else {
                if progress <= 0.8 {
                    spentProgress.tintColor = UIColor.yellow
                } else {
                    spentProgress.tintColor = UIColor.red
                }
            }
        }
    }
    
    @IBAction func onTapRecognized(_ sender: UITapGestureRecognizer) {
        self.extensionContext?.open(URL(string: "peterho.moneytracker://")!, completionHandler: nil)
    }
}
