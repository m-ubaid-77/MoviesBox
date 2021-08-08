//
//  ImageUtility.swift
//  MoviesBox
//
//  Created by Muhammad Ubaid on 06/08/2021.
//

import UIKit

class ImageUtility: NSObject {

    static func getMoviePosterImage(from url : String , with name : String , completionHandler:@escaping (UIImage?)->Void)  {

        let name = name.replacingOccurrences(of: "/", with: "")
        
        let imagesDirectory = ImageUtility.getImagesDirectoryForPosters()

        if let  mainDirectory = imagesDirectory {
            
            let fileURL = mainDirectory.appendingPathComponent(name)
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                
                let image = UIImage(contentsOfFile: fileURL.path)
                completionHandler(image)
            }
            else{
                DispatchQueue.global(qos: .background).async {
                    let pictureURL = url+name
                    
                    var image : UIImage?
                    
                    guard let url = URL(string: pictureURL) else {
                        completionHandler(nil)
                        return
                    }
                    
                    if let imageData = try? Data.init(contentsOf: url) {
                        image = UIImage.init(data: imageData)
                        do {
                            try imageData.write(to: fileURL)
                            print("file saved")
                        } catch {
                            print("error saving file:", error)
                        }
                        completionHandler(image)
                    }
                }
            }
            
        }
        else{
            completionHandler(nil)
            return
        }
        
    }
    
    static func getImagesDirectoryForPosters() -> URL? {
        let documentsPath  = ImageUtility.getDocumentDirectory()
        let imagesPath = documentsPath.appendingPathComponent("Posters")
        
        do
        {
            try FileManager.default.createDirectory(atPath: imagesPath.path, withIntermediateDirectories: true, attributes: nil)
            return imagesPath
        }
        catch let error as NSError
        {
            NSLog("Unable to create directory \(error.debugDescription)")
            return nil
        }
    }
    
    static func getDocumentDirectory() -> URL {
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory
    }
}
