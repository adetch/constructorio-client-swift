//
//  SearchViewModel.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

class AutocompleteViewModel {

    let handleResultQueue: OperationQueue

    private(set) var searchTerm: String
    var results: [AutocompleteViewModelSection]

    var screenTitle: String

    weak var delegate: AutocompleteViewModelDelegate?

    init() {
        self.results = []
        self.searchTerm = ""
        self.screenTitle = Constants.UI.defaultScreenTitle

        self.handleResultQueue = OperationQueue()

        self.handleResultQueue.maxConcurrentOperationCount = 1
    }

    var lastResult: AutocompleteResult?

    internal func setupDataFromResult(result: AutocompleteResult) {
        self.searchTerm = result.query.query
        self.setResultFromDictionary(dictionary: result.response?.sections)
        self.lastResult = result

        self.delegate?.viewModel(self, didSetResult: result)
    }

    internal func setResultFromDictionary(dictionary: [String: [CIOResult]]?) {
        self.results = (dictionary ?? [:]).map { (section, items) in AutocompleteViewModelSection(items: items, sectionName: section) }
                                          .sorted { (s1, s2) in s1.sectionName < s2.sectionName }
    }

    func set(searchResult: AutocompleteResult, completionHandler: @escaping () -> Void) {
        self.handleResultQueue.addOperation { [weak self] in
            guard let selfRef = self else {
                return
            }

            if let lastResult = selfRef.lastResult {
                if searchResult.isInitiatedAfter(result: lastResult) {
                    selfRef.setupDataFromResult(result: searchResult)
                } else {
                    selfRef.delegate?.viewModel(selfRef, didIgnoreResult: searchResult)
                }
            } else {
                // no previous result, this one must be valid
                self?.setupDataFromResult(result: searchResult)
            }

            DispatchQueue.main.async(execute: completionHandler)
        }
    }

    func getResult(atIndexPath indexPath: IndexPath) -> CIOResult {
        return results[indexPath.section].items[indexPath.row]
    }

    func getSectionName(atIndex index: Int) -> String {
        return results[index].sectionName
    }
}
