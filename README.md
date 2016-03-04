#Reminder Notes

Core Data by Tutorials By the raywenderlich.com

##Chapter 2 : NSManagedObject Subclasses
####BowTies 

Bow Ties is a lightweight bow tie management application. You can switch between the different colors of bow tie using the topmost segmented control—tap “R” for red, “O” for orange .

- ### Starting Notes
  - An attribute’s data type determines what kind of data you can store in it and how much space it will occupy on disk.  
  - Core Data provides the option of storing arbitrary blobs of binary data directly in your data model. These could be anything from images to PDF files, or anything else that can be serialized into zeroes and ones.
  - When you enable Allows External Storage, Core Data heuristically decides on a per-value basis if it should save the data directly in the database or store a URI that points to a separate file.
  - You can save any data type to Core Data (even ones you define) using the transformable type as long as your type conforms to the NSCoding protocol.
  - UIColor conforms to NSSecureCoding, which inherits from NSCoding, so it can use the transformable type out of the box. If you wanted to save your own custom object, you would first have to implement the NSCoding protocol.

- ### NSManagedObject subclass
  - The biggest problem with key-value coding is the fact that you’re accessing of data using strings instead of strongly-typed classes.
  - The best alternative to key-value coding is to create NSManagedObject subclasses for each entity in your data model. That means there will be a Bowtie class with correct types for each property.
  - In object-oriented parlance, an object is a set of values and a set of operations defined on those values. In this case, Xcode separates the two into two separate files. The values (i.e. the properties that correspond to the Bowtie attributes in your data model) are in BowTie+CoreDataProperties.swift whereas the operations are in (the currently empty) Bowtie.swift.
  - If your Bowtie entity changes, you can go to Editor\Create NSManagedObject Subclass... one more time to re-generate BowTie+CoreDataProperties.swift.
  - The second time you do this, you won’t re-generate Bowtie.swift so you don’t have to worry about overwriting any methods you add in there. In fact, this is the primary reason why Core Data generates two files instead of one as it used to do in previous versions of iOS.
  - Core Data persists an object graph to disk, so by default it works with objects. This is why you see primitive types like integers, doubles and Booleans boxed inside NSNumber. You can retrieve the actual attribute value with one of NSNumber’s convenience methods such as boolValue, doubleValue, and integerValue.
  - the @NSManaged attribute informs the Swift compiler that the backing store and implementation of a property will be provided at runtime instead of at compile time.
  - Two main benefit of subclassing:
    - Managed object subclasses unleash the syntactic power of Swift properties. By accessing attributes using properties instead of key-value coding, you again befriend Xcode and the compiler. 
    - You gain the ability to override existing methods or to add your own convenience methods. Note that there are some NSManagedObject methods you must never override. Check Apple’s documentation of NSManagedObject for a complete list

- ### Tips
  - Before you can do anything in Core Data, you first have to get a managed context to work on. Knowing how to propagate a managed context to different parts of your app is an important aspect of Core Data programming.
  - The way you store images in Core Data:
    - The property list contains a file name for each bow tie, not the file image—the actual images are in the project’s asset catalog. With this file name, you instantiate the UIImage and immediately convert it into NSData by means of UIImagePNGRepresentation() before storing it in the imageData property.
  - Xcode generates all NSManagedObject subclass properties as optional types. Notice that inside the populate method, you force unwrap all the Core Data properties on Bowtie using the ! operator.
  - It’s okay to do this in this sample app since you know every bow tie has every attribute set. In a real application, it would be normal for some properties to be nil (e.g. maybe there is no photo available for a particular bowtie) so it would make more sense to use the if-let pattern.


Referance from Core Data by Tutorials book, available at http://www.raywenderlich.com.

