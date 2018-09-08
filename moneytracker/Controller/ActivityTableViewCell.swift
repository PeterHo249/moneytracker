//
//  ActivityTableViewCell.swift
//  moneytracker
//
//  Created by Peter Ho on 9/5/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import UIKit
import ChameleonFramework

class ActivityTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }    
    
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    private func getColor(type: String, cate: String) -> UIColor {
        switch FinActivity.fromString(string: type) {
        case .Expense:
            switch ExpenseCate.fromString(string: cate) {
            case .Food:
                return UIColor.flatYellow()
            case .Travel:
                return UIColor.flatYellowColorDark()
            case .Vehicle:
                return UIColor.flatOrange()
            case .Utility:
                return UIColor.flatOrangeColorDark()
            case .Miscellaneous:
                return UIColor.flatRed()
            }
        case .Income:
            switch IncomeCate.fromString(string: cate) {
            case .Salary:
                return UIColor.flatGreen()
            case .Other:
                return UIColor.flatGreenColorDark()
            }
        }
    }
    
    func loadContent(activity: FinAct) {
        descLabel.text = activity.desc!
        costLabel.text = "\(activity.cost)"
        typeLabel.text = activity.type!
        categoryLabel.text = activity.category!
        dateLabel.text = CalendarHelper.getString(fromDate: activity.date! as Date)
        indicatorView.backgroundColor = getColor(type: activity.type!, cate: activity.category!)
    }
}
