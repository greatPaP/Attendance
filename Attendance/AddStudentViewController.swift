//
//  AddStudentViewController.swift
//  Attendance
//
//  Created by 김상원 on 2020/12/19.
//

import UIKit
import Firebase

class AddStudentViewController: UIViewController {

    let viewModel = StudentViewModel()
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var ageLabel: UITextField!
    @IBOutlet weak var subjectLabel: UITextField!
    @IBOutlet weak var classTimeLabel: UITextField!
    @IBOutlet weak var addressLabel: UITextField!
    @IBAction func saveButton(_ sender: Any) {
        saveStudent()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    let db = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readStudent()
    }

    
}

extension AddStudentViewController {
    func readStudent() {
        db.child("students").observeSingleEvent(of: .value) { snapshot in
            self.viewModel.studentList = []
            if snapshot.exists() {
                do {
                    let data = try JSONSerialization.data(withJSONObject: snapshot.value, options: [])
                    let decoder = JSONDecoder()
                    let customers: [StudentInfo] = try decoder.decode([StudentInfo].self, from: data)
                    self.viewModel.studentList.append(contentsOf: customers)
                } catch let error {
                    print("--> error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func saveStudent() {
        let student = StudentInfo(name: nameLabel.text ?? "", age: ageLabel.text!, subject: subjectLabel.text!, classTime: classTimeLabel.text!, address: addressLabel.text!, mainClass: [""], additionalClass: [""])
        let id = self.viewModel.studentList.count
        if student.name == "" {
            return
        } else {
            db.child("students").child("\(id)").setValue(student.toDictionary)
            
        }
    }
}
