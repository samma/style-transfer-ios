//
//  StyleTransferAPIDeepArtImplTest.swift
//  DrawingStyleTransferTests
//
//  Created by Torgeir Lien on 08/10/2017.
//  Copyright © 2017 Torgeir Lien. All rights reserved.
//

import XCTest

class StyleTransferAPIDeepArtImplTest: XCTestCase {
    
    func testUploadImage() {
        let apiGateway = StyleTransferAPIDeepArtImpl()
        let expect = expectation(description: "Uloading some image")
        
        
        let image = UIImage(named: "mountain.png", in: Bundle(for: StyleTransferAPIDeepArtImplTest.self), compatibleWith: nil)
        let style = Style(index: "1", image: image!, name: "whatever")
        
        apiGateway.convertImageWithStyle(image: image!, style: style) { (e, url) in
            if e != nil {
                XCTFail()
            }
            if (url == nil) {
                XCTFail()
            }
            print("The URL is: \(url!)")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            
        }

    }

    func testGetStyleDef() {
        let apiGateway = StyleTransferAPIDeepArtImpl()
        
        let expect = expectation(description: "Downloading styles definitions")

        
        apiGateway.downloadStyleDef() { styleResponses in
            XCTAssert(styleResponses.count > 0)
            expect.fulfill()
        }

        waitForExpectations(timeout: 10) { error in
            
        }
    }
    
    func testGetStyles() {
        let apiGateway = StyleTransferAPIDeepArtImpl()
        
        let expect2 = expectation(description: "Downloading styles")
        
        apiGateway.getStyles(maxNum: 5) { error, styles in
            XCTAssertEqual(styles.count, 5)
            XCTAssert(error == nil)
            expect2.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            
        }
    }
}
