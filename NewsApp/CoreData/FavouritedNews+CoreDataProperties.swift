//
//  FavouritedNews+CoreDataProperties.swift
//  NewsApp
//
//  Created by Kaan Çakır on 21.01.2025.
//
//

import Foundation
import CoreData


extension FavouritedNews {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouritedNews> {
        return NSFetchRequest<FavouritedNews>(entityName: "FavouritedNews")
    }
    

}

extension FavouritedNews : Identifiable {
    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var publishedDate: Date?
    @NSManaged public var url: String?
    @NSManaged public var author: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var popularity: NSNumber?
}
