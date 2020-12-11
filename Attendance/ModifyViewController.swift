//
//  ModifyViewController.swift
//  Attendance
//
//  Created by 김상원 on 2020/12/05.
//

import UIKit
import Elliotable

class ModifyViewController: UIViewController {

    let viewModel = DetailViewModel()
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var explain: UITextField!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectColor(_ sender: Any) {
        let picker = UIColorPickerViewController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    @IBAction func saveButton(_ sender: Any) {
        var detailInfo = viewModel.scheduleInfo
        self.dismiss(animated: true, completion: nil)
        print(detailInfo)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }
    func updateUI() {
        if let detailInfo = viewModel.scheduleInfo {
            name.text = detailInfo.courseName
            explain.text = detailInfo.subName
            colorButton.tintColor = detailInfo.backgroundColor
            startTime.text = detailInfo.startTime
            endTime.text = detailInfo.endTime
            // 저장된 시간
            
            
        }
    }
    
    func updateArray() {
        if let detailInfo = viewModel.scheduleInfo {
//            let name: String = name.text!
            
            print(detailInfo.courseName)
            print(detailInfo.startTime)
            print(detailInfo.endTime)
            print(type(of: detailInfo))
            print(detailInfo)
        }
    }
}

extension ModifyViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
//            dismiss(animated: true, completion: nil)
    }
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
    }
}

class DetailViewModel {
    var scheduleInfo: ElliottEvent?
    
    func update(model: ElliottEvent?) {
        scheduleInfo = model
    }
}
