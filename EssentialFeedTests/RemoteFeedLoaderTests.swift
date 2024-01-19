//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Andreea Winandy on 19.01.24.
//

import XCTest

class RemoteFeedLoader {
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    func load() {
        client.get(from: URL(string: "https://example.com")!)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    
    func get(from url: URL) {
        self.requestedURL = url
    }
}

final class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let spyClient = HTTPClientSpy()
        
        _ = RemoteFeedLoader(client: spyClient)
        
        XCTAssertNil(spyClient.requestedURL)
    }
    
    func test_load_requestsDataFromURL() {
        let spyClient = HTTPClientSpy()
        
        let sut = RemoteFeedLoader(client: spyClient)
        
        sut.load()
        
        XCTAssertNotNil(spyClient.requestedURL)
    }

}
