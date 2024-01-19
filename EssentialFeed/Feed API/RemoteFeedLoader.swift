//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Andreea Winandy on 19.01.24.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Error) -> ())
}

public final class RemoteFeedLoader {
    
    public enum Error {
        case connectivity
    }
    
    private let url: URL
    private let client: HTTPClient
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping ((RemoteFeedLoader.Error) -> ()) = { _ in }) { // remove default?
        client.get(from: url, completion: { error in
            completion(.connectivity)
        })
    }
}
