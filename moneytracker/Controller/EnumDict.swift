//
//  EnumDict.swift
//  moneytracker
//
//  Created by Peter Ho on 9/5/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import Foundation

let balanceKeyName = "user_balance"
let budgetKeyName = "user_budget"
let savingKeyName = "user_saving"
let spentKeyName = "user_spent"
let monthSpendKeyName = "user_month_of_spend"

enum FinActivity:Int {
    case Income = 1
    case Expense = 2
    
    static let all = [Income, Expense]
    static let strings = ["Income", "Expense"]
    
    func string() -> String {
        let index = FinActivity.all.index(of: self) ?? 0
        return FinActivity.strings[index]
    }
    
    static func fromString(string: String) -> FinActivity {
        if let index = FinActivity.strings.index(of: string) {
            return FinActivity.all[index]
        }
        
        return FinActivity.Income
    }
}

enum IncomeCate:Int {
    case Salary = 0
    case Other = 1
    
    static let all = [Salary, Other]
    static let strings = ["Salary", "Other"]
    
    func string() -> String {
        let index = IncomeCate.all.index(of: self) ?? 0
        return IncomeCate.strings[index]
    }
    
    static func fromString(string: String) -> IncomeCate {
        if let index = IncomeCate.strings.index(of: string) {
            return IncomeCate.all[index]
        }
        
        return IncomeCate.Salary
    }
}

enum ExpenseCate:Int {
    case Food = 0
    case Travel
    case Vehicle
    case Utility
    case Miscellaneous
    
    static let all = [Food, Travel, Vehicle, Utility, Miscellaneous]
    static let strings = ["Food", "Travel", "Vehicle", "Utility", "Miscellaneous"]
    
    func string() -> String {
        let index = ExpenseCate.all.index(of: self) ?? 0
        return ExpenseCate.strings[index]
    }
    
    static func fromString(string: String) -> ExpenseCate {
        if let index = ExpenseCate.strings.index(of: string) {
            return ExpenseCate.all[index]
        }
        
        return ExpenseCate.Food
    }
}

enum MyComparisionResult {
    case less
    case equal
    case greater
    case notCompare
}
