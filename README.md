# EpicCitySampleToPCGStudy
This is a personal study where I isolated specific procedural features demonstrated in the Epic City Sample project (which was originally created using Houdini) and attempted to replicate those features inside unreal engine 5.7 using only PCG. 
[The Epic City Sample is publically available to download and explore here](https://www.fab.com/listings/4898e707-7855-404b-af0e-a505ee690e68?lang=en).   The assets included in this project have been downscaled significantly to reduce the file size of this study. 


The 2 primary features  I replicated with PCG were (straight) sidewalk generation and a subset of the sample's building generation 


## Building Generation
This is the results of the generation process using several of the building sets from the epic sample project.  This is accomplished entirely within Unreal using PCG.  I have commented the primary PCG generation graph extensivly, but I will provide a high level overview of the process and theory here. 
![results](https://cdnb.artstation.com/p/assets/images/images/095/872/217/large/max-harris-screenshot00028.webp?1769727879)

[additional screenshot and snippets can be found on my artstation here](https://www.artstation.com/artwork/EzeYq2)

### Building Module Breakdown
To start the study, I identified and labeled all the individual meshes used for a specific building in the epic city sample.  I specifically choose a building that was built with non-uniformly sized meshes; in this case the bottom row of doors and the bottom 2 rows of windows are not the same height.  See next section for full process breakdown

![Breakdown1](https://github.com/mharris382/EpicCitySampleToPCGStudy/blob/main/Images/ModuleBreakdown1.png)

![Breakdown2](https://github.com/mharris382/EpicCitySampleToPCGStudy/blob/main/Images/ModuleBreakdown2.png)

### Building Grammar Multi-Axis Subdivision Process 
The challenge with the buildings parts from the city sample was that I had to deal with multiple subdivision axes for PCG grammar which only operates on a single axis.  The solution involves using storing the size of each module (mesh) on multiple axes.  Then for each subdivision before the final subdivision, we choose a specific mesh to provide the size.   This is illustrated in the images below.   For a higher-order division, we choose a size from a module in the subsequent lower-order division.   

![image1](https://github.com/mharris382/EpicCitySampleToPCGStudy/blob/main/Images/BuildingGrammarSubdivisions1.png)

![image2](https://github.com/mharris382/EpicCitySampleToPCGStudy/blob/main/Images/BuildingGrammarSubdivisions2.png)

![image3](https://github.com/mharris382/EpicCitySampleToPCGStudy/blob/main/Images/BuildingGrammarSubdivisions3.png)
