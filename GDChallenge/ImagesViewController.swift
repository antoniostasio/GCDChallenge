//
//  ImagesViewController.swift
//  GDChallenge
//
//  Created by Antonio Stasio on 07/03/2017.
//  Copyright © 2017 Antonio Stasio. All rights reserved.
//

import UIKit

class ImagesViewController: UITableViewController, DownloaderDelegate {

    var downloader: Downloader!
    var imagesJson: [ImageData]!
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloader = Downloader(url: "http://api.myjson.com/bins/ec2n5")
        downloader.parseJson()
        downloader.delegate = self
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(images.count)
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell") as! ImageTableViewCell
        cell.myImage.image = images[indexPath.row]
        
        return cell
    }
    
    func didFinishParsingJson() {
        imagesJson = downloader.imagesJson
        for _ in 0..<3 {
            guard let imageData = imagesJson.popLast() else {return}
            downloader.downloadImageTask(imageURL: imageData.imageUrl)
        }
    }
    
    
    func didFinishDownloadingImage(image: UIImage) {
        OperationQueue.main.addOperation {
            self.images.append(image)
            self.tableView.reloadData()
        }
        guard let imageData = imagesJson.popLast() else {return}
        downloader.downloadImageTask(imageURL: imageData.imageUrl)
    }
}
