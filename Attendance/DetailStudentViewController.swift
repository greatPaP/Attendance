//
//  DetailStudentViewController.swift
//  Attendance
//
//  Created by 김상원 on 2020/12/18.
//

import UIKit
import FSCalendar

class DetailStudentViewController: UIViewController {
    let viewModel = DetailStudentModel()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var classTimeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
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
        updateUI()
        calenderSetting()
        calenderView.delegate = self
        calenderView.dataSource = self
    }
}

extension DetailStudentViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func updateUI() {
        if let studentInfo = viewModel.studentInfo {
            nameLabel.text = studentInfo.name
            ageLabel.text = "\(studentInfo.age)"
            subjectLabel.text = studentInfo.subject
            classTimeLabel.text = studentInfo.classTime
            addressLabel.text = studentInfo.address
        } else { print("not studentInfo")}
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
        let mainClass: [String] = viewModel.studentInfo?.mainClass ?? [""]
        let additionalClass : [String] = viewModel.studentInfo?.additionalClass ?? [""]
        if mainClass.contains(strDate) && additionalClass.contains(strDate) {
            return "정규+보강"
        }
        else if mainClass.contains(strDate) {
            return "정규"
        }
        else if additionalClass.contains(strDate) {
            return "보강"
        } else { return ""}
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let strDate = self.formatter.string(from: date)
        let mainClass: [String] = viewModel.studentInfo?.mainClass ?? [""]
        let additionalClass : [String] = viewModel.studentInfo?.additionalClass ?? [""]
        if mainClass.contains(strDate) && additionalClass.contains(strDate) {
            return 2
        }
        else if mainClass.contains(strDate) {
            return 1
        }
        else if additionalClass.contains(strDate) {
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
        let mainClass: [String] = viewModel.studentInfo?.mainClass ?? [""]
        let additionalClass : [String] = viewModel.studentInfo?.additionalClass ?? [""]
        if mainClass.contains(strDate) && additionalClass.contains(strDate) {
            return [ .systemPink, .orange]
        }
        else if mainClass.contains(strDate) {
            return [.systemPink]
        }
        else if additionalClass.contains(strDate) {
            return [.orange]
        } else { return [.clear] }
    }
}

class DetailStudentModel {
    var studentInfo: StudentInfo?
    
    func update(model: StudentInfo?) {
        studentInfo = model
    }
}
