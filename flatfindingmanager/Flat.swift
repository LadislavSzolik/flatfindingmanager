//
//  File.swift
//  flatfindingmanager
//
//  Created by Ladislav Szolik on 13.12.18.
//  Copyright © 2018 Ladislav Szolik. All rights reserved.
//

import Foundation
import UIKit

struct Flat:Codable {
    var address: FlatAddress
    var visitDate: Date?
    var isVisitRequired: Bool
    var interested: InterestedStatus
    var applied: ApplicationStatus
    var flatImages: [UIImage]
    var comments: String
    var monthlyRent: Double
    
    static var DocumentDictionary = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static var ArchiveURL:URL = DocumentDictionary.appendingPathComponent("flats").appendingPathExtension("plist")
    
    init(address: FlatAddress, visitDate: Date?, visitRequired: Bool, interested: InterestedStatus, applied: ApplicationStatus, flatImages: [UIImage], comments: String, monthlyRent: Double) {
        self.address = address
        self.visitDate = visitDate
        self.isVisitRequired = visitRequired
        self.interested = interested
        self.applied = applied
        self.flatImages = flatImages
        self.comments = comments
        self.monthlyRent = monthlyRent
    } 
    
    func currentStatus() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        if applied.id == 1 {
            return "Application sent"
        } else {
            if interested.id == 1 {
                return "Need to send the application"
            } else {
                if let date = visitDate {
                    
                    if date.compare(Date()) == ComparisonResult.orderedDescending {
                        let dateText = dateFormatter.string(from: date)
                        
                        let today = Date()
                        let calendar = Calendar.current
                        let components = calendar.dateComponents([.day], from: today, to: date)
                        
                        if let daysUntil = components.day {
                           return "Visit on \(dateText) (in \(daysUntil) Days)"
                        } else {
                            return "Visit on \(dateText)"
                        }
                        
                    } else {
                        return "Need to decide"
                    }
                } else {
                    return "Need to visit"
                }
            }
        }
    }
    
    static func saveToFile(flats: [Flat]) {
        let propertyListEncoder = PropertyListEncoder()
        debugPrint("start with encode")
        if let encodedData = try? propertyListEncoder.encode(flats) {
            debugPrint("encode finished. start with writing")
            try? encodedData.write(to: Flat.ArchiveURL)
            debugPrint("writing done")
        }
    }
    
    static func loadFromFile() -> [Flat] {
        let propertyListDecoder = PropertyListDecoder()
        if let archiveData = try? Data(contentsOf: Flat.ArchiveURL), let flatData = try? propertyListDecoder.decode(Array<Flat>.self, from: archiveData) {
            return flatData
        }
        return []
    }
    
    
    enum CodingKeys:CodingKey {
        case address
        case visitDate
        case isVisitRequired
        case interested
        case applied
        case comments
        case flatImages
        case monthlyRent
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        address = try container.decode(FlatAddress.self, forKey: .address)
        visitDate = try container.decode(Date.self, forKey: .visitDate)
        isVisitRequired = try container.decode(Bool.self, forKey: .isVisitRequired)
        interested = try container.decode(InterestedStatus.self, forKey: .interested)
        applied = try container.decode(ApplicationStatus.self, forKey: .applied)
        comments = try container.decode(String.self, forKey: .comments)
        monthlyRent = try container.decode(Double.self, forKey: .monthlyRent)
        
        let imagesData = try container.decode(Data.self, forKey: .flatImages)
        flatImages = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(imagesData) as? [UIImage] ?? []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(address, forKey: .address)
        try container.encode(visitDate, forKey: .visitDate)
        try container.encode(isVisitRequired, forKey: .isVisitRequired)
        try container.encode(interested, forKey: .interested)
        try container.encode(applied, forKey: .applied)
        try container.encode(comments, forKey: .comments)
        try container.encode(monthlyRent, forKey: .monthlyRent)
        
        let imagesData = try NSKeyedArchiver.archivedData(withRootObject: flatImages, requiringSecureCoding: false)
        try container.encode(imagesData, forKey: .flatImages)
    }
 
    
}

struct FlatAddress: Codable {
    var title: String
    var subTitle: String
}


struct InterestedStatus: Equatable, Codable {
    var id: Int
    var title: String
    static func ==(lhs: InterestedStatus, rhs: InterestedStatus) -> Bool {
        return lhs.id == rhs.id
    }
    static var all:[InterestedStatus]  {
        return [InterestedStatus(id: 0, title: "🤷‍♀️ Don't know yet"),
                InterestedStatus(id: 1, title: "👌 Yep"),
                InterestedStatus(id:2, title: "👎 Nope")]
    }
}


struct ApplicationStatus: Equatable, Codable {
    var id: Int
    var title: String
    static func ==(lhs: ApplicationStatus, rhs: ApplicationStatus) -> Bool {
        return lhs.id == rhs.id
    }
    static var all:[ApplicationStatus]  {
        return [ApplicationStatus(id: 0, title: "✍️ Not yet"),
                ApplicationStatus(id: 1, title: "👍 Yes")]
    }
}

