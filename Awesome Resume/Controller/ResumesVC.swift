//
//  ResumesVC.swift
//  Awesome Resume
//
//  Created by BOYA CHEN on 8/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit

// ---------------------- DEMO DATA --------------------------

var resumeStyleSheet: [[String: Any]] = [
    [ "bold": false, "italic": false, "size": 17 ], // regular and
    [ "bold": false, "italic": false, "size": 15 ],
    [ "bold": true, "italic": true, "size": 17 ],
    [ "bold": false, "italic": true, "size": 17 ]
]



var resumeData: [[String: Any]] = [
    [
        "type": "resumeTitle",
        "name": "THANH 'STEVE' DANG",
        "addr": "15 John Street, East Brunswick, VIC 3057. Mobile: 0403.496.746"
    ],
    [
        "type": "education",
        "eduItems": [
            [
                "organization": "UNIVERSITY OF MELBOURNE",
                "title": "Master of IT",
                "time": "2016-2017",
                "location": "Melbourne Australia",
                "description": "- Master of Information Technology, expected December 2017, The University of Melbourne (informally Melbourne University) is a public research university located in Melbourne, Australia. Founded in 1853, it is Australia's second oldest university and the oldest in Victoria.[7] Times Higher Education ranks Melbourne as 33rd in the world,[8] while the Academic Ranking of World Universities places Melbourne 40th in the world (both first in Australia).[9]"
            ],
            [
                "organization": "DICKINSON COLLEGE",
                "title": "International Business & Management",
                "time": "2010-2014",
                "location": "USA",
                "description": "- B.A in International Business & Management"
            ],
            [
                "organization": "STATE UNIVERSITY OF NEW YORK",
                "title": "B.S of Finance",
                "time": "2010-2014",
                "location": "USA",
                "description": "- Studied B.S in Finance"
            ]
        ]
    ],
    [
        "type": "experience",
        "expItems": [
            [
                "organization": "UNIVERSITY OF MELBOURNE",
                "title": "Student Service Delivery Assistant",
                "time": "2016-2017",
                "location": "Melbourne, Australia",
                "description": "- Performing a range of professional duties including customer service, administrative support, data entry and event support in work units and service points across Academic Services\n- Delivering accurate and timely information to students by drawing on the knowledge and experience of service teams within Academic Services"
            ]
        ]
    ]
]


class ResumesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewCellDelegate, SaveDataDelegate {
    
    var rowHeights = [CGFloat]()
    
    func updateCellHeights(height: CGFloat, index: Int) {
        rowHeights[index] = height
        resumeTableView.beginUpdates()
        resumeTableView.endUpdates()
    }
    
    /*
     -------------------------------------------------------------------
     -------------- Resume Page Table View Controller ------------------
     -------------------------------------------------------------------
    */
    
    @IBOutlet weak var resumeTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resumeData.count
    }
    
    // ------------- Insert Items into table views
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if resumeData[indexPath.row]["type"] as! String == "resumeTitle" {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ResumeTableCellTitle", for: indexPath) as? ResumeTableCellTitle{
                cell.configCell(name: (resumeData[indexPath.row]["name"] as? String)!, address: ( resumeData[indexPath.row]["addr"] as? String )! )
                return cell
            }
        }
        else if resumeData[indexPath.row]["type"] as! String == "education" {
            
//            let cell = ResumeTableCellEducation()
//            cell.cellIndex = indexPath.row
//            cell.configCell(eduInfo: resumeData[indexPath.row]["eduItems"] as! [[String: String]])
//            return cell
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ResumeTableCellEducation", for: indexPath) as? ResumeTableCellEducation{
//                cell.delegate = self
                cell.cellIndex = indexPath.row
                cell.configCell(eduInfo: resumeData[indexPath.row]["eduItems"] as! [[String: String]])
                rowHeights[indexPath.row] = cell.getCellHeight()
                resumeTableView.reloadRows(at: [indexPath], with: .fade)
                return cell
            }
        }
        else if resumeData[indexPath.row]["type"] as! String == "experience" {
            
//            let cell = ResumeTableCellExp()
//            cell.cellIndex = indexPath.row
//            cell.configCell(eduExp: resumeData[indexPath.row]["expItems"] as! [[String: String]])
//            return cell
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ResumeTableCellExp", for: indexPath) as? ResumeTableCellExp{
//                cell.delegate = self
                cell.cellIndex = indexPath.row
                cell.configCell(eduExp: resumeData[indexPath.row]["expItems"] as! [[String: String]])
                rowHeights[indexPath.row] = cell.getCellHeight()
                resumeTableView.reloadRows(at: [indexPath], with: .fade)
                return cell
            }
        }
        return UITableViewCell()
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if resumeData[indexPath.row]["type"] as! String == "resumeTitle" {
            return 100
        }
