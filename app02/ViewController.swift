//
//  ViewController.swift
//  app02
//
//  Created by 五島　僚太郎 on 2015/08/23.
//  Copyright (c) 2015年 fsail. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    // Tableで使用する配列を設定する
    var qiitaList: [[String:AnyObject]] = []
    var myTableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qiitaList = Qiita.items() as! [[String : AnyObject]]
        // Status Barの高さを取得する.
        let barHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
        // Viewの高さと幅を取得する.
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        // TableViewの生成する(status barの高さ分ずらして表示).
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight)) // Cell名の登録をおこなう.
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell") // DataSourceの設定をする.
        myTableView.dataSource = self // Delegateを設定する.
        myTableView.delegate = self
        // Viewに追加する.
        self.view.addSubview(myTableView)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "更新中")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        myTableView.addSubview(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    /* Cellが選択された際に呼び出されるデリゲートメソッド. */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var title: AnyObject? = qiitaList[indexPath.row]["title"]
        var url: AnyObject? = qiitaList[indexPath.row]["url"]
        var webViewController = UIViewController()
        let webView = UIWebView(frame: self.view.frame)
        
        webView.loadRequest(NSURLRequest(URL: NSURL(string: url as! String!)!))
        webViewController.view.addSubview(webView)
        
        self.navigationController!.pushViewController(webViewController, animated: true)
    }
    /* Cellの総数を返すデータソースメソッド. (実装必須)
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return qiitaList.count
    }
    /* Cellに値を設定するデータソースメソッド. (実装必須)
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell { // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! UITableViewCell // Cellに値を設定する.
        var title: AnyObject = qiitaList[indexPath.row]["title"]!
        cell.textLabel!.text = "\(title)"
        return cell
    }
    
    func refresh(sender: AnyObject) {
        qiitaList = Qiita.items() as! [[String : AnyObject]]
        self.myTableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
}
