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

        apiGateway.downloadStyleDef() { styles in
            expect.fulfill()
            print (styles)
        }

        waitForExpectations(timeout: 10) { error in
            
        }
    }
}
