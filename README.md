# Pinpin - New generation of Resume

## Contributors
Boya Chen, Hien Tran, Thanh Dang

## Motivation
Pinpin is a new kind of resume. Commonly, anyone would face these steps in every interview if they attend one. First of all, the interviewer will ask the interviewees to guide through their resume. Secondly, the interviewees would be required to give some information about themselves. Lastly, the interviewees will be asked to say something about their previous experience at maybe their universities or companies.
The steps above happen nearly every interview. Both interviewer and interviewees have to repeat these steps hundreds of time without having a chance to properly prepare and having polish practice. Thus, we as a team came up with the solution for this issue which can allow the interviewees to prepare for themselves how to explain to interviewer properly and clearly as well as to be active in showcasing the skills to the interviewer practically. In the near future, the number of jobs is not enough for everyone even the one who has the bachelor degree or similar to that. With this approach, the interviewee can be actively seperate themselves from other applicants and bring in higher chance to be able to get the job. Your responsibility, our tool, your career.

<!--## Screenshots-->
<!--Include logo/demo screenshot etc.-->

## Features
1. Creating Multimedia resume
1. Professional social network

## API Reference

- [VGPlayer](https://github.com/VeinGuo/VGPlayer)
- [Alamofire](https://github.com/Alamofire/Alamofire)
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
- [AZSClient](https://github.com/Azure/azure-storage-ios)
- [NVActivityIndicatorView](https://github.com/ninjaprox/NVActivityIndicatorView)

## Components

|Component Name|Description|Code Files  
|-|-|-|
|Sign Up|User can sign up with username, email, password and location| ~/Awesome Resume/Controller/SignUpVC.swift
|Log in|User can login using Email Address and Password|~/Awesome Resume/Controller/LoginVC.swift
|Resume Videos|User can check his/her videos in the first page after login |  ~/Awesome Resume/FirstPageView/VideosViewController.swift <br> ~/Awesome Resume/FirstPageView/VideoMediaTableCell.swift <br> ~/Awesome Resume/FirstPageView/VideoMediaTableCellInfoView.swift
|Create New Resume Item|User can create a new item with information including title, date, description and record video of brief introduction | ~/Awesome Resume/FirstPageView/VideosEditViewController.swift
|Feeds|User can see other users' public video who he/she follows|~/Awesome Resume/FirstPageView/FeedsViewController.swift |
|Search and follow users|User can search other users using username and follow| ~/Awesome Resume/FirstPageView/FriendsSearchVC.swift|
|Database|SQLite| |
|Storage|System store user's videos in the storage and fetch back when neede | Azure Blob |
|Virtual Machien| Server is running on a virtual machine in the cloud | Azure Service |


<!--## Credits-->
<!--Give proper credits. This could be a link to any repo which inspired you to build this project, any blogposts or links to people who contrbuted in this project. -->
<!---->
<!--#### Anything else that seems useful-->

<!--## License-->
<!--A short snippet describing the license (MIT, Apache etc)-->
<!---->
<!--MIT © [Yourname]()-->

