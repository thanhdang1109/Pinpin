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
        "type": "sectionTitle",
        "data": "EDUCATION"
    ],
    [
        "type": "plainTextField",
        "data": "THE UNIVERSITY OF MELBOURNE",
        "style": resumeStyleSheet[0]
    ],
    [
        "type": "plainTextField",
        "data": "- Master of Information Technology, expected December 2017",
        "style": resumeStyleSheet[1]
    ],
    [
        "type": "plainTextField",
        "data": "DICKINSON COLLEGE",
        "style": resumeStyleSheet[0]
    ],
    [
        "type": "plainTextField",
        "data": "- B.A in International Business & Management",
        "style": resumeStyleSheet[1]
    ],
    [
        "type": "plainTextField",
        "data": "STATE UNIVERSITY OF NEW YORK",
        "style": resumeStyleSheet[0]
    ],
    [
        "type": "plainTextField",
        "data": "- Studied B.S in Finance",
        "style": resumeStyleSheet[1]
    ],
    // Experience
    [
        "type": "sectionTitle",
        "data": "EXPERIENCE"
    ],
    // Experience 1
    [
        "type": "plainTextField",
        "data": "UNIVERSITY OF MELBOURNE - ACADEMIC SERVICES",
        "style": resumeStyleSheet[0]
    ],
    [
        "type": "plainTextField",
        "data": "Melbourne, Australia",
        "style": resumeStyleSheet[3]
    ],
    [
        "type": "plainTextField",
        "data": "2016-2017",
        "style": resumeStyleSheet[3]
    ],
    [
        "type": "plainTextField",
        "data": "Student Service Delivery Assistant",
        "style": resumeStyleSheet[2]
    ],
    [
        "type": "plainTextField",
        "data": "- Performing a range of professional duties including customer service, administrative support, data entry and event support in work units and service points across Academic Services",
        "style": resumeStyleSheet[1]
    ],
    [
        "type": "plainTextField",
        "data": "- Delivering accurate and timely information to students by drawing on the knowledge and experience of service teams within Academic Services",
        "style": resumeStyleSheet[1]
    ],
    // Exp 2
    [
        "type": "empty"
    ],
    [
        "type": "plainTextField",
        "data": "HARMAN JBL - INSTORE.SPACE",
        "style": resumeStyleSheet[0]
    ],
    [
        "type": "plainTextField",
        "data": "Melbourne, Australia",
        "style": resumeStyleSheet[3]
    ],
    [
        "type": "plainTextField",
        "data": "2016",
        "style": resumeStyleSheet[3]
    ],
    [
        "type": "plainTextField",
        "data": "Brand Ambassador / Promoter",
        "style": resumeStyleSheet[2]
    ],
    [
        "type": "plainTextField",
        "data": "- Sold $24,000 worth of premium speakers and headphones for JBL at JB HIFi and Harvey Norman in Melbourne within one week. Promoted the JBL brand, including training retail staff about dozens of categories and raising customers' awareness of the brand.",
        "style": resumeStyleSheet[1]
    ],
    // Exp 3
    [
        "type": "empty"
    ],
    [
        "type": "plainTextField",
        "data": "ADAYROI.COM - VINECOM - VINGROUP",
        "style": resumeStyleSheet[0]
    ],
    [
        "type": "plainTextField",
        "data": "Vietnam",
        "style": resumeStyleSheet[3]
    ],
    [
        "type": "plainTextField",
        "data": "2015",
        "style": resumeStyleSheet[3]
    ],
    [
        "type": "plainTextField",
        "data": "Executive Assistant to CEO",
        "style": resumeStyleSheet[2]
    ],
    [
        "type": "plainTextField",
        "data": "- Helped launch Adayroi.com successfully",
        "style": resumeStyleSheet[1]
    ],
    [
        "type": "plainTextField",
        "data": "- Prepared & consolidated monthly budgets for the Sales Division",
        "style": resumeStyleSheet[1]
    ],
    // ---
    [
        "type": "plainTextField",
        "data": "Human Resources & People OperationsO",
        "style": resumeStyleSheet[2]
    ],
    [
        "type": "plainTextField",
        "data": "- Helped redesign & implement organization restructuring through recruiting & establishing corporate culture for a national company of 1000 peopley",
        "style": resumeStyleSheet[1]
    ],
    [
        "type": "plainTextField",
        "data": "- Redesigned and pipelined entire recruitment processes, including IT solution using Microsoft Team Foundation Server",
        "style": resumeStyleSheet[1]
    ],
    [
        "type": "plainTextField",
        "data": "- Headhunted & recruited 30+ employees, including C-level positions",
        "style": resumeStyleSheet[1]
    ],
    [
        "type": "plainTextField",
        "data": "- Designed comprehensive initiatives to transform working environments with a focus on corporate identity through motivational programs & policies, office redesigns",
        "style": resumeStyleSheet[1]
    ],
    // --
    [
        "type": "plainTextField",
        "data": "Relationships & Partnerships Management",
        "style": resumeStyleSheet[2]
    ],
    [
        "type": "plainTextField",
        "data": "- Managed & coordinated all CEO's external relationships",
        "style": resumeStyleSheet[1]
    ],
    [
        "type": "plainTextField",
        "data": "- Managed & coordinated the company's partnerships for content production, packaging production, R&D, marketing campaigns, key people headhunting",
        "style": resumeStyleSheet[1]
    ],
    [
        "type": "plainTextField",
        "data": "- Led the event for the visit of the Second Lady of the United States of America, Dr. Jill Biden",
        "style": resumeStyleSheet[1]
    ],
    // ----
    [
        "type": "plainTextField",
        "data": "Marketing & Communication",
        "style": resumeStyleSheet[2]
    ],
    [
        "type": "plainTextField",
        "data": "- Wrote marketing proposals for grand launching campaigns in Hanoi & HCMC",
        "style": resumeStyleSheet[1]
    ],
    [
        "type": "plainTextField",
        "data": "- Designed marketing campaign key visuals, customer journeys & gifts",
        "style": resumeStyleSheet[1]
    ],
    [
        "type": "plainTextField",
        "data": "- Advised and prepared CEO's speeches & public communication",
        "style": resumeStyleSheet[1]
    ],
    // ========== PROJECTS
    [
        "type": "sectionTitle",
        "data": "PROJECTS"
    ],
    [
        "type": "plainTextField",
        "data": "KIDS Vietnam",
        "style": resumeStyleSheet[0]
    ],
    [
        "type": "plainTextField",
        "data": "Charity",
        "style": resumeStyleSheet[3]
    ],
    [
        "type": "plainTextField",
        "data": "Vietnam",
        "style": resumeStyleSheet[3]
    ],
    [
        "type": "plainTextField",
        "data": "- Co-found a non-profit organization with missions to improve lives of underprivileged children via open source projects. Led “Life jackets for Lai Chau” trip to give life jackets to 500 poor kids in Lai Chau, Vietnam",
        "style": resumeStyleSheet[1]
    ],
    // ============
    [
        "type": "sectionTitle",
        "data": "SUFFICIENT SKILLS"
    ],
    [
        "type": "plainTextField",
        "data": "- Sales",
        "style": resumeStyleSheet[1]
    ],
    [
        "type": "plainTextField",
        "data": "- Microsoft Office - Word, Excel, PowerPoint, Outlook",
        "style": resumeStyleSheet[1]
    ],
    [
        "type": "plainTextField",
        "data": "- Java, Python, Haskell, Prolog, MySQL, HTML, CSS, Javascript",
        "style": resumeStyleSheet[1]
    ],
    [
        "type": "plainTextField",
        "data": "- Tutoring / Teaching",
        "style": resumeStyleSheet[1]
    ],
    [
        "type": "plainTextField",
        "data": "- Speech Writing",
        "style": resumeStyleSheet[1]
    ],
]

