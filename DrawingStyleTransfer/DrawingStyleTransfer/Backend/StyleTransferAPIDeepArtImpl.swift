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
    
    func getStyles(maxNum: Int, completion: @escaping (Error?, [Style]) -> Void) {
        
        self.downloadStyleDef() { styleResponses in
            var stylesList:[Style] = []
            let myGroup = DispatchGroup()
            for (index, styleResponse) in styleResponses.enumerated() {
                Alamofire.request(styleResponse.location).responseImage { response in
                    if let image = response.result.value {
                        let oneStyle = Style(index: styleResponse.id, image: image, name: styleResponse.name)
                        stylesList.append(oneStyle)
                        print("image downloaded: \(image)")
                    }
                    myGroup.leave()
                }

                if (index > maxNum) {
                    break
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

