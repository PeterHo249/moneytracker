//
//  SavingTableViewCell.swift
//  moneytracker
//
//  Created by Peter Ho on 9/8/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import UIKit
import ChameleonFramework

class SavingTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Outlet
    @IBOutlet weak var indicator: UIView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var ratePeriodLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func loadContent(activity: SavingAct) {
        descLabel.text = activity.desc
        costLabel.text = "\(activity.cost)"
        typeLabel.text = activity.type
        dateLabel.text = CalendarHelper.getString(fromDate: activity.date! as Date, format: "dd/MM/yyyy")
        switch SavingActivity.fromString(string: activity.type!) {
        case .Deposit:
            indicator.backgroundColor = UIColor.flatGreen()
            if activity.isInterested == true {
                ratePeriodLabel.text = "\(activity.rate)% - \(activity.period ?? "")"
            }
        case .Withdraw:
            indicator.backgroundColor = UIColor.flatRed()
        }
    }
}
