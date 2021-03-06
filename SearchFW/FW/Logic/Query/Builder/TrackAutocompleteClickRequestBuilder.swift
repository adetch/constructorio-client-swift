//
//  TrackAutocompleteClickRequestBuilder.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

class TrackAutocompleteClickRequestBuilder: RequestBuilder {

    private var itemName = ""
    private var hasSectionName = false

    init(tracker: CIOAutocompleteClickTracker, autocompleteKey: String) {
        super.init(autocompleteKey: autocompleteKey)
        set(itemName: tracker.clickedItemName)
        set(originalQuery: tracker.searchTerm)
        set(autocompleteSection: tracker.sectionName)
    }

    func set(itemName: String) {
        self.itemName = itemName
    }

    func set(originalQuery: String) {
        queryItems.append(URLQueryItem(name: Constants.TrackAutocompleteResultClicked.originalQuery, value: originalQuery))
    }

    func set(autocompleteSection: String?) {
        guard let sectionName = autocompleteSection else { return }
        self.hasSectionName = true
        queryItems.append(URLQueryItem(name: Constants.TrackAutocomplete.autocompleteSection, value: sectionName))
    }

    override func getURLString() -> String {
        let type = hasSectionName
                 ? Constants.TrackAutocompleteResultClicked.selectType
                 : Constants.TrackAutocompleteResultClicked.searchType

        return String(format: Constants.Track.trackStringFormat, Constants.Track.baseURLString, Constants.TrackAutocomplete.pathString, itemName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!, type)
    }

    override func addAdditionalQueryItems() {
        addTriggerQueryItem()
        addDateQueryItem()
    }

    private func addTriggerQueryItem() {
        queryItems.append(URLQueryItem(name: Constants.TrackAutocompleteResultClicked.trigger, value: Constants.TrackAutocompleteResultClicked.triggerType))
    }

    private func addDateQueryItem() {
        queryItems.append(URLQueryItem(name: Constants.TrackAutocompleteResultClicked.dateTime, value: String(Date().millisecondsSince1970)))
    }

}
