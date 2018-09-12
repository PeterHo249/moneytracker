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
let savingHistoryKeyName = "user_saving_history"
let savingMonthKeyName = "user_saving_month"

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

enum SavingActivity:Int {
    case Deposit = 0
    case Withdraw
    
    static let all = [Deposit, Withdraw]
    static let strings = ["Deposit", "Withdraw"]
    
    func string() -> String {
        let index = SavingActivity.all.index(of: self) ?? 0
        return SavingActivity.strings[index]
    }
    
    static func fromString(string: String) -> SavingActivity {
        if let index = SavingActivity.strings.index(of: string) {
            return SavingActivity.all[index]
        }
        
        return SavingActivity.Deposit
    }
}

enum PeriodRef:Double {
    case Month1 = 2592000
    case Month3 = 7682400
    case Month6 = 15724800
    case Month12 = 31536000
    case Month24 = 62208000
    
    static let all = [Month1, Month3, Month6, Month12, Month24]
    static let strings = ["1 month", "3 months", "6 months", "12 months", "24 months"]
    
    func string() -> String {
        let index = PeriodRef.all.index(of: self) ?? 0
        return PeriodRef.strings[index]
    }
    
    static func fromString(string: String) -> PeriodRef {
        if let index = PeriodRef.strings.index(of: string) {
            return PeriodRef.all[index]
        }
        
        return PeriodRef.Month1
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
