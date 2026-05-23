# EpicCitySampleToPCGStudy
This is a personal study where I isolated specific procedural features demonstrated in the Epic City Sample project (which was originally created using Houdini) and attempted to replicate those features inside unreal engine 5.7 using only PCG.   The 2 primary features  I replicated with PCG were (straight) sidewalk generation and a subset of the sample's building generation 


### Building Module Breakdown

### Building Grammar Multi-Axis Subdivision Process 
The challenge with the buildings parts from the city sample was that I had to deal with multiple subdivision axes for PCG grammar which only operates on a single axis.  The solution involves using storing the size of each module (mesh) on multiple axes.  Then for each subdivision before the final subdivision, we choose a specific mesh to provide the size.   This is illustrated in the images below.   For a higher-order division, we choose a size from a module in the subsequent lower-order division.   

![image1](https://github.com/mharris382/EpicCitySampleToPCGStudy/blob/main/Images/BuildingGrammarSubdivisions1.png)

![image2](https://github.com/mharris382/EpicCitySampleToPCGStudy/blob/main/Images/BuildingGrammarSubdivisions2.png)

![image3](https://github.com/mharris382/EpicCitySampleToPCGStudy/blob/main/Images/BuildingGrammarSubdivisions3.png)
