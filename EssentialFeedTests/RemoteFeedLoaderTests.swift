//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Andreea Winandy on 19.01.24.
//

import XCTest
import EssentialFeed

final class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://example.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_load_requestsDataFromURLTwice() {
        let url = URL(string: "https://example.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversConnectivityErrorForClientError() {
        let url = URL(string: "https://example.com")!
        let (sut, client) = makeSUT(url: url)
        
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load { error in
            capturedErrors.append(error)
        }
        
        let clientError = NSError(domain: "Connectivity", code: 0)
        client.completions[0](clientError)
        
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    // MARK: - Helpers
    
    private class HTTPClientSpy: HTTPClient {
        
        var requestedURLs = [URL]()
        var completions = [(Error) -> Void]()
        
        func get(from url: URL, completion: @escaping (Error) -> ()) {
            self.requestedURLs.append(url)
            self.completions.append(completion)
        }
    }
    
    private func makeSUT(url: URL = URL(string: "https://default.com")!) -> (RemoteFeedLoader, HTTPClientSpy) {
        let spyClient = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: spyClient, url: url)
        return (sut, spyClient)
    }

}
