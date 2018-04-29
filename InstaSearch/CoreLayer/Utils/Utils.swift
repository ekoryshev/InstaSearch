import Foundation

import SwiftDate
import Foundation

enum DecodingError: LocalizedError {
    case `nil`
}

// swiftlint:disable:next identifier_name
func ToObject<T: Decodable>(
    _ type: T.Type,
    from value: Data?
    ) -> T? {
    guard let data = value else { return nil }
    do {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ decoder -> Date in
            do {
                let value = try decoder.singleValueContainer()
                let string = try value.decode(String.self)
                if let date = DateInRegion(
                    string: string,
                    format: .iso8601(options: .withInternetDateTime),
                    fromRegion: Region.Local()
                    ) {
                    return date.absoluteDate
                } else {
                    throw DecodingError.nil
                }
            } catch let error {
                throw error
            }
        })
        return try decoder.decode(type, from: data)
    } catch let error {
        debugLog(error)
    }
    return nil
}

// swiftlint:disable:next identifier_name
func ToObject<T: Decodable>(
    _ type: T.Type,
    bundle: Bundle,
    from pathForResource: String,
    ofType: String
    ) -> T? {
    if let path = bundle.path(forResource: pathForResource, ofType: ofType) {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return ToObject(T.self, from: data)
        } catch {
            return nil
        }
    }
    return nil
}

// swiftlint:disable:next identifier_name
public func LocalizedString(
    _ key: String,
    tableName: String? = nil,
    bundle: Bundle = Bundle.main,
    value: String = ""
    ) -> String {
    return NSLocalizedString(
        key,
        tableName: tableName,
        bundle: bundle,
        value: value,
        comment: ""
    )
}

func debugLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        if NSClassFromString("XCTestCase") == nil {
            let mappedItems = items.map { "\($0)" }
            let joinedItems = mappedItems.joined(separator: separator)
            print(joinedItems, terminator: terminator)
        }
    #endif
}