// ------------------------------------------------

class ResumesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // -------------- Resume Page Table View Section
    @IBOutlet weak var resumeTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resumeData.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if resumeData[indexPath.row]["type"] as! String == "resumeTitle" {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as? ResumeTableCellTitle{
                cell.configCell(name: (resumeData[indexPath.row]["name"] as? String)!, address: ( resumeData[indexPath.row]["addr"] as? String )! )
                return cell
            }
        }
        else if resumeData[indexPath.row]["type"] as! String == "sectionTitle" {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewSectionTitle", for: indexPath) as? ResumeTableCellSectionTitle{
                cell.TableCellSectionTitle.text = resumeData[indexPath.row]["data"] as? String
                return cell
            }
        }
        else if resumeData[indexPath.row]["type"] as! String == "empty" {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewTextStyeEmpty", for: indexPath) as? ResumeTableCellSectionTitle{
                return cell
            }
        }
        else{
            let content = resumeData[indexPath.row]["data"] as? String
            let style = resumeData[indexPath.row]["style"] as? [String: Any]
            let bold = style?["bold"] as? Bool
            let italic = style?["italic"] as? Bool
            let size = style?["size"] as? Int
            if bold as! Bool && italic as! Bool {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewTextStyeBI", for: indexPath) as? ResumeTableViewCellTextStyle1{
                    cell.CellText.text = content
                    return cell
                }
            }else if italic as! Bool{
                if let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewTextStyeI", for: indexPath) as? ResumeTableViewCellTextStyle1{
                    cell.CellText.text = content
                    return cell
                }
            }else{
                if let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewTextStye", for: indexPath) as? ResumeTableViewCellTextStyle1{
                    cell.CellText.text = content
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
//    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if resumeData[indexPath.row]["type"] as! String == "resumeTitle" {
//            return 100
//        }
//        else if resumeData[indexPath.row]["type"] as! String == "empty"{
//            return 10
//        }
//        else if resumeData[indexPath.row]["type"] as! String == "sectionTitle"{
//            return 28
//        }
//        else {
//            let style = resumeData[indexPath.row]["style"] as? [String: Any]
//            let bold = style?["bold"] as? Bool
//            let italic = style?["italic"] as? Bool
//            if bold as! Bool && italic as! Bool {
//                return 25
//            }else if italic as! Bool{
//                return 20
//            }else{
//                return 30
//            }
//        }
//    }
    
    // -------------- Header Part
    @IBOutlet weak var resumePageTitle: UILabel?
    @IBOutlet weak var resumePageEditBtn: UIButton?
    
    @IBAction func EditBtnAction(_ sender: UIButton) {
        
//        self.resumeTableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resumeTableView.rowHeight = UITableViewAutomaticDimension
        self.resumeTableView.estimatedRowHeight = 40
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
