/***
Title: Normalize to ROI
Adapted from:
	Author: Andrew Shum 
	Date: January 24, 2019
	Availability: https://forum.image.sc/t/normalization-of-a-series-of-images-based-on-the-pixel-value-in-a-fixed-point-or-roi/22412/4
Modified by:
	Author: Huaming He and N. Charles Harata, M.D., Ph.D. (HH: implementation and testing of the code; NCH: conceptualization, testing of the code and supervision)
	Date: August 9, 2022
	Program Description: 
           		The script 1) opens an image stack that contains multiple images (slices), 2) normalizes the intensities of all pixels in each image, so that the mean value of the pixel intensities within a specified region of interest (ROI) becomes equal to a pre-assigned reference (target) value, and 3) saves the processed image stack in a chosen location. 
***/

function clearROIManager(path) {
    count = roiManager("count");
    if (count != 0) {
        if (path == "choose"
            && getBoolean("Existing ROIs will be deleted."
                          +"\nWould you like to save them?")) {
            roiManager("save", "");
        } 
        else {
            // No execution on old, unnecessary ROIs 	
        }
        roiManager("deselect");
        roiManager("delete");
    }
}

macro "Normalize to ROI" { 
    // Open the image stack
    paths = File.openDialog("Select an Image Stack");
    open(paths);
    n = nSlices; // Read the number of images (slices) in this image stack
    close();
    
    // Select a directory where the processed image stack will be saved
    dir = getDirectory("Select (Or Create: Right Click + New Folder) a Save Directory"); 
    Dialog.create("Select Save Format"); // The default format is TIFF
    Dialog.addChoice("Which image format do you want to save results as?", newArray("TIFF", "JPEG", "GIF", "BMP", "PNG", "PGM"), "TIFF");
    Dialog.show();
format = Dialog.getChoice();

    // Assign a target mean intensity value of pixels in the ROI, noted as I(target) or “coef” (default:10,000)    
coef = getNumber("What number do you want to represent the mean?", 10000); 

    open(paths);
    title=getTitle();
    sliceName = substring(title, 0, lastIndexOf(title, ".")); // Keep the original file name for each image
    id = getImageID();
    waitForUser("Please select the region you want to normalize to.\nThen click \"Okay\".");
    if (isOpen("ROI Manager")) {
        clearROIManager("choose");
    } else {
        run("ROI Manager...");
    }
selectImage(id);

    // Use the built-in function “add” to add the newly generated ROI for mean-intensity calculation
    roiManager("add"); 
    close();
    setBatchMode(true);


// For loop to: 
// a) calculate the mean intensity within an ROI in an image, noted as I(measured) or “mean
    // b) calculate a ratio = I(target) / I(measured)
    // c) multiply the intensities of all pixels in the image by the ratio
    // This process is repeated for all images in the image stack
    for (i = 1; i <= n; i++) {
        open(paths);
        selectWindow(title);
        run("Make Substack...", "  slices=" + i);
 
        roiManager("select", 0);
        getStatistics(area, mean);
        roiManager("deselect");
        run("Select None");
        run("Multiply...", "value="+(coef/mean)+" stack");
        saveAs(format, dir+sliceName+"_"+(i));
        
        // This command is not necessary, but is convenient for showing all the results in a table
        roiManager("Multi-measure append");
        close();
    }
   
   setBatchMode(false);
   close();

   // Open all processed images as an image sequence, and save it with a preferred name
   run("Image Sequence...", "open=&dir scale=100 convert sort");
   stackName = getString("Enter a name for this image stack: ", "image stack");
   saveAs(format, dir+stackName);

   // Delete all the individual images saved earlier
   for(i = 1; i <= n; i++) {
       File.delete(dir + "/"+ sliceName + "_" + i + ".tif");
   }
   waitForUser("Normalizations complete and the processed image stack is saved! (Displaying log file with all 1s)");
}
