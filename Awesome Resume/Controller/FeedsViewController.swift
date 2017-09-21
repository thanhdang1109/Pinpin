//
//  FeedsViewController
//  Awesome Resume
//
//  Created by Hien Tran on 15/9/17.
//  Copyright © 2017 Awesome Team. All rights reserved.
//

import UIKit
import VGPlayer
import SnapKit

class FeedsViewController: UITableViewController {
    var dataArr: [(User, Video)] = [(User, Video)]()
    
    var player : VGPlayer!
    var playerView : VGEmbedPlayerView!
    var currentPlayIndexPath : IndexPath?
    var smallScreenView : UIView!
    var panGesture = UIPanGestureRecognizer()
    var playerViewSize : CGSize?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Feeds"
        configureSmallScreenView()
        addTableViewObservers()
        
        prepData()
    }
    
    func prepData() {
        let user = User(userName: "Hien Tran", email: "heuism23892@gmail.com", pictureUrl: nil)
        print(user._videos)
        print(user._userName)
        print(user._email)
        user._friends?.append(Friend(userName: "Duong Phan", email: "duong@gmail.com", pictureUrl: nil))
        print(user._friends)
        if let friends = user._friends {
            print(friends[0]._userName)
        }
        let video = Video(title: "Dont know", description: "This is about Unimelb Desc", time: "02/09", link: "http://www.html5videoplayer.net/videos/toystory.mp4")
        self.dataArr.append((user, video))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let smallScreenView = smallScreenView {
            smallScreenView.removeFromSuperview()
        }
        if let playerviewCheck = playerView {
            playerView.removeFromSuperview()
        }
        if let playerCheck = player {
            player.cleanPlayer()
        }
        currentPlayIndexPath = nil
    }
    
    deinit {
        if let playerCheck = player {
            player.cleanPlayer()
        }
        removeTableViewObservers()
    }
    
    func configurePlayer() {
        playerView = VGEmbedPlayerView()
        player = VGPlayer(playerView: playerView)
        player.backgroundMode = .suspend
    }
    
    func configureSmallScreenView() {
        smallScreenView = UIView()
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPanGesture(_:)))
        smallScreenView.addGestureRecognizer(panGesture)
    }
    
    @objc func onPanGesture(_ gesture: UIPanGestureRecognizer) {
        
        let screenBounds = UIScreen.main.bounds
        
        var point = gesture.location(in: UIApplication.shared.keyWindow)
        if let gestureView = gesture.view {
            let width = gestureView.frame.width
            let height = gestureView.frame.height
            let distance = CGFloat(10.0)
            
            if gesture.state == .ended {
                if point.x < width/2 {
                    point.x = width/2 + distance
                } else if point.x > screenBounds.width - width/2 {
                    point.x = screenBounds.width - width/2 - distance
                }
                
                if point.y < height/2 + 64.0 {
                    point.y = height/2 + distance + 64.0
                } else if point.y > screenBounds.height - height/2 {
                    point.y = screenBounds.height - height/2 - distance
                }
                UIView.animate(withDuration: 0.5, animations: {
                    gestureView.center = point
                })
            } else {
                gestureView.center = point
            }
        }
    }
    
    var tableViewContext = 0
    func addTableViewObservers() {
        let options = NSKeyValueObservingOptions([.new, .initial])
        tableView?.addObserver(self, forKeyPath: #keyPath(UITableView.contentOffset), options: options, context: &tableViewContext)
    }
    
    func removeTableViewObservers() {
        tableView?.removeObserver(self, forKeyPath: #keyPath(UITableView.contentOffset))
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feed_video_cell", for: indexPath) as! MediaViewCell
        let (user, video) = dataArr[indexPath.row]
        cell.indexPath = indexPath
        cell.playCallBack = ({ [weak self] (indexPath: IndexPath?) -> Void in
            guard let strongSelf = self else { return }
            strongSelf.playerViewSize = cell.mediaContent.bounds.size
            strongSelf.addPlayer(cell, video)
            strongSelf.currentPlayIndexPath = indexPath
        })
        cell.configCell(user: user, media: video)
        
        return cell
    }
    
    func addPlayer(_ cell: MediaViewCell, _ video: Video) {
        if player != nil {
            player.cleanPlayer()
        }
        configurePlayer()
        cell.mediaContent.addSubview(player.displayView)
        player.displayView.snp.makeConstraints {
            $0.edges.equalTo(cell.mediaContent)
        }
        player.replaceVideo(URL(string:video._link!)!)
        player.play()
    }
    
    func addSmallScreenView() {
        player.displayView.removeFromSuperview()
        smallScreenView.removeFromSuperview()
        playerView.isSmallMode = true
        UIApplication.shared.keyWindow?.addSubview(smallScreenView)
        let smallScreenWidth = (playerViewSize?.width)! / 2
        let smallScreenHeight = (playerViewSize?.height)! / 2
        smallScreenView.snp.remakeConstraints {
            $0.bottom.equalTo(self.tableView.snp.bottom).offset(-10)
            $0.right.equalTo(self.tableView.snp.right).offset(-10)
            $0.width.equalTo(smallScreenWidth)
            $0.height.equalTo(smallScreenHeight)
        }
        smallScreenView.addSubview(player.displayView)
        player.displayView.snp.remakeConstraints {
            $0.edges.equalTo(smallScreenView)
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
}

extension FeedsViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //        if (context == &tableViewContext) {
        
        if keyPath == #keyPath(UITableView.contentOffset) {
            if let playIndexPath = currentPlayIndexPath {
                
                if let cell = tableView.cellForRow(at: playIndexPath) as? MediaViewCell {
                    if player.displayView.isFullScreen { return }
                    let visibleCells = tableView.visibleCells
                    if visibleCells.contains(cell) {
                        smallScreenView.removeFromSuperview()
                        cell.contentView.addSubview(player.displayView)
                        player.displayView.snp.remakeConstraints {
                            $0.edges.equalTo(cell.mediaContent)
                        }
                        playerView.isSmallMode = false
                    } else {
                        addSmallScreenView()
                    }
                } else {
                    if isViewLoaded && (view.window != nil) {
                        if smallScreenView.superview != UIApplication.shared.keyWindow {
                            addSmallScreenView()
                        }
                    }
                }
            }
        }
        //        }
    }
}


