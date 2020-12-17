//
//  AddViewController.swift
//  Attendance
//
//  Created by 김상원 on 2020/12/07.
//

import UIKit
import Firebase
import Elliotable

class AddViewController: UIViewController, UIPickerViewDelegate {
    @IBOutlet weak var DayOfWeekPicker: UIPickerView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var explain: UITextField!
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
    @IBOutlet weak var colorButton: UIButton!
    @IBAction func Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    // 저장 버튼
    @IBAction func saveButton(_ sender: Any) {
        saveSchedule()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectColor(_ sender: Any) {
        let picker = UIColorPickerViewController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    // firebase 연동
    let db = Database.database().reference()
    var courseId: Int = 0
    var courseDay: Int = 1
    // 기본 배경 값 지정 (0, 0, 0, 1) == black
    var redValue: CGFloat = 0.0
    var greenValue: CGFloat = 0.0
    var blueValue: CGFloat = 0.0
    var alphaValue: CGFloat = 1.0
    var daylist = ["월", "화", "수", "목", "금", "토"]

    override func viewDidLoad() {
        super.viewDidLoad()
        DayOfWeekPicker.delegate = self
        DayOfWeekPicker.dataSource = self
        readSchedule()
    }
}

extension AddViewController: UIDocumentPickerDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return daylist.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return daylist[row]
    }
    
    // 요일에 대한 값 저장
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        courseDay = daylist.firstIndex(of: daylist[row]) ?? 1
        courseDay += 1
    }

    // 스케쥴 저장 함수
    func saveSchedule() {
        let schedule = TimeTable(courseId: "\(self.courseId)", courseName: name.text!, subName: explain.text ?? "", startTime: startTime.text!, endTime: endTime.text!, courseDay: self.courseDay, colors: [Colors(redValue: self.redValue, greenValue: self.greenValue, blueValue: self.blueValue, alphaValue: self.alphaValue)])
        if schedule.courseName == "" {
            return
        } else {
            db.child("customers").child("\(self.courseId)").setValue(schedule.toDictionary)
        }
    }
    
    // courseId를 갱신하기 위해서 사용
    func readSchedule() {
        var schedule_list: [TimeTable] = []
        db.child("customers").observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                do {
                    let data = try JSONSerialization.data(withJSONObject: snapshot.value, options: [])
                    let decoder = JSONDecoder()
                    let customers: [TimeTable] = try decoder.decode([TimeTable].self, from: data)
                    schedule_list.append(contentsOf: customers)
                    self.courseId = schedule_list.count
                } catch let error {
                    print("--> error: \(error.localizedDescription)")
                }
            }
        }
    }
}

extension AddViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        colorButton.tintColor = UIColor(displayP3Red: self.redValue, green: self.greenValue, blue: self.blueValue, alpha: self.alphaValue)
    }
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let selectedcolor = viewController.selectedColor
        self.redValue = selectedcolor.redValue
        self.greenValue = selectedcolor.greenValue
        self.blueValue = selectedcolor.blueValue
        self.alphaValue = selectedcolor.alphaValue
    }
}


extension UIColor {
    var redValue: CGFloat{
            return cgColor.components![0]
        }
    var greenValue: CGFloat{
        return cgColor.components! [1]
    }

    var blueValue: CGFloat{
        return cgColor.components! [2]
    }

    var alphaValue: CGFloat{
        return cgColor.components! [3]
    }
}
