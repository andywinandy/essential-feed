//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Andreea Winandy on 06.10.23.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
