//
//  DetailStudentViewController.swift
//  Attendance
//
//  Created by 김상원 on 2020/12/18.
//

import UIKit
import FSCalendar

class DetailStudentViewController: UIViewController {

    var studentName: String?
    @IBOutlet weak var name: UILabel!
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    @IBOutlet weak var calenderView: FSCalendar!
    var events: [String] = ["2020-12-24", "2020-12-16"]
    var otherEvents: [String] = ["2020-12-24", "2020-12-18"]
    override func viewDidLoad() {
        super.viewDidLoad()
        calenderSetting()
        calenderView.delegate = self
        calenderView.dataSource = self
        updateUI()
    }
}

extension DetailStudentViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func updateUI() {
        if let studentName = studentName {
            name.text = studentName
        }
    }
    func calenderSetting() {
        // 선택한 날짜 색상
        calenderView.appearance.selectionColor = UIColor.systemTeal
        // 오늘 날짜 색상
        calenderView.appearance.todayColor = UIColor.systemPink
        
        // header 변경
        calenderView.headerHeight = 80
        calenderView.appearance.headerDateFormat = "YYYY년 M월" // header 날짜 표시
        calenderView.appearance.headerTitleColor = .systemPink // 헤더 글씨 색상
        calenderView.appearance.headerMinimumDissolvedAlpha = 0.0 // 이전달, 다음달 표시
        calenderView.appearance.headerTitleFont = UIFont.systemFont(ofSize: 22)
        
        // 요일 변경
        calenderView.locale = Locale(identifier: "ko_KR")
        calenderView.appearance.weekdayTextColor = .orange
        calenderView.appearance.titleWeekendColor = .red
        
        // 스크롤 작동 여부
        calenderView.scrollEnabled = true
        // 스크롤 작동 방향
        calenderView.scrollDirection = .horizontal
    }

    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let strDate = self.formatter.string(from: date)

        if events.contains(strDate) && otherEvents.contains(strDate) {
            return "정규+보강"
        }
        else if events.contains(strDate) {
            return "정규"
        }
        else if otherEvents.contains(strDate) {
            return "보강"
        } else { return ""}
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let strDate = self.formatter.string(from: date)

        if events.contains(strDate) && otherEvents.contains(strDate) {
            return 2
        }
        else if events.contains(strDate) {
            return 1
        }
        else if otherEvents.contains(strDate) {
            return 1
        } else { return 0}
    }
    
    // 날짜 선택시
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(formatter.string(from: date) + " 선택")
    }
    
    // Event 별 컬러 변경 (날짜 하단)
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance,eventDefaultColorsFor date: Date) -> [UIColor]?
    {
        let strDate = formatter.string(from: date)

        if events.contains(strDate) && otherEvents.contains(strDate) {
            return [ .systemPink, .orange]
        }
        else if events.contains(strDate) {
            return [.systemPink]
        }
        else if otherEvents.contains(strDate) {
            return [.orange]
        } else { return [.clear] }
    }
    // 큰 원으로 표현
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
//        let strDate = formatter.string(from: date)
//
//        if events.contains(strDate) && otherEvents.contains(strDate) {
//            return UIColor(displayP3Red: 0.7690608501434326, green: 0.3714240789413452, blue: 0.9642888903617859, alpha: 1.0)
//        }
//        else if events.contains(strDate) {
//            return UIColor(displayP3Red: 0.8717051148414612, green: 0.4707827568054199, blue: 0.6163464188575745, alpha: 1.0)
//        }
//        else if otherEvents.contains(strDate) {
//            return UIColor(displayP3Red: 0.9658096432685852, green: 0.7889586091041565, blue: 0.513181746006012, alpha: 1.0)
//        }
//
//        return .none
//    }
}
