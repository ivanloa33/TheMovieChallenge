//
//  XCTestCase+MemoryLeakTracking.swift
//  TheMovieChallengeTests
//
//  Created by Ivan Lopez on 26/10/22.
//

import Foundation
import XCTest

extension XCTestCase {
    func trackForMemmoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.")
        }
    }
}
