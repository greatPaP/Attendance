//
//  TimeTable.swift
//  Attendance
//
//  Created by 김상원 on 2020/12/07.
//

import Foundation
import Elliotable

struct TimeTable: Codable {
    let courseId: String
    let courseName: String
    let subName: String
    let startTime: String
    let endTime: String
    let courseDay: Int
    let colors: [Colors]

    var toDictionary: [String: Any] {
        let colorArray = colors.map { $0.toDictionary}
        let dict: [String: Any] = ["courseId": courseId, "courseName": courseName, "subName": subName, "startTime": startTime, "endTime": endTime, "courseDay": courseDay, "colors": colorArray]
        return dict
    }
}

struct Colors: Codable {
    let redValue: CGFloat
    let greenValue: CGFloat
    let blueValue: CGFloat
    let alphaValue: CGFloat
    
    var toDictionary: [String: Any] {
        let dict: [String: Any] = ["redValue": redValue, "greenValue": greenValue, "blueValue": blueValue, "alphaValue": alphaValue]
        return dict
    }
}
