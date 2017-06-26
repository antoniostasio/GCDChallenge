//
//  Downloader.swift
//  GDChallenge
//
//  Created by Antonio Stasio on 07/03/2017.
//  Copyright © 2017 Antonio Stasio. All rights reserved.
//

import Foundation
import UIKit

class Downloader {
    
    let url: String
    var imagesJson: [ImageData] = []
    var images: [UIImage] = []
    var delegate: DownloaderDelegate?
    
    init(url: String) {
        self.url = url
    }
    
    func parseJson() {
        guard let url_using = URL(string: url) else {
            return
        }
        
        let request = URLRequest(url: url_using)
        _ = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            if let er = error {
                print(er)
                return
            }
            
            guard let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: []) else {
                print("errore parsing")
                return
            }
            
            guard let jsonData = jsonResult as? [[String:Any]]
                else {
                    print("json malformato")
                    return
            }
            
            
            for elem in jsonData {
                let imageJson: ImageData = ImageData(id: elem["id"] as! Int,
                                                     description: elem["description"] as! String,
                                                     imageUrl: URL(string:elem["thumb"] as! String)!)
                self.imagesJson.append(imageJson)
            }
            //self.printImagesJson()
            self.delegate?.didFinishParsingJson()
        }).resume()
    }
    
    //func downloadImages() {
    //    let jsons = imagesJson
    //}
    
    
    func downloadImageTask(imageURL: URL) {
        let queue = DispatchQueue(label: "imagesDownloaderQueue", qos: .background)
            queue.async {
            print("START: downloading new image")
            let request = URLRequest(url: imageURL)
            _ = URLSession.shared.dataTask(with: request, completionHandler: {
                (data, response, error) -> Void in
                
                if let er = error {
                    print(er)
                    return
                }
                
                guard let newImage = UIImage(data: data!)
                    else {
                        print("Couldn't get image")
                        return
                }
                
                self.images.append(newImage)
                self.delegate?.didFinishDownloadingImage(image: newImage)
                print("FINISH: image downloaded")
            }).resume() // URLSession closure end
            
        } // DispachQueue closure end
    }


    func printImagesJson() {
        for elem in imagesJson {
            print(elem.description)
        }
    }
}


protocol DownloaderDelegate {
    func didFinishDownloadingImage(image: UIImage)
    func didFinishParsingJson()
}
