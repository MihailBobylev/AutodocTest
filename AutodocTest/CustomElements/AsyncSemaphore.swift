//
//  AsyncSemaphore.swift
//  AutodocTest
//
//  Created by Михаил Бобылев on 23.04.2025.
//

import Foundation

actor AsyncSemaphore {
    private let maxConcurrent: Int
    private var currentCount: Int = 0
    private var waiters: [CheckedContinuation<Void, Never>] = []

    init(count: Int) {
        self.maxConcurrent = count
    }

    func wait() async {
        if currentCount < maxConcurrent {
            currentCount += 1
            return
        }

        await withCheckedContinuation { continuation in
            waiters.append(continuation)
        }
    }

    func signal() {
        if let next = waiters.first {
            waiters.removeFirst()
            next.resume()
        } else {
            currentCount = max(0, currentCount - 1)
        }
    }
}
