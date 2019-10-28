//
//  WebViewController.swift
//  YoutubeMatome
//
//  Created by 長坂豪士 on 2019/10/28.
//  Copyright © 2019 Tsuyoshi Nagasaka. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 表示するURLを呼び出し、表示する
        if UserDefaults.standard.object(forKey: "url") != nil {
            let urlString = UserDefaults.standard.object(forKey: "url")
            let url = URL(string: urlString as! String)
            let request = URLRequest(url: url!)
            webView.load(request)
        }

        // 画面サイズ
        webView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.addSubview(webView)
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
