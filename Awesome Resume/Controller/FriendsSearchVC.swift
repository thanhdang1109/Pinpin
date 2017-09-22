//
//  FriendsSearchVC.swift
//  Awesome Resume
//
//  Created by Hien Tran on 22/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit

extension FriendsSearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension FriendsSearchVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchActive = true;
        self.friendSearchBar.showsCancelButton = searchActive
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchActive = false
        print(searchActive)
        self.friendSearchBar.endEditing(!searchActive)
        self.friendSearchBar.text = ""
        self.friendSearchBar.showsCancelButton = searchActive
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchActive = false;
    }
}

class FriendsSearchVC: UIViewController {
    
    var searchActive : Bool = false
    
    @IBOutlet weak var friendSearchBar: UISearchBar!
    @IBOutlet weak var friendListTableView: UITableView!
    
    var friendList:[Friend] = [Friend]()
    
    func configVC() {
        self.friendListTableView.dataSource = self
        self.friendListTableView.delegate = self
        self.friendSearchBar.delegate = self
        self.friendSearchBar.showsCancelButton = searchActive
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configVC()
        
        friendList = (getFriendList(url: "") as? [Friend])!
        if friendList.isEmpty {
            friendListTableView.isHidden = true
        }
        else {
            friendListTableView.isHidden = false
        }
        // Do any additional setup after loading the view.
    }
    
    func getFriendList(url: String) -> Any? {
        return []
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
