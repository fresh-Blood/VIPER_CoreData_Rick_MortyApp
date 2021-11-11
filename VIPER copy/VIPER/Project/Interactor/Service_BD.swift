//
//  Service_BD.swift
//  VIPER
//
//  Created by Admin on 09.11.2021.
//

import Foundation
import UIKit
import CoreData


final class AllCharactersProxy: NSManagedObject {
    @NSManaged var info: Info?
    @NSManaged var results: [Results]?
    
    var reborn: AllCharacters {
        get {
            return AllCharacters(info: self.info, results: self.results)
        }
        set {
            self.info = newValue.info
            self.results = newValue.results
        }
    }
}

final class InfoProxy: NSManagedObject {
    
    @NSManaged var count: Int
    @NSManaged var pages: Int
    @NSManaged var next: String
    @NSManaged var prev: String?
    
    var reborn: Info {
        get {
            return Info(count: self.count, pages: self.pages, next: self.next, prev: self.prev)
        }
        set {
            self.count = newValue.count
            self.pages = newValue.pages
            self.next = newValue.next
            self.prev = newValue.prev
        }
    }
}

final class ResultsProxy: NSManagedObject {
    @NSManaged var id: Int
    @NSManaged var name: String
    @NSManaged var status: String
    @NSManaged var species: String
    @NSManaged var gender: String
    @NSManaged var origin: Origin?
    @NSManaged var image: String
    @NSManaged var location: Location?
    @NSManaged var url: String
    @NSManaged var created: String
    
    var reborn: Results {
        get {
            return Results(id: self.id, name: self.name, status: self.status, species: self.species, gender: self.gender, origin: self.origin, image: self.image, location: self.location, url: self.url, created: self.created)
        }
        set {
            self.id = newValue.id
            self.name = newValue.name
            self.status = newValue.status
            self.species = newValue.species
            self.gender = newValue.gender
            self.origin = newValue.origin
            self.image = newValue.image
            self.location = newValue.location
            self.url = newValue.url
            self.created = newValue.created
        }
    }
}

final class LocationProxy: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var url: String
    
    var reborn: Location {
        get {
            return Location(name: self.url, url: self.name)
        }
        set {
            self.url = newValue.url
            self.name = newValue.name
        }
    }
}

final class CharacterProxy: NSManagedObject {
    @NSManaged var id: Int
    @NSManaged var name: String
    @NSManaged var status: String
    @NSManaged var species: String
    @NSManaged var gender: String
    @NSManaged var origin: Origin?
    @NSManaged var location: Location?
    @NSManaged var image: String
    @NSManaged var episode: [String]?
    @NSManaged var url: String
    @NSManaged var created: String
    
    var reborn: Character {
        get {
            return Character(id: self.id, name: self.name, status: self.status, species: self.species, gender: self.gender, origin: self.origin, location: self.location, image: self.image, episode: self.episode, url: self.url, created: self.created)
        }
        set {
            self.url = newValue.url
            self.name = newValue.name
        }
    }
}

final class OriginProxy: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var url: String
    
    var reborn: Origin {
        get {
            return Origin(name: self.name, url: self.url)
        }
        set {
            self.url = newValue.url
            self.name = newValue.name
        }
    }
}

final class ImageProxy: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var url: String
    
    var reborn: Image {
        get {
            return Image(name: self.name, url: self.url)
        }
        set {
            self.url = newValue.url
            self.name = newValue.name
        }
    }
}
