//
//  ElliotDayOption.swift
//  Elliotable
//
//  Created by TaeinKim on 2019/11/03.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import Foundation

public enum ElliotDay: Int {
    case monday    = 1
    case tuesday   = 2
    case wednesday = 3
    case thursday  = 4
    case friday    = 5
    case saturday  = 6
    
    var description: String {
        switch self {
        case .monday:
            return "monday"
        case .tuesday:
            return "tuesday"
        case .wednesday:
            return "wednesday"
        case .thursday:
            return "thursday"
        case .friday:
            return "friday"
        case .saturday:
            return "saturday"
        }
    }
    
}

public enum ElliotDayType: Int {
    case normalType
    case shortType
    case shortestType
}
