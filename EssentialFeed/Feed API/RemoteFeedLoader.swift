//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Andreea Winandy on 19.01.24.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> ())
}

public enum HTTPClientResult {
    case success(HTTPURLResponse)
    case failure(Error)
}

public final class RemoteFeedLoader {
    
    public enum Error {
        case connectivity
        case badRequest
    }
    
    private let url: URL
    private let client: HTTPClient
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping ((Error) -> Void)) {
        client.get(from: url, completion: { result in
            switch result { // TODO: react on result properly
            case .success:
                completion(.badRequest)
            case .failure:
                completion(.connectivity)
            }
        })
    }
}
