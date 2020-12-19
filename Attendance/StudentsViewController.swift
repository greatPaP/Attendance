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
    var studentList: [StudentInfo] = []
    let viewModel = StudentViewModel()
    let db = Database.database().reference()
    @IBAction func addStudent(_ sender: Any) {
        performSegue(withIdentifier: "addStudent", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        readStudents()
//        tableView.reloadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.readStudents()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.tableView.reloadData()
            }
        }
        
        
    }
}

extension StudentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(studentList.count)
        return studentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = studentList[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailInfo", sender: nil)
    }
    
}

extension StudentsViewController {
    public func readStudents() {
//        db.child("students").observeSingleEvent(of: .value) { snapshot in
//            if snapshot.exists() {
//                do {
//                    let data = try! JSONSerialization.jsonObject(with: data, options: []) // JSON --> Dictionary
//                    let decoder = JSONDecoder()
                    
                    
//                    let students: [StudentInfo] = try decoder.decode([StudentInfo].self, from: data)
//                    print("-->students: \(students)")
//                    self.studentList.append(contentsOf: students)
//                } catch let error {
//                    print("--> error: \(error.localizedDescription)")
//                }
//            }
//        }
//        db.child("students").observeSingleEvent(of: .value) { snapshot in
//            if snapshot.exists() {
//                do {
//                    print("exists")
//                    for child in snapshot.children {
//                        print(child)
//                        let data = try JSONSerialization.data(withJSONObject: child, options: [])
//                        let decoder = JSONDecoder()
//                        let students: [StudentInfo] = try decoder.decode([StudentInfo].self, from: data)
//                    }
//                } catch let error {
//                    print("--> error: \(error.localizedDescription)")
//                }
//            }
//        }
    }
}
