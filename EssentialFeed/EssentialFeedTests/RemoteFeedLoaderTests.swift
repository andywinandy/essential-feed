//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Andreea Winandy on 13.08.23.
//

import XCTest

class RemoteFeedLoader {
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
}

class HTTPClient {
    var requestedURL: URL?
}

final class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestData() {
        let client = HTTPClient()
        _ = RemoteFeedLoader(client: client)
        
        XCTAssertNil(client.requestedURL)
    }

}
