//
//  File.swift
//  flatfindingmanager
//
//  Created by Ladislav Szolik on 13.12.18.
//  Copyright © 2018 Ladislav Szolik. All rights reserved.
//

import Foundation


struct Flat {
    var address: FlatAddress
    var visitDate: Date
    var interested: Interested
    var applied: ApplicationStatus
}


struct Interested: Equatable {

    var id: Int
    var title: String

    static func ==(lhs: Interested, rhs: Interested) -> Bool {
        return lhs.id == rhs.id
    }
    
    static var all:[Interested]  {
        return [Interested(id: 0, title: "🤷‍♀️ Don't know yet"),
                Interested(id: 1, title: "👌 Yep"),
                Interested(id:2, title: "👎 Nope")]
    }
}


struct ApplicationStatus: Equatable {
    
    var id: Int
    var title: String
    
    static func ==(lhs: ApplicationStatus, rhs: ApplicationStatus) -> Bool {
        return lhs.id == rhs.id
    }
    
    static var all:[ApplicationStatus]  {
        return [ApplicationStatus(id: 0, title: "✍️ No"),
                ApplicationStatus(id: 1, title: "👍 Yes"),
                ]
    }
}

