//
//  ElliottEvent.swift
//  Elliotable
//
//  Created by TaeinKim on 2019/11/02.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import Foundation
import UIKit

public struct ElliottEvent {
    public let courseId  : String
    public var courseName: String
    public var subName  : String
    public var courseDay : ElliotDay
    public var startTime : String
    public var endTime   : String
    public var textColor      : UIColor
    public var backgroundColor: UIColor
    
    func changeColor(colors: UIColor) -> [String: Any] {
       let redValue: String = colors.redValue
       let greenValue: String = colors.greenValue
       let blueValue: String = colors.blueValue
       let alphaValue: String = colors.alphaValue
       return ["redValue": redValue, "greenValue": greenValue, "blueValue": blueValue, "alphaValue": alphaValue]
   }
    
    public var toDictionary: [String: Any] {
        let colorArray = changeColor(colors: self.backgroundColor)
        let dict: [String: Any] = ["courseId": courseId, "courseName": courseName, "subName": subName, "courseDay": courseDay.rawValue, "startTime": startTime, "endTime": endTime, "backgroundColor" : colorArray]
        return dict
    }
    public init(courseId: String, courseName: String, subName: String, courseDay: ElliotDay,startTime: String, endTime: String, backgroundColor: UIColor) {
        self.courseId        = courseId
        self.courseName      = courseName
        self.subName        = subName
        self.courseDay       = courseDay
        self.startTime       = startTime
        self.endTime         = endTime
        self.textColor       = UIColor.white
        self.backgroundColor = backgroundColor
    }
    
}


extension UIColor {
    var redValue: String{
        return "\(cgColor.components![0])"
        }
    var greenValue: String{
        return "\(cgColor.components! [1])"
    }

    var blueValue: String{
        return "\(cgColor.components! [2])"
    }

    var alphaValue: String{
        return "\(cgColor.components! [3])"
    }
}
