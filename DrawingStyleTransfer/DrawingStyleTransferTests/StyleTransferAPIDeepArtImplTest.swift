//
//  StyleTransferAPIDeepArtImplTest.swift
//  DrawingStyleTransferTests
//
//  Created by Torgeir Lien on 08/10/2017.
//  Copyright © 2017 Torgeir Lien. All rights reserved.
//

import XCTest

class StyleTransferAPIDeepArtImplTest: XCTestCase {

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
            XCTAssert(styles.count == 0)
            XCTAssert(error == nil)
            expect2.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            
        }
    }
}
