# NRTagsControl
A nice and simple tags input control for iOS.

You are able to easily setup different colors for control elements and set different displaying modes

#### Tags will look like:

![NRTagsControl](http://gitlab.infoedge.com/naukriindia/iOS-Libraries/blob/master/NRTagControlLibrary/video.gif)


#### Follow the steps to create tags using NRTagsControl:
⁃    Drag n drop NRTagsControl and TagModel file to your project directory
⁃    Also add a cross/clear icon to your assets folder with name “crossgrey”.
⁃    Add a UIScrollView to your view controller in Interface Builder or can add a UIScrollView to your view programatically.
⁃    Assign the NRTagsControl as a superclass to the UIScrollView in Interface builder or cast your programatically created UIScrollView to the NRTagsControl.
⁃    Create the IBOutlet of scrollView in the view controller class:

```
    @IBOutlet weak var tagView: NRTagsControl!
```
⁃    Make your view controller class Inherit the properties and methods of NRTagsControlDelegate and UITextFieldDelegate.
⁃    Implement the required methods of NRTagsControlDelegate in your view controller class
⁃    Add a variable to the view controller class
```
var tagArray = [TagModel]()
```
⁃    In ViewDidLoad method, add the following code:
```
//if you want to edit the tags
tagView.mode = NRTagsControlMode.edit
//if you want to show the tags only
tagView.mode = NRTagsControlMode.list
tagView.tapDelegate = self

```
⁃   Implement the delegate NRTagsControlDelegate to get the list of tags you have entered in form of  model:
```
func tagControl(tagsControl: NRTagsControl, tappedAtIndex: Int) {
print("tapped at index")
}

func tagControl(arrayModel: [TagModel]) {
//get the tags in form of your model
print(arrayModel);
}
```
