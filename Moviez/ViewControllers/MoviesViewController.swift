//
//  MoviesViewController.swift
//  Moviez
//
//  Created by Prasanthi Relangi on 3/3/18.
//  Copyright © 2018 prasanthi. All rights reserved.
//
// APIKey: https://api.themoviedb.org/3/movie/550?api_key=e486a71d66431db41109cd9ab3ce5b7a
//


import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var moviesDict: [[String:Any]] = [[String:Any]]()
    var endPoint: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
        networkRequest(endPoint: "movie/now_playing")
    }
    
    func networkRequest(endPoint: String) {
        let apiKey = "e486a71d66431db41109cd9ab3ce5b7a"
        let url = URL(string:"https://api.themoviedb.org/3/\(endPoint)?api_key=\(apiKey)")
        var request = URLRequest(url: url!)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (dataOrNil, response, error) in
            if error != nil {
                //Add errror view
                print("ERROR")
            }
            else {
                if let data = dataOrNil {
                    let dictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    self.moviesDict = dictionary["results"] as! [[String:Any]]
                    print(self.moviesDict)
                    
                    self.tableView.reloadData()
                }
            }
        }
        
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesDict.count
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = moviesDict[indexPath.row]
        let title = movie["original_title"] as! String
        let baseURL = "https://image.tmdb.org/t/p/w500"
        
        cell.title.text = title
        cell.overview.text = movie["overview"] as? String
        //Set the selection style to None;
        cell.selectionStyle = .none
        
        if let posterPath = movie["poster_path"] as? String {
            let posterURL = URL(string: baseURL+posterPath)
            cell.posterView.setImageWith(posterURL!)
        }
        else {
            cell.posterView.image = nil
        }
 
       
        //cell.textLabel!.text = title
        return cell
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
