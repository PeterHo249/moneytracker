//
//  MonthHelper.swift
//  moneytracker
//
//  Created by Peter Ho on 9/8/18.
//  Copyright © 2018 Peter Ho. All rights reserved.
//

import Foundation

class CalendarHelper {
    static func compareDateFromString(_ lhs: String, _ rhs: String) -> MyComparisionResult {
        let lhsComponents = getCalendarComponents(fromString: lhs)
        let rhsComponents = getCalendarComponents(fromString: rhs)
        
        if lhsComponents.count != rhsComponents.count {
            return .notCompare
        }
        
        if lhsComponents.count == 1 {
            if lhsComponents[0] > rhsComponents[0] {
                return .greater
            } else if lhsComponents[0] == rhsComponents[0] {
                return .equal
            } else {
                return .less
            }
        }
        
        if lhsComponents.count == 2 {
            if lhsComponents[1] > rhsComponents[1] {
                return .greater
            } else if lhsComponents[1] < rhsComponents[1] {
                return .less
            } else {
                if lhsComponents[0] > rhsComponents[0] {
                    return .greater
                } else if lhsComponents[0] == rhsComponents[0] {
                    return .equal
                } else {
                    return .less
                }
            }
        }
        
        if lhsComponents.count == 3 {
            if lhsComponents[2] > rhsComponents[2] {
                return .greater
            } else if lhsComponents[2] < rhsComponents[2] {
                return .less
            } else {
                if lhsComponents[1] > rhsComponents[1] {
                    return .greater
                } else if lhsComponents[1] < rhsComponents[1] {
                    return .less
                } else {
                    if lhsComponents[0] > rhsComponents[0] {
                        return .greater
                    } else if lhsComponents[0] == rhsComponents[0] {
                        return .equal
                    } else {
                        return .less
                    }
                }
            }
        }
        
        return .notCompare
    }
    
    static func getCalendarComponents(fromString string: String) -> [Int] {
        let stringComponents = (string as NSString).components(separatedBy: "/")
        if stringComponents.count == 0 {
            return []
        } else {
            var intComponents:[Int] = []
            for component in stringComponents {
                intComponents.append(Int(component)!)
            }
            return intComponents
        }
    }
    
    static func getString(fromDate date: Date, format: String = "dd/MM/yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    static func getBiginningDate(ofMonth month: String) -> NSDate {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "HH:mm dd/MM/yyyy"
        
        let result:NSDate = dateFormatter.date(from: "00:00 01/\(month)")! as NSDate
        return result
    }
    
    static func isLeapYear(year: Int) -> Bool {
        if year % 400 == 0 {
            return true
        }
        
        if year % 100 == 0 {
            return false
        }
        
        if year % 4 == 0 {
            return true
        }
        
        return false
    }
    
    static func getEndingDate(ofMonth month: String) -> NSDate {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "HH:mm dd/MM/yyyy"
        
        let numDayRef = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        let components = getCalendarComponents(fromString: month)
        var dateString: String = ""
        if isLeapYear(year: components[1]) && components[0] == 2 {
            dateString = "23:59 29/\(month)"
        } else {
            dateString = "23:59 \(numDayRef[components[0]])/\(month)"
        }
        
        let result: NSDate = dateFormatter.date(from: dateString)! as NSDate
        return result
    }
}
