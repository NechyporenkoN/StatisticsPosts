//
//  StatisticVC.swift
//  PostStatist
//
//  Created by Nikita Nechyporenko on 11.03.2019.
//  Copyright © 2019 Nikita Nechyporenko. All rights reserved.
//

import UIKit
import SDWebImage

class StatisticVC: UIViewController {
    
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
    
    @IBOutlet weak var statTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statTableView.estimatedRowHeight = 44
        statTableView.rowHeight = UITableView.automaticDimension
        
    }
    
}

extension StatisticVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellWithCollection", for: indexPath) as! TableViewCell
        
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        
        cell.collectionView.tag = indexPath.row
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
            cell.iconForCellImageView.image = UIImage(named: "visible")
            cell.titleForCellLabel.text = "Просмотры " + viewsCount
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = true
            return cell
        }
        if indexPath.row == 1 {
            if arrUsersWhoLike.count != 0 {
                cell.iconForCellImageView.image = UIImage(named: "like")
                cell.titleForCellLabel.text = "Лайки " + likesCount
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
                cell.iconForCellImageView.image = UIImage(named: "like")
                cell.titleForCellLabel.text = "Лайки 0"
                cell.layer.cornerRadius = 8
                cell.layer.masksToBounds = true
                return cell
            }
        }
        if indexPath.row == 2 {
            if arrUsersWhoLike.count != 0 {
                cell.iconForCellImageView.image = UIImage(named: "topic")
                cell.titleForCellLabel.text = "Комментарии " + commentatorsCount
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
                cell.iconForCellImageView.image = UIImage(named: "topic")
                cell.titleForCellLabel.text = "Комментарии 0"
                cell.layer.cornerRadius = 8
                cell.layer.masksToBounds = true
                return cell
            }
        }
        if indexPath.row == 3 {
            if arrMentions.count != 0 {
                cell.iconForCellImageView.image = UIImage(named: "man")
                cell.titleForCellLabel.text = "Отметки " + mentionsCount
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
                cell.iconForCellImageView.image = UIImage(named: "man")
                cell.titleForCellLabel.text = "Отметки 0"
                cell.layer.cornerRadius = 8
                cell.layer.masksToBounds = true
                return cell
            }
        }
        if indexPath.row == 4 {
            if arrReposters.count != 0 {
                cell.iconForCellImageView.image = UIImage(named: "repost")
                cell.titleForCellLabel.text = "Репосты " + repostersCount
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
                cell.iconForCellImageView.image = UIImage(named: "repost")
                cell.titleForCellLabel.text = "Репосты 0"
                cell.layer.cornerRadius = 8
                cell.layer.masksToBounds = true
                return cell
            }
        }
        if indexPath.row == 5 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
            cell.iconForCellImageView.image = UIImage(named: "bookmark")
            cell.titleForCellLabel.text = "Закладки " + bookmarkCount
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = true
            return cell
        }
        return cell
    }
}

extension StatisticVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return arrUsersWhoLike.count
        }
        if collectionView.tag == 2 {
            return arrCommentators.count
        }
        if collectionView.tag == 3 {
            return arrMentions.count
        }
        if collectionView.tag == 4 {
            return arrReposters.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.usersAvatarImageView.layer.cornerRadius = 8
        cell.usersAvatarImageView.layer.masksToBounds = true
        if collectionView.tag == 1 {
            cell.nicknameLabel.text = arrUsersWhoLike[indexPath.row].name
            cell.usersAvatarImageView.sd_setImage(with: URL.init(string: arrUsersWhoLike[indexPath.row].imageUrl), completed: nil )
        }
        if collectionView.tag == 2 {
            cell.nicknameLabel.text = arrCommentators[indexPath.row].name
            cell.usersAvatarImageView.sd_setImage(with: URL.init(string: arrCommentators[indexPath.row].imageUrl), completed: nil )
        }
        if collectionView.tag == 3 {
            cell.nicknameLabel.text = arrMentions[indexPath.row].name
            cell.usersAvatarImageView.sd_setImage(with: URL.init(string: arrMentions[indexPath.row].imageUrl), completed: nil )
        }
        if collectionView.tag == 4 {
            cell.nicknameLabel.text = arrReposters[indexPath.row].name
            cell.usersAvatarImageView.sd_setImage(with: URL.init(string: arrReposters[indexPath.row].imageUrl), completed: nil )
        }
        return cell
    }
    
}

