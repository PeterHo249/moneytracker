//
//  SavingViewController.swift
//  moneytracker
//
//  Created by Peter Ho on 9/5/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import UIKit
import ChameleonFramework
import DZNEmptyDataSet
import CoreData

class SavingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        activities = SavingAct.all()
        refreshSavingLabel()
        savingTableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Outlet
    @IBOutlet weak var savingTableView: UITableView!
    @IBOutlet weak var accountLabel: UILabel!
    
    var activities:[NSManagedObject] = []
    
    // MARK: Helper
    func refreshSavingLabel() {
        accountLabel.text = "\(UserDefaults.standard.integer(forKey: savingKeyName))"
    }
    
    func reloadDataForTableView() {
        activities = SavingAct.all()
        
        savingTableView.reloadData()
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desViewController = segue.destination as! AddSavingViewController
        desViewController.isNew = true
        desViewController.sourceViewController = self
    }

}

extension SavingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavingTableViewCell", for: indexPath)
        (cell as! SavingTableViewCell).loadContent(activity: activities[indexPath.row] as! SavingAct)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension SavingViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "saving")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "You have no saving."
        let attribs = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.flatGray()] as [NSAttributedStringKey : Any]
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Add new saving activity by pressing Add button."
        
        let para = NSMutableParagraphStyle()
        para.lineBreakMode = .byWordWrapping
        para.alignment = .center
        
        let attribs = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.flatGrayColorDark(), NSAttributedStringKey.paragraphStyle: para]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
}
