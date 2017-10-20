//
//  ViewController.swift
//  DrawingStyleTransfer
//
//  Created by Torgeir Lien on 08/10/2017.
//  Copyright © 2017 Torgeir Lien. All rights reserved.
//

import UIKit
import jot


class DSTMainVC: UIViewController, JotViewControllerDelegate {

    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var styleImage: UIImageView!
    @IBOutlet weak var placeHolder: UIView!
    
    let jvc = JotViewController()
    let apiGateway = StyleTransferAPIDeepArtImpl()
    var currentStyle:Style? = nil {
        didSet {
            self.styleImage.image = currentStyle?.image
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStyles()
        setUpJot()
    }
    
    func setUpJot () {
        self.jvc.delegate = self
        
        self.addChildViewController(jvc)
        self.view.addSubview(jvc.view)
        self.jvc.didMove(toParentViewController: self)
        let rect = self.placeHolder.frame
        self.jvc.view.frame = rect
        self.jvc.state = JotViewState.drawing
    }
    
    func getDrawingImage () -> UIImage {
        let myImage = UIImage()
        return self.jvc.draw(on: myImage)
    }
    
    /*
     - (UIImage *)imageWithDrawing
     {
     UIImage *myImage = self.imageView.image;
     return [self.jotViewController drawOnImage:myImage];
     }
 */
    
    func loadStyles() {
        apiGateway.getStyles(maxNum: 1) { error, styles in
            self.currentStyle = styles.first
        }
    }
    @IBAction func testButtonTapped(_ sender: Any) {
        self.resultImage.image = self.getDrawingImage()
    }
}

