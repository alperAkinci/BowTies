//
//  ViewController.swift
//  Bow Ties
//
//  Created by Alper on 03/03/16.
//  Copyright © 2016 allperr. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

//MARK: Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var timesWornLabel: UILabel!
    @IBOutlet weak var lastWornLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    
    /*The caller which is this class , responsible for setting the managed context , ViewController can use it without needing to know where it came from. */
    var managedContext: NSManagedObjectContext!
    
    //Keep track of the currently selected BowTie , so we can referance it from anywhere in our class
    var currentBowTie : BowTie!
    
//MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Accessing Core Data
        
        //1 - performs a fetch to make sure it isnt inserting the sample data into CoreData multiple times.
        insertSampleData()
        
        //2 - Create fetch request for the newly inserted BowTie entities.
        let request = NSFetchRequest(entityName: "BowTie")
        let firstTitle = segmentedControl.titleForSegmentAtIndex(0)//Red tie
            /*
            IMPORTANT:
            Predicate adds the condition to find the bow ties that matched the same color. Predicates are very flexible and powerful!
            For now , we know that this particular predicate is looking for bow ties that have their "searchKey" property set to the segmented controls first button title, "R"(Red) in this case.
            */
        request.predicate = NSPredicate(format:"searchKey == %@" , firstTitle!)
        
        do{
            //3 - Managed Context fetches data for us .Returns an Array of BowTie objects
            let results = try managedContext.executeFetchRequest(request) as! [BowTie]
            
            //4 - Populate the user ınterface with the first bow tie in the results array .
            currentBowTie  = results.first
            populate(currentBowTie)
        }catch let error as NSError{
            print("Could not fetch \(error) , \(error.userInfo)")
            
        }
        
        
        
    }
    
//MARK: Actions
    
    @IBAction func segmentedControl(control: UISegmentedControl) {
        
        // Each title of segment in the segmented control corresponds to a particular tie's search key attribute.
        let selectedValue = control.titleForSegmentAtIndex(control.selectedSegmentIndex)
        
        //Fetch the apprpriate bowtie using the NSPredicate
        let request = NSFetchRequest(entityName: "BowTie")
        request.predicate = NSPredicate(format: "searchKey == %@", selectedValue!)
        
        
        do{
            //results returns a bow tie specified by search key (there is only one per serach key)
            let results = try managedContext.executeFetchRequest(request) as! [BowTie]
            
            currentBowTie = results.first
            //Populate UI
            populate(currentBowTie)
        
        }catch let error as NSError {
            print("Could not fetch \(error) , \(error.userInfo)")
        }
        
        
        
        
    }
    
    @IBAction func wear(sender: AnyObject) {
        
        //Get the currently selected BowTie and increment its timeWorns attribute
        let times = currentBowTie.timesWorn?.integerValue
        //Wrap integer into NSNumber
        currentBowTie.timesWorn  = NSNumber(integer: times!+1)
        
        //Change the lastWorn date to Today
        currentBowTie.lastWorn = NSDate()
        
        //Save the managedContext to commit these changes to disk
        do{
            try managedContext.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        //Populate UI to visualize these changes
        populate(currentBowTie)
    }
    
    @IBAction func rate(sender: AnyObject) {
        
        // Alert Implementation
        let alert = UIAlertController(title: "New Rating", message: "Rate this bow tie", preferredStyle:.Alert)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action : UIAlertAction) -> Void in
            //Save Button gets the rating in TextField and updates it via updataRating function
            let textField = alert.textFields![0] as UITextField
            self.updateRating(textField.text!)
        }
        
        alert.addTextFieldWithConfigurationHandler { (textField :UITextField) -> Void in
            textField.keyboardType = .NumberPad
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        presentViewController(alert, animated: true , completion: nil)
        
    }

