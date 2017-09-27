//
//  UserFeedsVC.swift
//  Awesome Resume
//
//  Created by Hien Tran on 5/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit

extension FeedsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.feedTableView.dequeueReusableCell(withIdentifier: "feed_video_cell") as? MediaViewCell else {
            return MediaViewCell()
        }
        
        let (user, video) = dataArr[indexPath.row]
        
        cell.configCell(user: user, media: video)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

class FeedsVC: UIViewController {
    var dataArr: [(User, Video)] = [(User, Video)]()

    @IBOutlet weak var feedTableView: UITableView!
    
    func prepData() {
        let user = User(userName: "Hien Tran", email: "heuism23892@gmail.com", pictureUrl: nil, location: "Melbourne, Australia")
        print(user._videos)
        print(user._userName)
        print(user._email)
        user._friends?.append(Friend(userName: "Duong Phan", email: "duong@gmail.com", pictureUrl: nil, location: "Michigan, USA"))
        print(user._friends)
        if let friends = user._friends {
            print(friends[0]._userName)
        }
        let video = Video(title: "Dont know", description: "This is about Unimelb Desc", time: "02/09", link: nil)
        self.dataArr.append((user, video))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.dataSource = self
        feedTableView.delegate = self
        feedTableView.allowsSelection = false

        // Do any additional setup after loading the view.
        prepData()
        
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
