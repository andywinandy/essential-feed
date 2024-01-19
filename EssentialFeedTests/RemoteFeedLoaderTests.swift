//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Andreea Winandy on 19.01.24.
//

import XCTest

class RemoteFeedLoader {
    let client: HTTPClient
    let url: URL
    
    init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    func load() {
        client.get(from: url)
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
        let url = URL(string: "https://example.com")!
        
        _ = RemoteFeedLoader(client: spyClient, url: url)
        
        XCTAssertNil(spyClient.requestedURL)
    }
    
    func test_load_requestsDataFromURL() {
        let spyClient = HTTPClientSpy()
        let url = URL(string: "https://another-example.com")!
        
        let sut = RemoteFeedLoader(client: spyClient, url: url)
        
        sut.load()
        
        XCTAssertEqual(spyClient.requestedURL, url)
    }

}
