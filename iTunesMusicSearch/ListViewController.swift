//
//  ListViewController.swift
//  iTunesMusicSearch
//
//  Created by nixnoughtnothing on 6/2/15.
//  Copyright (c) 2015 Sttir Inc. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    // 検索結果を覚えておくプロパティを追加
    private var results: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // number of sections
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // number of rows(検索結果の個数)
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.count ?? 0 // ??の左側のオブジェクト(optional値)がnilの場合は右側のオブジェクトを返す
        /* 左オペランドにはT?型、右オペランドにはT型の値をとり、左オペランドに値が存在していればアンラップしてその値を返し、左オペランドがnilであれば右オペランドの値を返す */
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ListCell
        if let result = results?[indexPath.row]{
            if let artworkUrl = result["artworkUrl100"] as? String{
                cell.artworkImageView.setImageWithURL(NSURL(string: artworkUrl))
            } else{
                cell.artworkImageView.image = nil
            }
            cell.trackLabel.text = result["trackName"] as? String
            cell.artistLabel.text = result["artistName"] as? String
        }
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? DetailViewController{
            //　ユーザーが選択している行のindexPathを取得し、定数indexPathに代入。
            if let indexPath = tableView.indexPathForSelectedRow(),result = results?[indexPath.row]{
                vc.trackName = result["trackName"] as! String
                vc.previewUrl = result["previewUrl"] as? String
            }
        }
        
    }

}


extension ListViewController: UISearchBarDelegate {
    
    // searchBarのSearchボタンをタップしたときの処理
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // キーボードを閉じる
        
        // url encode　例. スピッツ > %83X%83s%83b%83c
        let text = searchBar.text.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        if let text = text {
            AFHTTPSessionManager().GET(
                "https://itunes.apple.com/search?term=\(text)&country=JP&lang=ja_jp&media=music",
                parameters: nil,
                success: { (task: NSURLSessionDataTask!, response: AnyObject!) -> Void in
                    if let data = response as? NSDictionary, results = data["results"] as? [NSDictionary] {
                        self.results = results
                        self.tableView.reloadData() // 再描画
                    }
                },
                failure: nil)
        }
    }
}
