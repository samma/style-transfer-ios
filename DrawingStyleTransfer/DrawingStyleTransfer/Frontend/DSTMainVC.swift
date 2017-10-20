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
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
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
        activity.stopAnimating()
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
        return self.jvc.draw(on: UIImage())
    }
    
    func loadStyles() {
        apiGateway.getStyles(maxNum: 5) { error, styles in
            let roll = Int(arc4random_uniform(UInt32(styles.count)))
            print("Rolled \(roll)")
            self.currentStyle = styles[roll]
        }
    }
    @IBAction func testButtonTapped(_ sender: Any) {
        activity.startAnimating()
        self.resultImage.image = self.getDrawingImage()
        apiGateway.convertImageWithStyle(image: self.getDrawingImage(), style: self.currentStyle!) { (e, url) in
            if let url = url {
                self.apiGateway.pollThenDownloadImage(url: url) { (image) in
                    self.resultImage.image = image
                    self.activity.stopAnimating()
                }
            }
            else {
                self.activity.stopAnimating()
            }
        }
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
}

