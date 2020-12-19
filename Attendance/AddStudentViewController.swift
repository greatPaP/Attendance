//
//  AddStudentViewController.swift
//  Attendance
//
//  Created by 김상원 on 2020/12/19.
//

import UIKit
import Firebase

class AddStudentViewController: UIViewController {

    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var ageLabel: UITextField!
    @IBOutlet weak var subjectLabel: UITextField!
    @IBOutlet weak var classTimeLabel: UITextField!
    @IBOutlet weak var addressLabel: UITextField!
    let db = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        saveStudent()
    }

    func saveStudent() {
        let student = StudentInfo(name: "김주한", age: 5, subject: "가베", classTime: "12:30", address: "서울시 강동구 고덕", mainClass: ["2020"], additionalClass: ["2020"])
        let student2 = StudentInfo(name: "김시완", age: 5, subject: "가베", classTime: "12:30", address: "서울시 강동구 고덕", mainClass: ["2020"], additionalClass: ["2020"])
        let student3 = StudentInfo(name: "박지성", age: 5, subject: "가베", classTime: "12:30", address: "서울시 강동구 고덕", mainClass: ["2020"], additionalClass: ["2020"])
        if student.name == "" {
            return
        } else {
            db.child("students").child("\(0)").setValue(student.toDictionary)
            db.child("students").child("\(1)").setValue(student2.toDictionary)
            db.child("students").child("\(2)").setValue(student3.toDictionary)
        }
    }
}
