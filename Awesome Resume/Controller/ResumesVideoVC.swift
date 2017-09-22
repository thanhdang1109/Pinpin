//
//  ResumesVideoVC.swift
//  Awesome Resume
//
//  Created by BOYA CHEN on 13/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit

class ResumesVideoVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var video : [[String]] = [
        ["Introuction", "./video_uom.mp4"],
        ["Unimelb", "video2URL"],
        ["Intern1", "video3URL"],
        ["Intern2", "video4URL"],
        ["My skills", "video5URL"]
    ]
    
    @IBOutlet weak var MediaTitleLabel: UILabel!
    @IBOutlet weak var MeidaTableView: UITableView!
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return video.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let videoTitle = video[indexPath.row][0]
        let videoURL = video[indexPath.row][1]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as? VideoCellVC {
            cell.VideoCellLabel.text = videoTitle as? String
            if indexPath.row == 0{
                cell.setURL(videoUrl: videoURL)
            }

            return cell
        }
        return UITableViewCell()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
