//
//  LocationPublisher.swift
//  NexarLocationTest
//
//  Created by Ruslan Ponomarenko on 1/18/22.
//

import Foundation
import CoreLocation
import Combine

class LocationPublisher: NSObject {
    
    typealias Output = (longitude: Double, latitude: Double )
    typealias Failure = Never

    private let wrapped = PassthroughSubject<(Output), Failure>()

    private let locationManager = CLLocationManager()

  
    
    override init() {
        super.init()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.activityType = .fitness
        self.locationManager.requestAlwaysAuthorization()
        // allows update location only in Foreground as on task true
        self.locationManager.allowsBackgroundLocationUpdates = false
        self.enableLocationServices()
    }

    
    ///Enable location service . Request Permission
    private func enableLocationServices()
    {
        let authorizationStatus: CLAuthorizationStatus
        
        locationManager.delegate = self
        
        
        if #available(iOS 14, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        switch authorizationStatus {
        case .notDetermined:
        
            // we use just "requestWhenInUseAuthorization()" because we need to getting location in foreground mode ONLY
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted, .denied:
            print("status restricted, .denied \(authorizationStatus)")
            break
            
        case .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
            print("status authorizedWhenInUse \(authorizationStatus)")
            break
            
        case .authorizedAlways:
            print("status authorizedAlways \(authorizationStatus)")
            self.locationManager.startUpdatingLocation()
            break
        @unknown default:break;
        }
        
    }
    
}

extension LocationPublisher: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        wrapped.send((longitude: location.coordinate.longitude, latitude: location.coordinate.latitude))
    }
}

extension LocationPublisher: Publisher {
    func receive<Downstream: Subscriber>(subscriber: Downstream) where Failure == Downstream.Failure, Output == Downstream.Input {
        wrapped.subscribe(subscriber)
    }
}
