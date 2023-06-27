//
//  File.swift
//  filmweb
//
//  Created by Marcin Nowowiejski on 25/06/2023.
//

@propertyWrapper struct Injected<T> {
    public var wrappedValue: T

    public init(_ d: Dependency = Dependency.shared) {
        wrappedValue = d.resolve()
    }
}

class Dependency {
    public static let shared: Dependency = .init()

    private var registrations = [String: () -> Any]()

    private init() {}

    public func register<T>(_ type: T.Type, _ factory: @escaping () -> T) {
        registrations[key(for: type)] = factory
    }

    public func resolve<T>() -> T {
        guard let resolved = registrations[key(for: T.self)]?() as? T else {
            fatalError("Dependency resolution error for type \(T.self) from \(registrations.keys.joined(separator: ", "))")
        }
        return resolved
    }

    public func registerSingleton<T>(_ type: T.Type, _ factory: @escaping () -> T) {
        var value: T!

        register(type) {
            if value == nil {
                value = factory()
            }
            return value
        }
    }

    public func clear() {
        registrations.removeAll()
    }

    private func key(for type: Any.Type) -> String {
        .init(describing: type)
    }
}
