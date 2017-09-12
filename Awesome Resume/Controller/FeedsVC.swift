//
//  UserFeedsVC.swift
//  Awesome Resume
//
//  Created by Hien Tran on 5/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit

class FeedsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    

    @IBOutlet weak var feedTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.dataSource = self
        feedTableView.delegate = self
        // Do any additional setup after loading the view.
        let user = User(userName: "Hien Tran", email: "heuism23892@gmail.com", pictureUrl: nil)
        print(user._videos)
        print(user._userName)
        print(user._email)
        user._friends?.append(Friend(userName: "Duong Phan", email: "duong@gmail.com", pictureUrl: nil))
        print(user._friends)
        if let friends = user._friends {
            print(friends[0]._userName)
        }
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
