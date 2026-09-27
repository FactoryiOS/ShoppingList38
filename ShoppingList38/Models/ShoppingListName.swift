//
//  ShoppingListName.swift
//  ShoppingList38
//
//  Created by Сергей Хмелёв on 27.09.2026.
//

import Foundation

/// Единые правила сравнения названий в UI и хранилище.
nonisolated enum ShoppingListName {
    static func normalize(_ name: String) -> String {
        name
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(
                options: [.caseInsensitive, .diacriticInsensitive],
                locale: Locale(identifier: "en_US_POSIX")
            )
    }

    static func makeCopyName(
        for name: String,
        existingNormalizedNames: Set<String>
    ) -> String {
        var baseName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        var copyNumber = 1

        if let separator = baseName.lastIndex(where: { $0.isWhitespace }) {
            let suffix = baseName[baseName.index(after: separator)...]

            if suffix.allSatisfy({ $0.isNumber }),
               let number = Int(suffix),
               number < Int.max {
                baseName = String(baseName[..<separator])
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                copyNumber = number + 1
            }
        }

        while existingNormalizedNames.contains(normalize("\(baseName) \(copyNumber)")) {
            copyNumber += 1
        }

        return "\(baseName) \(copyNumber)"
    }
}
