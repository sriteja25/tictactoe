//
//  History+CoreDataProperties.swift
//  TicTacToe
//
//  Created by Anuraag Jain on 04/04/17.
//  Copyright © 2017 app. All rights reserved.
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var playedOn: Date?
    @NSManaged public var winner: String?
    @NSManaged public var loser: String?

}
