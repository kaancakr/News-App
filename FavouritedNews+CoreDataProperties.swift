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

}
