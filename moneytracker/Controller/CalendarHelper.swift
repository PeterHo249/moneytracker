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
    
    static func getString(fromDate date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
}
