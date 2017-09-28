//
//  ResumesVC.swift
//  Awesome Resume
//
//  Created by BOYA CHEN on 8/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit

class ResumesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SaveDataDelegate {
    
    // ---- Demo Data
    var resumeData: [[String: Any]] = [
        [
            "type": "resumeTitle",
            "titleItems": [
                [
                "name": "BOYA 'CLAUDE' CHEN",
                "addr": "2 Cobden st., North Melbourne, VIC 3051, Mobile: 0413448518"
                ]
            ]
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
                    "organization": "UESTC",
                    "title": "Computer Science and Technology",
                    "time": "2011-2015",
                    "location": "Chengdu China",
                    "description": "- B.A in Computer science and Technology"
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
    
    var resumeSections = ["header", "EDUCATION", "EXPERIENCE"]
    var resumeSectionData: [Int: [[String: String]]] = [:]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print ("resume page loaded!")
        
        resumeTableView.delegate = self
        resumeTableView.dataSource = self
        
        
        // Navigation Bar Style
        self.navigationController?.navigationBar.tintColor = UIColor(red:0.57, green:0.07, blue:0.04, alpha:1.0)
//        self.navigationController?.navigationBar.titleTextAttributes = [
//            NSAttributedStringKey.font: UIFont(name: "Palatino-bold", size: 20)
//        ]
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem?.action = #selector(EditBtnAction)
        updateSectionData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.resumeTableView.isEditing = false
        self.navigationItem.rightBarButtonItem?.title = "Edit"
    }
    
    // -------------- Header Part
    @IBOutlet weak var resumePageTitle: UILabel?
    @IBOutlet weak var resumePageEditBtn: UIButton?
    @objc func EditBtnAction(sender: UIBarButtonItem) {
        if (self.resumeTableView.isEditing == false){
            self.resumeTableView.isEditing = true
            sender.title = "Done"
        }else{
            self.resumeTableView.isEditing = false
            sender.title = "Edit"
        }
    }
    
    func sortItems(items: [String: String]) -> [String: String] {
        // This function is used to sort the items in terms of Time
        return  [:]
    }
    
    func updateSectionData(){
        self.resumeSectionData = [
            0: resumeData[0]["titleItems"] as! Array<[String : String]>,
            1: resumeData[1]["eduItems"] as! Array<[String : String]>,
            2: resumeData[2]["expItems"] as! Array<[String : String]>
        ]
    }
    
    func updateToOrigin() {
        resumeData[0]["titleItems"] = self.resumeSectionData[0]
        resumeData[1]["eduItems"] = self.resumeSectionData[1]
        resumeData[2]["expItems"] = self.resumeSectionData[2]
    }
    
    /*
     -------------------------------------------------------------------
     -------------- Resume Page Table View Controller ------------------
     -------------------------------------------------------------------
    */
    
    @IBOutlet weak var resumeTableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return resumeSectionData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (resumeSectionData[section]?.count)!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView()
        headerView.configHeader(headerTitleString: resumeSections[section], cellType: resumeSections[section])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            return 30
        }
    }
    
    // -- Rows for each section
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = resumeTableView.dequeueReusableCell(withIdentifier: "ResumeTableCellTitle") as? ResumeTableCellTitle else{
                return ResumeTableCellTitle()
            }
            cell.configCell(data: resumeSectionData[indexPath.section]![indexPath.row])
            return cell
        case 1:
            guard let cell = resumeTableView.dequeueReusableCell(withIdentifier: "EduSectionCell") as? EduSectionCell else{
                return EduSectionCell()
            }
            cell.configCell(data: resumeSectionData[indexPath.section]![indexPath.row], tag: indexPath.row)
            return cell
        case 2:
            guard let cell = resumeTableView.dequeueReusableCell(withIdentifier: "ExpSectionCell") as? ExpSectionCell else{
                return ExpSectionCell()
            }
            cell.configCell(data: resumeSectionData[indexPath.section]![indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    // ::TV:: Height for row setting
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 110
        }
        else if indexPath.section == 1{
            guard let cell = resumeTableView.dequeueReusableCell(withIdentifier: "EduSectionCell") as? EduSectionCell else{
                return 150
            }
            return computeCellHeight(resumeSectionData[indexPath.section]![indexPath.row]["description"]!, cell.eduDesc.font, cell.frame.width)
        }
        else{
            return 150
        }
    }
    
    // ::TV:: editingStyleForRowAt
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    // ::TV:: shouldIndentWhileEditingRowAt
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // TABLEVIEW -- moveRowAt
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.resumeSectionData[sourceIndexPath.section]![sourceIndexPath.row]
        self.resumeSectionData[sourceIndexPath.section]?.remove(at: sourceIndexPath.row)
        self.resumeSectionData[sourceIndexPath.section]?.insert(movedObject, at: destinationIndexPath.row)
        updateToOrigin() // Update the data
        
        // RELOAD TABLEVIEW
        self.resumeTableView.reloadData()
        // ---
        
        NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row) \(self.resumeSectionData[sourceIndexPath.section])")
        NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row) \(self.resumeData[sourceIndexPath.section])")
        // To check for correctness enable: self.tableView.reloadData()
    }
    
    // TABLEVIEW -- which rows are allowed to be moved
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section != 0
    }
    
    // TABLEVIEW:
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
            var row: Int = 0
            if (sourceIndexPath.section < proposedDestinationIndexPath.section) {
                row = self.resumeTableView.numberOfRows(inSection: sourceIndexPath.section) - 1
            }
            return IndexPath(row: row, section: sourceIndexPath.section)
        }
        return proposedDestinationIndexPath;
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //// Code
    }
    
//     ::: Delegate Method from EditMode1VC
    func saveBtnPressed(data: [String: String], dataType: String, isSave: Bool, editIndex: Int) {
        print(":: Data Received! \(data)")
        print(":: Edit Index = \(editIndex)")
        if (isSave){
            switch dataType {
            // Education Section
            case "adding_education":
                var oldEduItems: [[String: String]] = resumeData[1]["eduItems"]! as! [[String : String]]
                oldEduItems.append(data)
                resumeData[1]["eduItems"] = oldEduItems
                updateSectionData()
                self.resumeTableView.reloadData()
            case "editting_education":
                print (":: Education Editted!")
                var oldEduItems: [[String: String]] = resumeData[1]["eduItems"]! as! [[String : String]]
                oldEduItems[editIndex] = data
                resumeData[1]["eduItems"] = oldEduItems
                updateSectionData()
                self.resumeTableView.reloadData()
            case "deleting_education":
                print (":: Education Deleted!")
                var oldEduItems: [[String: String]] = resumeData[1]["eduItems"]! as! [[String : String]]
                oldEduItems.remove(at: editIndex)
                resumeData[1]["eduItems"] = oldEduItems
                updateSectionData()
                self.resumeTableView.reloadData()
            case "adding_experience":
                print ("------")
            default:
                print("Invalid save")
            }
        }else{
            print (":: Item not be saved because it is empty")
        }
    }
    
    func computeCellHeight(_ text: String, _ textFont: UIFont, _ width: CGFloat) -> CGFloat {
        // A dummy label in order to compute dynamic height.
        let label = UILabel()
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = textFont
        
        label.preferredMaxLayoutWidth = width - 50
        label.text = text
        label.invalidateIntrinsicContentSize()
        
        let height = label.intrinsicContentSize.height
        return height+102
    }
    
    
}











