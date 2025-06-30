//
//  TaskBox.swift
//  AutodocTest
//
//  Created by Михаил Бобылев on 23.04.2025.
//

import Foundation

final class TaskBox {
    let task: Task<Void, Never>

    init(_ task: Task<Void, Never>) {
        self.task = task
    }
}