//MARK: Convenience Functions
    
    //Insert SampleData.plist to Core Data disk
    func insertSampleData(){
        let fetchRequest = NSFetchRequest(entityName: "BowTie")
        
        //?
        fetchRequest.predicate = NSPredicate(format: "searchKey != nil")
        
        //?
        let count = managedContext.countForFetchRequest(fetchRequest, error: nil)
        //?
        if count > 0 {return}
        
        //Getting SampleData
        let path = NSBundle.mainBundle().pathForResource("SampleData", ofType: "plist")
        
        //Turn SamplaData into a Array
        let dataArray = NSArray(contentsOfFile: path!)!
        
        //Iterate through each tie information
        for dict : AnyObject in dataArray {
            
            // Create a managedObject
            let bowtie = NSEntityDescription.insertNewObjectForEntityForName("BowTie", inManagedObjectContext: managedContext) as! BowTie
            
            // turn each tie to Dictionary
            let btDict = dict as! NSDictionary
            
            //Insert bowTie(a New BowTie entity) into your CoreData store
                bowtie.name = btDict["name"] as? String
                bowtie.searchKey = btDict["searchKey"] as? String
                bowtie.rating = btDict["rating"] as? NSNumber
                bowtie.lastWorn = btDict["lastWorn"] as? NSDate
                bowtie.timesWorn = btDict["timesWorn"] as? NSNumber
                bowtie.isFavorite = btDict["isFavorite"] as? NSNumber
                
                //Saving Binary Data
                let imageName = btDict["imageName"] as? String
                let image = UIImage(named: imageName!)
                let photoData = UIImagePNGRepresentation(image!)
                bowtie.photoData = photoData
            
                //Saving Transformable Data
                let tintColorDict = btDict["tintColor"] as? NSDictionary
                bowtie.tintColor = colorFromDict(tintColorDict!)
            
        }
        
        
    }
    

    //SampleData.plist stores colors in a dictionary that contains three keys : red ,green, blue. This method takes in this dictionary and returns a UIColor
    func colorFromDict(dict : NSDictionary) -> UIColor{
        let red = dict["red"] as! NSNumber
        let blue = dict["blue"] as! NSNumber
        let green = dict["green"] as! NSNumber
        
        let color = UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1)
        
        return color
    }
    
    //Populates the UI - get data from disk
    
    func populate(bowtie : BowTie){
        
        
        imageView.image = UIImage(data:bowtie.photoData!)
        nameLabel.text = bowtie.name
        ratingLabel.text = "Rating : \(bowtie.rating!.doubleValue)/5"
        timesWornLabel.text = "# times worn : \(bowtie.timesWorn!.integerValue)"
        favoriteLabel.hidden = !(bowtie.isFavorite!.boolValue)

        //Date Formatter : Turns date in to a string
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .NoStyle
        
        lastWornLabel.text = "Last Worn:" + dateFormatter.stringFromDate(bowtie.lastWorn!)
        
        //Tie Color changes the all elements on the screen
        view.tintColor = bowtie.tintColor as! UIColor
        
        /*
        IMPORTANT NOTE: 
        
        Xcode generates all NSManagedObject subclass properties as optional types. Notice that inside the populate method, you force unwrap all the Core Data properties on Bowtie using the ! operator.
        It’s okay to do this in this sample app since you know every bow tie has every attribute set. In a real application, it would be normal for some properties to be nil (e.g. maybe there is no photo available for a particular bowtie) so it would make more sense to use the if-let pattern.
        */
    
    
    }
    
    func updateRating(numericString : String ){
        
        //Convert the text from the alert view's textfield into a double and use it to update the current bow ties rating property.
        currentBowTie.rating = NSString(string: numericString).doubleValue
        
        
        //Commit the changes by saving managedContext and refresh the UI
        do{
            try managedContext.save()
            populate(currentBowTie)
        }catch let error as NSError{
            print("Could not save \(error),\(error.userInfo)")
            
            //if there is an error and it happened because the new rating was either too large or too small , then you present the alert view again via rate method.
            
            /*NSValidationNumberTooLargeError is an error code that maps to 1610 */
            if error.domain == NSCocoaErrorDomain && (error.code == NSValidationNumberTooLargeError || error.code == NSValidationNumberTooSmallError){
                rate(currentBowTie)
            }
            
        }
        
        

    }
    
    

    
}