//        else if resumeData[indexPath.row]["type"] as! String == "education" {
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "ResumeTableCellEducation", for: indexPath) as? ResumeTableCellEducation {
//                return CGFloat(cell.getCellHeight())
//            }
//            return 100
//        }
//        else if resumeData[indexPath.row]["type"] as! String == "experience" {
//
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "ResumeTableCellExp", for: indexPath) as? ResumeTableCellExp{
//                return CGFloat(cell.getCellHeight())
//            }
//            return 100
//        }
//        else{
//            return 100
//        }
        else{
            return rowHeights[indexPath.row]
        }
    }
    
    // -------------- Header Part
    @IBOutlet weak var resumePageTitle: UILabel?
    @IBOutlet weak var resumePageEditBtn: UIButton?
    @IBAction func EditBtnAction(_ sender: UIButton) {
        
    }
    
    func receiveCellCall(info: String){
        print("Here!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting navigtion bar style
        self.navigationController?.navigationBar.tintColor = UIColor(red:0.57, green:0.07, blue:0.04, alpha:1.0)
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: ""), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "")
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font : UIFont(name: "Avenir-bold", size: 23) ?? UIFont.systemFont(ofSize: 20)
        ]
        
         // -- Clean the left back button title
//        let newBackBtn = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.done, target: nil, action: #selector(backBtnAlertAct))
//        self.navigationItem.backBarButtonItem = newBackBtn
        
        for _ in 1...resumeData.count {
            rowHeights.append(800)
        }
        self.resumeTableView.rowHeight = UITableViewAutomaticDimension
        self.resumeTableView.estimatedRowHeight = 35
        
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueID:String = segue.identifier!
        print(segueID)
        switch segueID {
        case "AddEducation":
            // -- Change Title
            let destinationVC = segue.destination as? EditMode1VC
            destinationVC?.configureData(type: "adding_education")
            destinationVC?.navigationItem.title = "Education"
            // -- Adding Save Button
            destinationVC?.navigationItem.prompt = "Adding your education information"
            destinationVC?.delegate = self
//        case "AddExperience":
//            let destinationVC = segue.destination as? EditMode1VC
        case "AddExperience":
            // -- Change Title
            let destinationVC = segue.destination as? EditMode1VC
            destinationVC?.configureData(type: "adding_experience")
            destinationVC?.navigationItem.title = "Experience"
            destinationVC?.navigationItem.prompt = "Adding your experience information"
            destinationVC?.delegate = self
        default:
            print ("Other Segue Selected!")
        }
        // self.navigationItem.title = sugueID
    }
    
    // ::: Delegate Method from EditMode1VC
    func saveBtnPressed(data: [String: String], dataType: String, isSave: Bool) {
        print("::Data Received! \(data)")
        if (isSave){
            switch dataType {
            case "adding_education":
                // Adding to the education items
//                print (resumeData[1]["eduItems"] ?? "No")
                var oldData: [[String: String]] = resumeData[1]["eduItems"]! as! [[String : String]]
                oldData.append(data)
                resumeData[1]["eduItems"] = oldData
                print (resumeData)
                let indexPath = IndexPath(item: 1, section: 0)
                resumeTableView.reloadRows(at: [indexPath], with: .fade)
//                resumeTableView.beginUpdates()
//                resumeTableView.endUpdates()
                rowHeights[1] += 200
            case "adding_experience":
                print ("------")
            default:
                print("Invalid save")
            }
        }else{
            print (":: Item not be saved because it is empty")
        }
    }
}











