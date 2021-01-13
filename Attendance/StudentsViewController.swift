//
//  StudentsViewController.swift
//  Attendance
//
//  Created by 김상원 on 2020/12/18.
//

import UIKit
import Firebase

class StudentsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let viewModel = StudentViewModel()
    let db = Database.database().reference()
    var studentID: Int = 0
    @IBAction func addStudent(_ sender: Any) {
        performSegue(withIdentifier: "addStudent", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.readStudents()
            self.tableView.delegate = self
            self.tableView.dataSource = self
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                self.tableView.reloadData()
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.readStudents()
            self.tableView.delegate = self
            self.tableView.dataSource = self
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailInfo" {
            let vc = segue.destination as? DetailStudentViewController
            vc?.studentID = studentID
            vc?.modalPresentationStyle = .fullScreen
            if let index = sender as? Int {
                let studentInfo = viewModel.studentInfo(at: index)
                vc?.viewModel.update(model: studentInfo)
            }
        }
        if segue.identifier == "addStudent" {
            let vc = segue.destination as? AddStudentViewController
            vc?.modalPresentationStyle = .fullScreen
        }
    }
}

extension StudentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.studentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.studentList[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        studentID = indexPath.row
        performSegue(withIdentifier: "detailInfo", sender: indexPath.item)
    }
    
}

extension StudentsViewController {
    func readStudents() {
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
//    func deleteStudent() {
//        if self.studentList.count == 0 {
//            return
//        } else {
//            db.child("students").child("\(0)").setValue(studentList[studentList.count-1].toDictionary)
//            db.child("students").child("\(studentList.count-1)").removeValue()
//            readStudents()
//        }
//
//    }
    
}
