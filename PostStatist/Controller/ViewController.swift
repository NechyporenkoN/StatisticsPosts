//
//  ViewController.swift
//  PostStatist
//
//  Created by Nikita Nechyporenko on 11.03.2019.
//  Copyright © 2019 Nikita Nechyporenko. All rights reserved.
//

import UIKit
import Alamofire
import  SwiftyJSON

var arrUsersWhoLike = [User]()
var arrCommentators = [User]()
var arrMentions = [User]()
var arrReposters = [User]()
var viewsCount = ""
var likesCount = ""
var commentatorsCount = ""
var mentionsCount = ""
var repostersCount = ""
var bookmarkCount = ""
var idForRequest = ""

class ViewController: UIViewController {
    
    @IBOutlet weak var slugTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func requestReposters(id: String) {
        
        let parameters: Parameters = ["id": id]
        let headers = token
        let urlLink = "https://api.inrating.top/v1/users/posts/reposters/all"
        
        Alamofire.request(urlLink, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    let swiftyJson = JSON(response.data!)
                    let data = swiftyJson["data"]
                    for i in 0..<data.count {
                        let nickname = data[i]["nickname"].string!
                        print("     nickname commentators     =\(nickname)")
                        let avatar = data[i]["avatar_image"]
                        let urlImage = avatar["url_small"].string!
                        let reposters = User.init(imageUrl: urlImage, name: nickname)
                        print(" REPOSTERS     \(reposters.name)")
                        arrReposters.append(reposters)
                        repostersCount = String(arrReposters.count)
                    }
                }
                else {
                    debugPrint("HTTP Request Log in failed: \(String(describing: response.result.error))")
                }
        }
    }
    
    func requestMentions(id: String) {
        
        let parameters: Parameters = ["id": id]
        let headers = token
        let urlLink = "https://api.inrating.top/v1/users/posts/mentions/all"
        
        Alamofire.request(urlLink, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    let swiftyJson = JSON(response.data!)
                    let data = swiftyJson["data"]
                    for i in 0..<data.count {
                        let nickname = data[i]["nickname"].string!
                        print("     nickname commentators     =\(nickname)")
                        let avatar = data[i]["avatar_image"]
                        let urlImage = avatar["url_small"].string!
                        let mentions = User.init(imageUrl: urlImage, name: nickname)
                        print(" commentator  \(mentions.name)")
                        arrMentions.append(mentions)
                        mentionsCount = String(arrMentions.count)
                    }
                }
                else {
                    debugPrint("HTTP Request Log in failed: \(String(describing: response.result.error))")
                }
        }
    }
    
    func requestCommentators(id: String) {
        
        let parameters: Parameters = ["id": id]
        let headers = token
        let urlLink = "https://api.inrating.top/v1/users/posts/commentators/all"
        
        Alamofire.request(urlLink, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    let swiftyJson = JSON(response.data!)
                    let data = swiftyJson["data"]
                    for i in 0..<data.count {
                        let nickname = data[i]["nickname"].string!
                        print("     nickname commentators     =\(nickname)")
                        let avatar = data[i]["avatar_image"]
                        let urlImage = avatar["url_small"].string!
                        let commentator = User.init(imageUrl: urlImage, name: nickname)
                        print(" commentator  \(commentator.name)")
                        arrCommentators.append(commentator)
                        commentatorsCount = String(arrCommentators.count)
                    }
                    print("   arrCommentators  =  \(arrCommentators.count)")
                }
                else {
                    debugPrint("HTTP Request Log in failed: \(String(describing: response.result.error))")
                }
        }
    }
    
    
    func requestOnWhoLikes(id: String) {
        
        let parameters: Parameters = ["id": id]
        let headers = token
        let urlLink = "https://api.inrating.top/v1/users/posts/likers/all"
        
        Alamofire.request(urlLink, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    let swiftyJson = JSON(response.data!)
                    let data = swiftyJson["data"]
                    for i in 0..<data.count {
                        let nickname = data[i]["nickname"].string!
                        print("     nickname      =\(nickname)")
                        let avatar = data[i]["avatar_image"]
                        let urlImage = avatar["url_small"].string!
                        let userWhoLike = User.init(imageUrl: urlImage, name: nickname)
                        print(" userWhoLike  \(userWhoLike.imageUrl, userWhoLike.name)")
                        arrUsersWhoLike.append(userWhoLike)
                    }
                    print("   arrUsersWhoLike  =  \(arrUsersWhoLike.count)")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "StatisticVC")
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
                else {
                    debugPrint("HTTP Request Log in failed: \(String(describing: response.result.error))")
                }
        }
    }
    
    func requestOnIdPost(slug: String) {
        
        let headers = token
        let urlLink = "https://api.inrating.top/v1/users/posts/get?slug=" + slug
        print("link=\(urlLink)")
        
        Alamofire.request(urlLink, method: .post, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    let swiftyJson = JSON(response.data!)
                    let id = swiftyJson["id"].int
                    print("id=\(id!)")
                    let like = swiftyJson["likes_count"].int
                    likesCount = String(like!)
                    let views = swiftyJson["views_count"].int
                    viewsCount = String(views!)
                    idForRequest = String(id!)
                    let bookmarks = swiftyJson["bookmarks_count"].int
                    bookmarkCount = String(bookmarks!)
                    self.requestReposters(id: idForRequest)
                    self.requestMentions(id: idForRequest)
                    self.requestOnWhoLikes(id: idForRequest)
                    self.requestCommentators(id: idForRequest)
                }
                else {
                    debugPrint("HTTP Request Log in failed: \(String(describing: response.result.error))")
                }
        }
    }
    
    
    @IBAction func statisticsButton(_ sender: Any) {
        requestOnIdPost(slug: slugTextField.text!)
    }
    
}


