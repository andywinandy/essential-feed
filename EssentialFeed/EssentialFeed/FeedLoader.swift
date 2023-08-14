//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Demo on 09.08.23.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
