//
//  ViewController.swift
//  DrawingStyleTransfer
//
//  Created by Torgeir Lien on 08/10/2017.
//  Copyright © 2017 Torgeir Lien. All rights reserved.
//

import UIKit

class DSTMainVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let apiGateway = StyleTransferAPIDeepArtImpl()

    override func viewDidLoad() {
        super.viewDidLoad()
        apiGateway.getStyles(maxNum: 5) { error, styles in
            for style in styles {
                let mview = UIImageView(image: style.image)
                self.collectionView.addSubview(mview)
            }
        }
    }
    
    @IBAction func loadStyleTapped(_ sender: Any) {

    }
    
    
}

