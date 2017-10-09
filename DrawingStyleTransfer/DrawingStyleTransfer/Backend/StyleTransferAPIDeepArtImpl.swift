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

struct DeepArtStyleResponse {
    var id:String
    var location:String
    var name:String
}

class StyleTransferAPIDeepArtImpl : StyleTransferAPIProtocol {
    let styleEndPoint = URL(string: "https://turbo.deepart.io/styles/")
    
    func getStyles(completion: @escaping (Error?, [Style]) -> Void) {
        
        //self.downloadStyleDef(completion: <#T##([String]) -> Void#>)
        
    
        
        /*
        Alamofire.request(
            URL(string: "http://localhost:5984/rooms/_all_docs")!,
            method: .get,
            parameters: ["include_docs": "true"])
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(response.result.error)")
                    completion(nil,[])
                    return
                }
                
                guard let value = response.result.value as? [String: Any],
                    let rows = value["rows"] as? [[String: Any]] else {
                        print("Malformed data received from fetchAllRooms service")
                        completion(nil, [])
                        return
                }
                
                let rooms = rows.flatMap({ (roomDict) -> RemoteRoom? in
                    return RemoteRoom(jsonData: roomDict)
                })
                
                completion(rooms)
        }
        
        let style = Style(index: 1, image: UIImage())
        var styles:[Style] = []
        styles.append(style)
        completion(nil, styles)
     */
     }
    
    internal func downloadStyleDef(completion: @escaping ([String]) -> Void) {
        Alamofire.request(
            styleEndPoint!
            ).response { response in

                var backToString = String(data: response.data!, encoding: String.Encoding.utf8) as String!
                
                completion([String]())
        }
    }

}

extension String {
    parseAsDeepArtStyle() {
    
    }
}

