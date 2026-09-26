//
//  DependencyContainer.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import Foundation

enum DependencyError: Error {
    case dependencyNotRegistered(String)
}

public class DependencyContainer {
    /// The shared instance of the `DependencyContainer`.
    @MainActor
    public static let shared = DependencyContainer()
    
    /// Initializes a new instance of the `DependencyContainer`.
    private init() {
        // No initialization required
    }
    
    /// A private dictionary that stores the registered dependencies.
    /// Uses ObjectIdentifier for O(1) key lookup instead of String(describing:)
    /// which triggers expensive Swift runtime type introspection.
    private var registry = [ObjectIdentifier: () -> Any]()
    
    /// Registers a new dependency with the container.
    ///
    /// - Parameters:
    ///   - type: The type of the dependency to register.
    ///   - factory: A closure that creates an instance of the dependency.
    public func register<T>(_ type: T.Type, _ factory: @autoclosure @escaping () -> T) {
        registry[ObjectIdentifier(type)] = factory
    }
    
    /// Resolves a registered dependency from the container.
    ///
    /// - Parameter type: The type of the dependency to resolve.
    /// - Returns: An instance of the requested dependency.
    /// - Throws: `DependencyError.dependencyNotRegistered` if the dependency has not been registered.
    public func resolve<T>(_ type: T.Type) throws -> T {
        guard let factory = registry[ObjectIdentifier(type)]?() as? T else {
            throw DependencyError.dependencyNotRegistered(String(reflecting: type))
        }
        
        return factory
    }
}
