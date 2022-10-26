//
//  SharedTestHelpers.swift
//  TheMovieChallengeTests
//
//  Created by Ivan Lopez on 26/10/22.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "Any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "https://any-url.com")!
}
