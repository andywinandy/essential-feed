//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Andreea Winandy on 19.01.24.
//

import XCTest

class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.get(from: URL(string: "https://example.com")!)
    }
}

class HTTPClient {
    static var shared = HTTPClient()

    func get(from url: URL) { }
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    
    override func get(from url: URL) {
        self.requestedURL = url
    }
}

final class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let spyClient = HTTPClientSpy()
        HTTPClient.shared = spyClient
        
        _ = RemoteFeedLoader()
        
        XCTAssertNil(spyClient.requestedURL)
    }
    
    func test_load_requestsDataFromURL() {
        let spyClient = HTTPClientSpy()
        HTTPClient.shared = spyClient
        
        let sut = RemoteFeedLoader()
        
        sut.load()
        
        XCTAssertNotNil(spyClient.requestedURL)
    }

}
