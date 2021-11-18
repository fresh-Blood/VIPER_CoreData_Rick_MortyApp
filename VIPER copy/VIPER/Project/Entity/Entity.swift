import Foundation
import UIKit
import CoreData


final class AllCharacters: Codable {
    var info: Info?
    var results: [Results]?

    init(info: Info?, results: [Results]?) {
        self.info = info
        self.results = results
    }
}

final class Info: NSObject, Codable {
    var count: Int
    var pages: Int
    var next: String
    var prev: String?

    init(count: Int, pages: Int, next: String, prev: String?) {
        self.count = count
        self.pages = pages
        self.next = next
        self.prev = prev
    }
}

protocol UserResults {
    var id: Int { get set }
    var name: String { get set }
    var status: String { get set }
    var species: String { get set }
    var gender: String { get set }
    var origin: Origin? { get set }
    var image: String { get set }
    var location: Location? { get set }
    var url: String { get set }
    var created: String { get set }
}

final class Results: NSObject, Codable, UserResults {

    var id: Int
    var name: String
    var status: String
    var species: String
    var gender: String
    var origin: Origin?
    var image: String
    var location: Location?
    var url: String
    var created: String

    init(id: Int, name: String, status: String, species: String, gender: String, origin: Origin?, image: String, location: Location?, url: String, created: String) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.gender = gender
        self.origin = origin
        self.image = image
        self.location = location
        self.url = url
        self.created = created
    }
}

final class Location: NSObject, Codable {
    var name: String
    var url: String

    init(name: String, url: String) {
        self.url = url
        self.name = name
    }
}

final class Origin: NSObject, Codable {
    var name: String
    var url: String


    init(name: String, url: String) {
        self.url = url
        self.name = name
    }
}

final class Image: NSObject, Codable {
    var name: String
    var url: String


    init(name: String, url: String) {
        self.url = url
        self.name = name
    }
}

