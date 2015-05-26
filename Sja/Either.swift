//
//  Either.swift
//  sja
//
//  Created by Ómar Kjartan Yasin on 25/05/15.
//  Copyright (c) 2015 Ómar Kjartan Yasin. All rights reserved.
//

import Foundation

public enum Either<T, U> {
    case Left(Box<T>)
    case Right(Box<U>)
    
    init (left: T) {
        self = .Left(Box(left))
    }
    
    init (right: U) {
        self = .Right(Box(right))
    }
    
    public var left: T? {
        switch self {
        case let .Left(box): return box.value
        default: return nil
        }
    }
    
    public var right: U? {
        switch self {
        case let .Right(box): return box.value
        default: return nil
        }
    }
}


public final class Box<T> {
    let value: T
    init(_ value: T) { self.value = value }
}
