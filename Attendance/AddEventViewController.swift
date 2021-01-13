//
//  AddEventViewController.swift
//  Attendance
//
//  Created by 김상원 on 2021/01/12.
//

import UIKit
import Firebase

class AddEventViewController: UIViewController {
    let db = Database.database().reference()
    var studentInfo: [StudentInfo] = []
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var classPicker: UIPickerView!
    
    var studentID: Int = 0
    @IBAction func Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Add(_ sender: Any) {
        addEvent()
        self.dismiss(animated: true, completion: nil)
    }
    
    var classList: [String] = ["정규", "보강", "정규 + 보강"]
    var dateString: String = ""
    var className: String = "정규"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readStudent()
        classPicker.dataSource = self
        classPicker.delegate = self
        dateLabel.text = dateString
        // Do any additional setup after loading the view.
    }
}

extension AddEventViewController: UIPickerViewDelegate, UIPickerViewDataSource, UIDocumentPickerDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return classList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return classList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        className = classList[row]
    }
    
    func readStudent() {
        db.child("students").observeSingleEvent(of: .value) { snapshot in
//            self.viewModel.studentList = []
            if snapshot.exists() {
                do {
                    let data = try JSONSerialization.data(withJSONObject: snapshot.value, options: [])
                    let decoder = JSONDecoder()
                    let student: [StudentInfo] = try decoder.decode([StudentInfo].self, from: data)
                    self.studentInfo.append(student[self.studentID])
                    print(self.studentID)
                    print(self.studentInfo)
                } catch let error {
                    print("--> error: \(error.localizedDescription)")
                }
            }
        }
    }
    func addEvent() {
        if className == "정규" {
            self.studentInfo[0].mainClass.append(dateString)
        }
        else if className == "보강" {
            self.studentInfo[0].additionalClass.append(dateString)
        }
        else if className == "정규 + 보강" {
            self.studentInfo[0].mainClass.append(dateString)
            self.studentInfo[0].additionalClass.append(dateString)
        }
        print(studentInfo)
        db.child("students").child("\(studentID)").setValue(self.studentInfo[0].toDictionary)
        
    }
    
}
