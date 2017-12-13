//
//  ViewController.swift
//  Project5
//
//  Created by Claudio Carnino on 12/12/2017.
//  Copyright © 2017 Tugulab. All rights reserved.
//

import Cocoa
import MapKit


class ViewController: NSViewController {
    
    @IBOutlet private var questionLabel: NSTextField!
    @IBOutlet private var scoreLabel: NSTextField!
    @IBOutlet private var mapView: MKMapView!
    
    private var cities: [Pin] = []
    private var currentCity: Pin? = nil {
        didSet {
            if let cityName = currentCity?.title {
                questionLabel.stringValue = "Where is \(cityName)?"
            } else {
                questionLabel.stringValue = ""
            }
        }
    }
    private var score: Int = 0 {
        didSet {
            scoreLabel.stringValue = "Your total score is \(score)"
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(mapClicked(_:))))
        newGame()
    }
    
    
    @objc private func mapClicked(_ recognizer: NSGestureRecognizer) {
        if mapView.annotations.isEmpty {
            addPin(at: mapView.convert(recognizer.location(in: mapView), toCoordinateFrom: mapView))
        } else {
            mapView.removeAnnotations(mapView.annotations)
        }
    }
    
    
    private func addPin(at coordinate: CLLocationCoordinate2D) {
        guard let currentCity = currentCity else { return }
        
        let guessPin = Pin(title: "Your guess", subtitle: nil, coordinate: coordinate, color: .red)
        mapView.addAnnotation(guessPin)
        
        mapView.addAnnotation(currentCity)
        
        let guessPoint = MKMapPointForCoordinate(guessPin.coordinate)
        let cityPoint = MKMapPointForCoordinate(currentCity.coordinate)
        
        let distanceKm = Int(MKMetersBetweenMapPoints(guessPoint, cityPoint) / 1000)
        let maxDistanceToScorePoints: Int = 500
        let guessScore: Int = max(0, maxDistanceToScorePoints - distanceKm)
        
        // Update the total score
        score += guessScore
        
        currentCity.subtitle = "Your score is \(guessScore)"
        
        mapView.selectAnnotation(currentCity, animated: true)
        
        nextCity()
    }
    
    
    private func newGame() {
        // Reset the score
        score = 0
        // Create the cities array
        cities = [
            Pin(title: "London", subtitle: nil, coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -01275)),
            Pin(title: "Oslo", subtitle: nil, coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75)),
            Pin(title: "Paris", subtitle: nil, coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508)),
            Pin(title: "Rome", subtitle: nil, coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5)),
            Pin(title: "Washington DC", subtitle: nil, coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667)),
        ]
        // Show the first city
        nextCity()
    }
    
    
    private func nextCity() {
        if let guessCity = cities.popLast() {
            // Set the next city to guess
            currentCity = guessCity
            
        } else {
            currentCity = nil
            // Show the final result
            let alert = NSAlert()
            alert.messageText = "Your final score is \(score)"
            alert.runModal()
            // When the alert has been closed, start new game
            newGame()
        }
    }
    
}


extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let pin = annotation as? Pin else { return nil }
        let identifier = "Guess"
        
        let pinAnnotationView: MKPinAnnotationView
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            annotationView.annotation = annotation
            pinAnnotationView = annotationView
        } else {
            pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        pinAnnotationView.canShowCallout = true
        pinAnnotationView.pinTintColor = pin.color
        
        return pinAnnotationView
    }
    
}
