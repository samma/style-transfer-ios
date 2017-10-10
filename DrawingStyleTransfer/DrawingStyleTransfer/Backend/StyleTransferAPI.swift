//
//  StyleTransferAPI.swift
//  DrawingStyleTransfer
//
//  Created by Torgeir Lien on 08/10/2017.
//  Copyright © 2017 Torgeir Lien. All rights reserved.
//

import Foundation
import UIKit

struct Style {
    let index:String
    let image:UIImage
    let name:String
}

protocol StyleTransferAPIProtocol {
    func getStyles(completion: @escaping (Error?, [Style]) -> Void)
    func convertImageWithStyle(image: UIImage, style: Style, completion: @escaping (Error?, UIImage?) -> Void)
}

extension StyleTransferAPIProtocol {
    func getStyles(completion: @escaping (Error?, [Style]) -> Void) {
        //DO asyn task

        let style = Style(index: "", image: UIImage(), name: "")
        var styles:[Style] = []
        styles.append(style)
        completion(nil, styles)
        
    }
    func convertImageWithStyle(image: UIImage, style: Style, completion: @escaping (Error?, UIImage?) -> Void){
        //DO some async task
        
        completion(nil, nil)
    }
}
