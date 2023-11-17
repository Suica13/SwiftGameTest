//
//  CharacterModel.swift
//  SwiftGameTest
//
//  Created by student on 2023/11/15.
//

import Foundation

struct CharacterModel
{
    
    enum GrowthState
    {
        case childhood//Level 1
        case growthPeriod//Level 2
        case maturity//Level 3
    }
    
    var currentGrowthState: GrowthState //now Level
    var currentHitPoint: Int //now Hp
    var maxHitPoint: Int //max Hp
    var livingEnvironment: Int //now living environment
    var favorabilityRating: Int //now favorability
    var lastFeedDate: Date? //last feed date
    var last12HourFeedCount: Int //last feed times
    var growthFactor:Int //exp
    {
        favorabilityRating / 10
    }
    var dateOfDeath:Date //day to die
    var isDead:Bool//already dead
    {
        let timeInterval = Date().timeIntervalSince(dateOfDeath)
        return (0<timeInterval)//if(nowDate>0){isDead = true}
    }
    
    mutating func feeding()
    {
        var isPassed:Bool = true
        
        //if last feed date later than 12 hours
        if let lastFeedDate = lastFeedDate
        {
            let timeInterval = Date().timeIntervalSince(lastFeedDate)
            let time = Int(timeInterval)
            let hour = time / 3600 % 24
            isPassed = (12 < hour)
        }
        
        // spawn recovery
        let recoveryValue: Int
        if !isPassed
        {
            self.last12HourFeedCount += 1
            recoveryValue = 1
        }
        else
        {
            self.last12HourFeedCount = 0
            recoveryValue = Int.random(in: 1..<10)
        }
        
        lastFeedDate = Date()
        currentHitPoint = min(maxHitPoint, (currentHitPoint + recoveryValue))
    }
    
    // cleaning Toilet
    mutating func toiletCleaning()
    {
        livingEnvironment = 10
    }

    //favorability Up
    mutating func favorabilityUp(value: Int)
    {
        favorabilityRating = min(10,favorabilityRating + value)
    }
}
