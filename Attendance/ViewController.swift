//
//  ViewController.swift
//  Attendance
//
//  Created by 김상원 on 2020/12/04.
//

import UIKit
import Elliotable
import Firebase

class ViewController: UIViewController {
    let db = Database.database().reference()
    var scheduleList2: [ElliottEvent] = []
    @IBOutlet weak var elliotable: Elliotable!
    // 요일 텍스트 정의
    private let daySymbol = ["월", "화", "수", "목", "금", "토"]
    
    @IBAction func about(_ sender: Any) {
        performSegue(withIdentifier: "AddView", sender: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global().async {
            self.readSchedule()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.elliotable.reloadData()
            }
        }
        elliotable.delegate = self
        elliotable.dataSource = self
        timetable_setting()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global().async {
            self.readSchedule()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.elliotable.reloadData()
            }
        }
        elliotable.delegate = self
        elliotable.dataSource = self
        elliotable.reloadData()
        timetable_setting()
    }
}

extension ViewController: ElliotableDelegate {
    
    func elliotable(elliotable: Elliotable, didSelectCourse selectedCourse: ElliottEvent) {
        performSegue(withIdentifier: "showDetail", sender: selectedCourse)
    }
    
    func elliotable(elliotable: Elliotable, didLongSelectCourse longSelectedCourse: ElliottEvent) {
        print("Long Good")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destination as? ModifyViewController
            vc?.modalPresentationStyle = .fullScreen
            if let schedule = sender as? ElliottEvent {
                vc?.viewModel.update(model: schedule)
            }
        } else if segue.identifier == "AddView" {
            let vc = segue.destination as? AddViewController
            vc?.modalPresentationStyle = .fullScreen
        } else {
            return
        }

    }
}

// Read Data
extension ViewController {
    func readSchedule() {
        var schedule_list: [TimeTable] = []
        db.child("customers").observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                do {
                    let data = try JSONSerialization.data(withJSONObject: snapshot.value, options: [])
                    let decoder = JSONDecoder()
                    let customers: [TimeTable] = try decoder.decode([TimeTable].self, from: data)
                    schedule_list.append(contentsOf: customers)
                    
                    for item in 0...schedule_list.count-1{
                        let event = ElliottEvent(courseId: schedule_list[item].courseId, courseName: schedule_list[item].courseName, subName: schedule_list[item].subName, courseDay: ElliotDay.init(rawValue: schedule_list[item].courseDay)!, startTime: schedule_list[item].startTime, endTime: schedule_list[item].endTime, backgroundColor: UIColor(displayP3Red: schedule_list[item].colors[0].redValue, green: schedule_list[item].colors[0].greenValue, blue: schedule_list[item].colors[0].blueValue, alpha: schedule_list[item].colors[0].alphaValue))
                        self.scheduleList2.append(event)
                    }
                } catch let error {
                    print("--> error: \(error.localizedDescription)")
                }
            }
        }
    }
}

extension ViewController: ElliotableDataSource {
    // 강의 아이템 적용
    func courseItems(in elliotable: Elliotable) -> [ElliottEvent] {
        return self.scheduleList2
    }
    
    // 요일 부분 설정
    func elliotable(elliotable: Elliotable, at dayPerIndex: Int) -> String {
        return self.daySymbol[dayPerIndex]
    }
    
    // 요일 부분 설정
    func numberOfDays(in elliotable: Elliotable) -> Int {
        return self.daySymbol.count
    }
    
    func timetable_setting() {
        // Table Item
        elliotable.elliotBackgroundColor = UIColor.white // 시간표 배경색상
        elliotable.borderWidth = 0.5
        elliotable.borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0) // 선 색상
        
        // Course Item Properties
        elliotable.textEdgeInsets = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10) // 글씨 위치
        elliotable.courseItemMaxNameLength = 18
        elliotable.courseItemTextSize      = 10
        elliotable.courseTextAlignment     = .center
        
        
        // 시간표 강의 아이템 라운드
        elliotable.roundCorner = .none
//        elliotable.borderCornerRadius = 24
//        elliotable.roomNameFontSize = 8
        elliotable.isFullBorder = true // 외부 border 여부
        elliotable.symbolFontSize = 14 // 요일 폰트 사이즈
        elliotable.symbolTimeFontSize = 12 // 왼쪽 시간 폰트 사이즈
        elliotable.symbolFontColor = UIColor(displayP3Red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0) // 요일 폰트 색상
        elliotable.symbolTimeFontColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0) // 왼쪽 시간 폰트 색상
        elliotable.symbolBackgroundColor = UIColor(named: "main_bg") ?? .white // 시간, 요일 배경색상
    }
}
