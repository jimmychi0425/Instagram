//
//  FeedViewController.swift
//  instagram
//
//  Created by Han Chi on 2018/2/26.
//  Copyright © 2018年 Han Chi. All rights reserved.
//

import UIKit
import Parse

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var posts: [PFObject] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidAppear(_ animated: Bool) {
        fetchData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
       
        // Do any additional setup after loading the view.
        fetchData()
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchData()
        // Reload the tableView now that there is new data
        tableView.reloadData()
        // Tell the refreshControl to stop spinning
        refreshControl.endRefreshing()
    }

    @IBAction func onLogOut(_ sender: Any) {
          NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = posts[indexPath.row]
        let caption = post["caption"] as! String
        cell.captionTextLabel.text = caption
        let picture = post["media"] as! PFFile
        picture.getDataInBackground { (imageData, error) in
            if error == nil {
                let image = UIImage(data: imageData!)
                cell.PostImageView.image = image
            } else {
                print(error?.localizedDescription ?? "Error instance was nil")
            }
        }
        return cell
    }
    
    func fetchData() {
        let query = Post.query()
        query?.order(byDescending: "createdAt")
        query?.includeKeys(["author", "createdAt"])
        query?.limit = 20
        
        // fetch data asynchronously
        query?.findObjectsInBackground { (posts, error) in
            if let posts = posts {
                self.posts = posts
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription ?? "Error instance was nil")
            }
        }
        print("hello")
        print(posts.count)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let cell = sender as! PostCell
            if let indexPath = tableView.indexPath(for: cell) {
                let post = posts[indexPath.row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.post = post
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
