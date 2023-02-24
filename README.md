# Intensity normalization in an image stack

## Description
The macro script functions as an image-analysis tool in ImageJ (Schneider, Rasband & Eliceiri. “NIH Image to ImageJ: 25 years of image analysis”. Nature Methods, 9, 671-5, 2012. doi:10.1038/nmeth.2089) or Fiji (Schindelin, et al. “Fiji: an open-source platform for biological-image analysis”. Nature Methods, 9, 676-82, 2012. doi:10.1038/nmeth.2019). The script normalizes the pixel intensities of each image in an image stack, based on the intensity measurements within a specified region of interest (ROI).

The script asks the user to assign a target mean intensity value, I_target, and the ROI. In each image, the mean intensity of the pixels within the selected ROI is measured, I_measured, and the intensities of all pixels in the image is multiplied by the ratio = I_target / I_measured. The process is repeated for all images in an image stack.

## Getting Started

### Dependencies

* Run on ImageJ bundled with Java 8 or Fiji with Java 8

### Installing

* Instructions for installing the software application:
ImageJ: https://imagej.nih.gov/ij/download.html or https://imagej.net/ij/download.html
Fiji: https://imagej.net/software/fiji/downloads
* Install the new Macro under Plugins in the software application ImageJ or Fiji

### Executing program

* Run the Macro after successfully installing the Macro
* Follow the prompts given by the Macro
* The flowchart is shown below:

  ![image](https://user-images.githubusercontent.com/117980348/220819056-80cc63c5-2b0b-4273-9eae-2fdaa13e4ab0.png)

## Help
* The command shown below is to show all the calculated results in a table, and it can be deleted for faster image processing
```
roiManager("Multi-measure append");
```

## Authors

```
Adapted from:
	Author: Andrew Shum 
	Date: January 24, 2019
	Availability: https://forum.image.sc/t/normalization-of-a-series-of-images-based-on-the-pixel-value-in-a-fixed-point-or-roi/22412/4

```
```
Modified by:
	Author: Huaming He and N. Charles Harata, M.D., Ph.D. (HH: implementation and testing of the code; NCH: conceptualization, testing of the code and supervision)
	Date: August 9, 2022
```
