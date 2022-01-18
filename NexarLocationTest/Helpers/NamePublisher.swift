//
//  NamePublisher.swift
//  NexarLocationTest
//
//  Created by Ruslan Ponomarenko on 1/18/22.
//

import Foundation

/// Publish the new FileName every N Seconds
class NamePublisher {
    private var timeInterval: Double = Constants.timeInterval
    
    private var timer: Timer!
    
    lazy private var nameFormatter: DateFormatter = {
        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "yyyy-MM-dd_HH:mm:ss"
        return dtFormatter
    }()

    init(timeInterval: Double ) {
        self.timeInterval = timeInterval
    }
    
    /// Start Getting file name
    func startTiming(completion: @escaping (String) -> ()){
       
        if timer != nil {
            timer.invalidate()
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: self.timeInterval, repeats: true) { [weak self] timer in
            if let newfileName = self?.nameFormatter.string(from: Date()) {
                completion(newfileName)
            }
            print("NEW NAME fired!")
           
       }
        timer.fire()
        
    }
    /// Stop providing the  new file name
    func stopTiming(){
        timer.invalidate()
    }
}
