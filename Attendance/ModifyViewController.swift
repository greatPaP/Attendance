//
//  ModifyViewController.swift
//  Attendance
//
//  Created by 김상원 on 2020/12/05.
//

import UIKit
import Elliotable
import Firebase

class ModifyViewController: UIViewController, UIPickerViewDelegate {

    // segue를 통해서 ElliottEvent를 받아옴 (다시 readSchedule()을 할 필요없이 ElliottEvent를 수정해서 TimeTable로 변환 후 저장)
    let viewModel = DetailViewModel()
    @IBOutlet weak var DayofWeekPicker: UIPickerView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var explain: UITextField!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
//    @IBOutlet weak var colorButton: UIButton!
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectColor(_ sender: Any) {
        let picker = UIColorPickerViewController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    @IBAction func saveButton(_ sender: Any) {
        updateSchedule()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func deleteButton(_ sender: Any) {
        deleteSchedule()
        self.dismiss(animated: true, completion: nil)
    }
    
    let db = Database.database().reference()
    var courseId: Int = 99
    var courseDay: Int = 1
    // 기본 배경 값 지정 (0, 0, 0, 1) == black
    var redValue: CGFloat = 0.0
    var greenValue: CGFloat = 0.0
    var blueValue: CGFloat = 0.0
    var alphaValue: CGFloat = 1.0
    var daylist = ["월", "화", "수", "목", "금", "토"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        DayofWeekPicker.delegate = self
        DayofWeekPicker.dataSource = self
        // Do any additional setup after loading the view.
    }
    func updateUI() {
        if let detailInfo = viewModel.scheduleInfo {
            print("modifyupdateUI")
            name.text = detailInfo.courseName
            explain.text = detailInfo.subName
            colorButton.tintColor = detailInfo.backgroundColor
            startTime.text = detailInfo.startTime
            endTime.text = detailInfo.endTime
            redValue = CGFloat(detailInfo.backgroundColor.redValue)
            greenValue = CGFloat(detailInfo.backgroundColor.greenValue)
            blueValue = CGFloat(detailInfo.backgroundColor.blueValue)
            alphaValue = CGFloat(detailInfo.backgroundColor.alphaValue)
            courseDay = detailInfo.courseDay.rawValue
        }
    }
}

extension ModifyViewController: UIColorPickerViewControllerDelegate {
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

class DetailViewModel {
    var scheduleInfo: ElliottEvent?
    
    func update(model: ElliottEvent?) {
        scheduleInfo = model
    }
}

extension ModifyViewController: UIDocumentPickerDelegate, UIPickerViewDataSource {
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
    
    func updateSchedule() {
        if let schedule_info = viewModel.scheduleInfo {
            courseId = Int(schedule_info.courseId)!
            db.child("customers").child("\(schedule_info.courseId)").removeValue()
            let schedule = TimeTable(courseId: "\(courseId)", courseName: name.text!, subName: explain.text ?? "", startTime: startTime.text!, endTime: endTime.text!, courseDay: self.courseDay, colors: [Colors(redValue: self.redValue, greenValue: self.greenValue, blueValue: self.blueValue, alphaValue: self.alphaValue)])
            if schedule.courseName == "" {
                return
            } else {
                db.child("customers").child("\(courseId)").setValue(schedule.toDictionary)
            }
        }
    }
    
    func deleteSchedule() {
        if let schedule_info = viewModel.scheduleInfo {
            courseId = Int(schedule_info.courseId)!
            db.child("customers").child("\(schedule_info.courseId)").removeValue()
            let schedule = TimeTable(courseId: "\(courseId)", courseName: " ", subName: " ", startTime: "09:00", endTime: "17:00", courseDay: 6, colors: [Colors(redValue: 0.0, greenValue: 0.0, blueValue: 0.0, alphaValue: 0.0)])
            if schedule.courseName == "" {
                return
            } else {
                db.child("customers").child("\(courseId)").setValue(schedule.toDictionary)
            }
            
        }
    }
}
