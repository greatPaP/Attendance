//
//  Students.swift
//  Attendance
//
//  Created by 김상원 on 2020/12/19.
//

import Foundation
import Firebase


struct StudentInfo: Codable {
    let name: String
    let age: Int
    let subject: String
    let classTime: String
    let address: String
    let mainClass: [String]
    let additionalClass: [String]
    
    
    init(name: String, age: Int, subject: String,classTime: String, address: String, mainClass: [String], additionalClass: [String]) {
        self.name = name
        self.age = age
        self.subject = subject
        self.classTime = classTime
        self.address = address
        self.mainClass = mainClass
        self.additionalClass = additionalClass
    }
    
    var toDictionary: [String: Any] {
        let dict: [String: Any] = ["name": name, "age": age, "subject": subject, "classTime": classTime, "address": address, "mainClass": mainClass, "additionalClass": additionalClass]
        return dict
    }
}

class StudentViewModel {
    let studentList: [StudentInfo] = [
    ]
    
    func studentInfo(at index: Int) -> StudentInfo {
        return studentList[index]
    }
    
}
