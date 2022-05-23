//
//  String+Array+Extension.swift
//  Pharmacy
//
//  Created by taha hussein on 15/04/2022.
//

import UIKit
import RxCocoa
import RxRelay
import RxSwift
extension String {
    func search(_ term: String) -> Bool {
        let lowercasedSelf = self.lowercased()
        let lowercasedTerm = term.lowercased()
        return lowercasedSelf.localizedCaseInsensitiveContains(lowercasedTerm)
    }
}

extension Array where Element == Medicine? {
    func search(query: Event<String>) -> [Element] {
        return self.filter({
            guard let text = $0?.nameLocalized!, let queryElement = query.element else { return false }
            return text.search(queryElement)
        })
    }
}


