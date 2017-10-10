//
//  StyleTransferAPIDeepArtImpl.swift
//  DrawingStyleTransfer
//
//  Created by Torgeir Lien on 08/10/2017.
//  Copyright © 2017 Torgeir Lien. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

struct DeepArtStyleResponse {
    var id:String
    var location:String
    var name:String
}

class StyleTransferAPIDeepArtImpl : StyleTransferAPIProtocol {
    let styleEndPoint = URL(string: "https://turbo.deepart.io/styles/")
    let uploadEndPoint = URL(string: "https://turbo.deepart.io/api/post/")
    let downloadEndPoint = "https://turbo.deepart.io/media/output/"

    func convertImageWithStyle(image: UIImage, style: Style, completion: @escaping (Error?, URL?) -> Void) {
        
        let imageData = UIImageJPEGRepresentation(image, 1)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(style.index.data(using: String.Encoding.utf8)!, withName: "style")
            multipartFormData.append(imageData!, withName: "input_image", fileName: "input_image", mimeType: "image/jpeg")
        }, to:uploadEndPoint!)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                /*upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })*/
                
                upload.responseData { response in
                    let myImageId = String(bytes: response.data!, encoding: String.Encoding.utf8)
                    completion(nil, self.makeDownloadURL(id: myImageId!))
                }
            case .failure(let encodingError):
                completion(encodingError, nil)
            }
        }
    }
    
    internal func makeDownloadURL(id: String) -> URL? {
        return URL(string: (self.downloadEndPoint + id + ".jpg"))
    }
    func getStyles(maxNum: Int, completion: @escaping (Error?, [Style]) -> Void) {
        
        self.downloadStyleDef() { styleResponses in
            var stylesList:[Style] = []
            let myGroup = DispatchGroup()
            for (index, styleResponse) in styleResponses.enumerated() {
                if (index >= maxNum) {
                    break
                }
                myGroup.enter()
                Alamofire.request(styleResponse.location).responseImage { response in
                    if let image = response.result.value {
                        let oneStyle = Style(index: styleResponse.id, image: image, name: styleResponse.name)
                        stylesList.append(oneStyle)
                        print("image downloaded: \(image)")
                    }
                    myGroup.leave()
                }
            }
            
            myGroup.notify(queue: .main) {
                print("Finished all requests.")
                completion(nil,stylesList)
            }
        }
     }
    
    internal func downloadStyleDef(completion: @escaping ([DeepArtStyleResponse]) -> Void) {
        Alamofire.request(
            styleEndPoint!
            ).response { response in
                let responseString = String(data: response.data!, encoding: String.Encoding.utf8) as String!
                completion(self.parseStyleDef(responseString: responseString))
        }
    }
    
    internal func parseStyleDef(responseString: String?) -> [DeepArtStyleResponse]{
        let splitResponse = responseString?.components(separatedBy: "\n")
        
        var styles:[DeepArtStyleResponse] = []
        
        for styleDef in splitResponse! {
            let splitStyleDefs = styleDef.components(separatedBy:" ")
            if (splitStyleDefs.count == 3) {
                let oneStyle = DeepArtStyleResponse(id: splitStyleDefs[0], location: splitStyleDefs[1], name: splitStyleDefs[2])
                styles.append(oneStyle)
            }
        }        
        return styles
    }

}

