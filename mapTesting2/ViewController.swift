//  ITCS 4102 App
//
//  ViewController.swift
//
//
//  Created by
//  Serge Neri
//  Dallas Sanchez
//  Madlen Ivanova
//  John Williams
//  Yevgeniy Zholobovskiy
//

import UIKit
import MapKit

//Set the location for UNCC
let UNCC_LATITUDE = 35.305982
let UNCC_LONGITUDE = -80.733018

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    
    @IBOutlet var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    //declare empty arrays to hold crime points, and flags indicating they are being displayed
    var drugsAndAlcoholSet: [MapPoint] = []
    var theftSet: [MapPoint] = []
    var assaultSet: [MapPoint] = []
    var drugsAndAlcoholSetOn = true
    var theftSetOn = true
    var assaultSetOn = true
    
    
    //Code inside viewDidLoad is executed once the application succesfully loads.
    override func viewDidLoad() {
        
    //Invoke overriden method.
        super.viewDidLoad()
        
    //Set locationManager attributes to current function.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    
    //Set the mapView attribute to the current function, enable the user location to be shown.
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        
    //Set the coordinates for UNCC and set the region.
        let uncc = MKCoordinateRegionMake(CLLocationCoordinate2DMake(UNCC_LATITUDE, UNCC_LONGITUDE), MKCoordinateSpanMake(0.03,0.07));
    
        mapView.setRegion(uncc, animated: true);
    
        //Set the file path to the file path of the file in bundle.
        if let path = NSBundle.mainBundle().pathForResource("DatasetCrimes", ofType:".txt") {
    
            let crimeArrays = readFileIntoCrimeCategories(path)
    
            //Assign our class variables to the results in the crimeArrays tuple.
            drugsAndAlcoholSet = crimeArrays.drugsAndAlcohol
            theftSet = crimeArrays.theft
            assaultSet = crimeArrays.assault
    
    
            //Add annotations to the map for every crime by default.
            mapView.addAnnotations(drugsAndAlcoholSet)
            mapView.addAnnotations(theftSet)
            mapView.addAnnotations(assaultSet)
        }
    
    //Only update locaiton when the user authorizes it.
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways{
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        print(manager.location)
        //Delete previous notifications leftover from the last time the app was running
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        var crimeSum = 0, drugsAndAlcoholCount = 0, theftCount = 0, assaultCount = 0;
    
        //When the program starts, the location is nil
        //You have to wait until the location updates; will crash without this condition
        if(locationManager.location != nil){
            //Initialize user location variables
            let currentLocation = locationManager.location
            let longtitude = currentLocation?.coordinate.longitude
            let latitude = currentLocation?.coordinate.latitude
            var latDiff = Double(0), longDiff = Double(0);
            
            //Cycle through the drugs/alcohol map points and calculate it's distance from the user
            for coordinates in drugsAndAlcoholSet{
                latDiff = CLLocationDistance(coordinates.coordinate.latitude - latitude!)
                longDiff = CLLocationDistance(coordinates.coordinate.longitude - longtitude!)
                if(abs(latDiff) <= 0.003 && abs(longDiff) <= 0.003) {
                    drugsAndAlcoholCount+=1;
                }
            }
            
            //Cycle through the theft map points and calculate it's distance from the user
            for coordinates in theftSet{
                latDiff = CLLocationDistance(coordinates.coordinate.latitude - latitude!)
                longDiff = CLLocationDistance(coordinates.coordinate.longitude - longtitude!)
                if(abs(latDiff) <= 0.003 && abs(longDiff) <= 0.003){
            theftCount+=1;
                }
            }
    
            //Cycle through the assault map points and calculate it's distance from the user
            for coordinates in assaultSet{
                latDiff = CLLocationDistance(coordinates.coordinate.latitude - latitude!)
                longDiff = CLLocationDistance(coordinates.coordinate.longitude - longtitude!)
                if(abs(latDiff) <= 0.005 && abs(longDiff) <= 0.005){
                    assaultCount+=1;
                }
            }
    
        }
        
        //Calculate the sum of all the crimes
        crimeSum = drugsAndAlcoholCount + theftCount + assaultCount;
        //Print the number of different types of crimes to console to check that it is working
        //Create the notification object
        let locationNotification:UILocalNotification = UILocalNotification()
        locationNotification.regionTriggersOnce = true
    //Print the total number of crimes to confirm the location functionality is working
        print(crimeSum)
    
        //If the number of crimes around you each a certain threshold (5 crimes)
        if (crimeSum >= 5) {
            
            //Display a seperate notification depending on the type of crime there is the most of
            if (drugsAndAlcoholCount > theftCount && drugsAndAlcoholCount > assaultCount) {
                locationNotification.alertBody = "You have entered a high crime area, known for drugs"
                
            } else if (theftCount > drugsAndAlcoholCount && theftCount > assaultCount) {
                locationNotification.alertBody = "You have entered a high crime area, known for robbery/theft"
                
            } else if (assaultCount > drugsAndAlcoholCount && assaultCount > theftCount) {
                locationNotification.alertBody = "You have entered a high crime area, known for assault"
             
            } else {
                //If the number of crimes in the area are even, print a separate statement
                locationNotification.alertBody = "You have entered a high crime area, known for all types of crime"
                
            }
        }
        UIApplication.sharedApplication().scheduleLocalNotification(locationNotification)
    }
    //Start updating the location only if authorized
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse || status == CLAuthorizationStatus.AuthorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    
    /////
    //the 3 button functions toggle annotations off/on for their respective crimes when the
    //corresponding button is pressed by the user.
    @IBAction func theftButton(sender: UIBarButtonItem) {
    if theftSetOn {mapView.removeAnnotations(theftSet)}
    else {mapView.addAnnotations(theftSet)}
    
    theftSetOn = !theftSetOn
    }
    
    @IBAction func drugsButton(sender: AnyObject) {
    if drugsAndAlcoholSetOn {mapView.removeAnnotations(drugsAndAlcoholSet)}
    else {mapView.addAnnotations(drugsAndAlcoholSet)}
    
    drugsAndAlcoholSetOn = !drugsAndAlcoholSetOn
    }
    
    @IBAction func assaultButton(sender: UIBarButtonItem) {
    if assaultSetOn {mapView.removeAnnotations(assaultSet)}
    else {mapView.addAnnotations(assaultSet)}
    
    assaultSetOn = !assaultSetOn
    }
    /////
    
    
    //This function takes a filepath as a string and parses the data into mapPoint objects
    //Returns a tuple containing 3 arrays of mapPoint objects, [drugsAndAlcohol], [theft], and [assault]
    func readFileIntoCrimeCategories(path: String) -> (drugsAndAlcohol: [MapPoint], theft: [MapPoint], assault: [MapPoint])
    {
    //Using if let to open a streamreader for the file
    if let aStreamReader = StreamReader(path: path) {
    
    //defer closes the streamreaded when the current scope is exited
    defer {aStreamReader.close()}
    
    //While the streamreader has another line, read it
    while let line = aStreamReader.nextLine() {
    
    
    //read the line and parse it into title and coordinates then assaign that to a mapPoint
    let newString = line.stringByReplacingOccurrencesOfString("\r", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
    
    if newString.characters.count > 7 {
    
    let fullNameArr = newString.characters.split{$0 == "\t"}.map(String.init)
    let x_coord = Double(fullNameArr[3])
    let y_coord = Double(fullNameArr[4])
    let crime1 = MapPoint()
    
    crime1.coordinate = CLLocationCoordinate2DMake(x_coord!, y_coord!)
    crime1.title = fullNameArr[0]
    crime1.subtitle = fullNameArr[1] + fullNameArr[2]
    
        
    //if statements to decide which category and thus array the mapPoint should be grouped with
    if (fullNameArr[0] == "ALCOHOL VIOLATION-OTHER" || fullNameArr[0] == "POSSESSION OF MARIJUANA" || fullNameArr[0] == "MFG./SALE OF MARIJUANA") {
    crime1.imageName = "drugsAndAlcoholIcon"
    drugsAndAlcoholSet.append(crime1)
    
    }
    else if (fullNameArr[0] == "STRONG ARM ROBBERY" || fullNameArr[0] == "ARMED ROBBERY" || fullNameArr[0] == "RESIDENTIAL BURGLARY" || fullNameArr[0] == "COMMERCIAL BURGLARY"){
    crime1.imageName = "theftIcon"
    theftSet.append(crime1)
    
    }
    else if (fullNameArr[0] == "ASSAULT"){
    crime1.imageName = "assaultIcon"
    assaultSet.append(crime1)
    
    }}}
    }
    
    //return a tuple containing arrays of each crime set
    let tup = (drugsAndAlcoholSet,theftSet,assaultSet)
    return tup
    }
    
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    
    if !(annotation is MapPoint) {
    return nil
    }
    
    let reuseId = "4102"
    
    var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
    if anView == nil {
    anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
    anView!.canShowCallout = true
    } else {
    anView!.annotation = annotation
    }
    
    let mPoint = annotation as! MapPoint
    anView!.image = UIImage(named:mPoint.imageName)
    
    return anView
    }
    
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    }
    
    
    
    
    
}


