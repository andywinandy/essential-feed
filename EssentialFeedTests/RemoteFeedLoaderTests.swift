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
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_load_requestsDataFromURLTwice() {
        let url = URL(string: "https://example.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
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
        client.complete(with: clientError)
        
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    func test_load_deliversErrorForNon200HTTPResponse() {
        let url = URL(string: "https://example.com")!
        let (sut, client) = makeSUT(url: url)
        
        let samples = [199, 201, 300, 400, 500]
        samples.enumerated().forEach { index, code in
            var capturedErrors = [RemoteFeedLoader.Error]()
            sut.load { error in capturedErrors.append(error) }
            client.complete(with: code, at: index)
            XCTAssertEqual(capturedErrors, [.badRequest])
        }
    }
    
    // MARK: - Helpers
    
    private class HTTPClientSpy: HTTPClient {
        
        var messages = [(url: URL, completion: ((HTTPClientResult) -> Void))]()
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> ()) {
            self.messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(with statusCode: Int, at index: Int = 0) {
            let httpResponse = HTTPURLResponse(
                url: messages[index].url,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )!
            
            messages[index].completion(.success(httpResponse))
        }
    }
    
    private func makeSUT(url: URL = URL(string: "https://default.com")!) -> (RemoteFeedLoader, HTTPClientSpy) {
        let spyClient = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: spyClient, url: url)
        return (sut, spyClient)
    }

}
