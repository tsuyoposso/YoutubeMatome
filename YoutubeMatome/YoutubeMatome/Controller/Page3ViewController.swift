//
//  Page1ViewController.swift
//  YoutubeMatome
//
//  Created by 長坂豪士 on 2019/10/27.
//  Copyright © 2019 Tsuyoshi Nagasaka. All rights reserved.
//

import UIKit
import SegementSlide
import Alamofire
import SwiftyJSON
import SDWebImage


class Page3ViewController: UITableViewController, SegementSlideContentScrollViewDelegate {

    var youtubeData = YoutubeData()
    var dataArray = [YoutubeData()]
    
//    var videoIdArray = [String]()
//    var titleArray = [String]()
//    var imageURLStringArray = [String]()
//    var youtubeURLArray = [String]()
//    var channelTitleArray = [String]()
    
    let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(update), for: .valueChanged)
        
        
        getData()
        tableView.reloadData()
    }

    var scrollView: UIScrollView {
        return tableView
    }
    
    @objc func update() {
        getData()
        tableView.reloadData()
        refresh.endRefreshing()
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 定形のCell表示方式で表示する
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")

        // セル選択時の背景色
        cell.selectionStyle = .none
        
        // サムネイル画像の表示
        // let thumbnailImageURL = URL(string: imageURLStringArray[indexPath.row])
        let thumbnailImageURL = URL(string: dataArray[indexPath.row].imageURLString)
        cell.imageView?.sd_setImage(with: thumbnailImageURL, completed: { (image, error, _, _) in
            if error != nil {
                // 同一view内の画像を再描画する
                cell.setNeedsLayout()
            }
        })
        
        // タイトルの表示
        cell.textLabel!.text = dataArray[indexPath.row].title
        // 文字サイズを可変にする
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        // 最大行数指定
        cell.textLabel?.numberOfLines = 5
        
//        print(indexPath.row)
//        print(dataArray[indexPath.row].title)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height / 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexNumber = indexPath.row
        let webViewController = WebViewController()
        let url = dataArray[indexNumber].youtubeURL
        UserDefaults.standard.set(url, forKey: "url")
        present(webViewController, animated: true, completion: nil)
    }
    
    
    func getData() {
        
        // APIのURL key:APIキー, q:検索キーワード, maxResult:最大検索件数
        var text = "https://www.googleapis.com/youtube/v3/search?key=AIzaSyBSRfx6mz-9qI5G9wuJ95roA7guu8y3gKk&q=アウトドア&part=snippet&maxResults=40&order=date"
        
        // URLに日本語等が入っている場合に変換するメソッド
        let url = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        // Alamofireでリクエストを送り、JSONデータを取得する
        request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            
            
            print(response)
            //JSON解析
            switch response.result {
                
                
                case .success:
                    
                    for i in 0...15 {
                        
                        let videoId:String?
                        let youtubeURL:String
                        
                        let json:JSON = JSON(response.data as Any)
                        if let videoIdString = json["items"][i]["id"]["videoId"].string {
                            videoId = videoIdString
                            youtubeURL = "https://www.youtube.com/watch?v=\(videoId!)"
                        } else {
                            continue
                        }
                        let title = json["items"][i]["snippet"]["title"].string
                        let imageURL = json["items"][i]["snippet"]["thumbnails"]["default"]["url"].string
                        let channelTitle = json["items"][i]["snippet"]["channelTitle"].string
                        
                        self.youtubeData.videoId = videoId!
                        self.youtubeData.title = title!
                        self.youtubeData.imageURLString = imageURL!
                        self.youtubeData.youtubeURL = youtubeURL
                        self.youtubeData.channelTitle = channelTitle!
                        
                        self.dataArray.append(self.youtubeData)
//                        self.videoIdArray.append(videoId!)
//                        self.titleArray.append(title!)
//                        self.imageURLStringArray.append(imageURL!)
//                        self.youtubeURLArray.append(youtubeURL)
//                        self.channelTitleArray.append(channelTitle!)

                        print(self.dataArray[i].videoId)
                        print(i)
                    }
                
                case .failure(let error):
                    print(error)
                    
            }
            
            self.tableView.reloadData()
            
        }
        
    }

}
