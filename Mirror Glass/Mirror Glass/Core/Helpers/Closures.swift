//
//  Closures.swift
//  Mirror Glass
//
//  Created by インヤキ on 6/1/22.
//

import Foundation

// MARK: - Typealiases

// Empty Result + Void Return
typealias EmptyResult<ReturnType> = () -> ReturnType

// Custom Result + Custom Return
typealias SingleResultWithReturn<T, ReturnType> = ((T) -> ReturnType)
typealias DoubleResultWithReturn<T1, T2, ReturnType> = ((T1, T2) -> ReturnType)
typealias TripleResultWithReturn<T1, T2, T3, ReturnType> = ((T1, T2, T3) -> ReturnType)
// Max limit should be three arguments only

// Custom Result + Void Return
typealias SingleResult<T> = SingleResultWithReturn<T, Void>
typealias DoubleResult<T1, T2> = DoubleResultWithReturn<T1, T2, Void>
typealias TripleResult<T1, T2, T3> = TripleResultWithReturn<T1, T2, T3, Void>
// Max limit should be three arguments only

// Common
typealias VoidResult = EmptyResult<Void> // () -> Void
typealias ErrorResult = SingleResult<Error> // (Error) -> Void
typealias BoolResult = SingleResult<Bool> // (Bool) -> Void

// Optional. I think tuples with external parameter name is more readable
typealias SingleTuple<T> = T
typealias DoubleTuple<T1, T2> = (T1, T2)
typealias TripleTuple<T1, T2, T3> = (T1, T2, T3)

// MARK: - Default Closures

struct DefaultClosure {
  static func voidResult() -> VoidResult { {} }
  static func singleResult<T>() -> SingleResult<T> { { _ in } }
  static func doubleResult<T1, T2>() -> DoubleResult<T1, T2> { { _, _ in } }
  static func tripleResult<T1, T2, T3>() -> TripleResult<T1, T2, T3> { { _, _, _ in } }
}
