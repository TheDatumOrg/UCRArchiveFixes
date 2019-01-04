This script modifies the new [UCR Time-Series Archive](https://www.cs.ucr.edu/%7Eeamonn/time_series_data_2018/) to make it backwards compatible with previous versions and enable older code and scripts to run without modifications.

The LoadandFixUCRArchive.m script makes the following changes:

1. The enumeration of classes is not consistent across datasets. As a result various packages cannot run smoothly across all datasets or code is required to handle particular datasets. We modify the class names as follows:
    1. Case 1: Class enumeration starts from "0" instead of "1" (which is the case in the majority of the datasets)
    2. Case 2: Binary classes are "-1" and "1" instead of "1" and "2" (which is the case in the majority of the binary datasets)
    3. Case 3. Class enumeration starts from "3" instead of "1" (which is the case in the majority of the datasets)
2. Ensures z-normalized datasets
3. Saves files using as delimiter ',' and with same numeric precision as the original dataset
4. TODO: handle different lengths
5. TODO: handle missing values

Steps:
1. Create a new directory (e.g., DATASETSNEW). We assume DATASETSOLD contains the current UCR Archive.
2. Remove desktop.ini file
3. Remove \*.ini files from subdirectories
4. Remove \*.md files from subdirectories
5. Remove \*.tsv suffixes from TRAIN and TEST files in each subdirectory
6. Copy directory structure from DATASETSOLD to DATASETSNEW
7. Run the LoadandFixUCRArchive.m script in Matlab IDE.

To perfom the above steps run the following commands:

```
mkdir DATASETSNEW
cd DATASETSOLD
rm -rf desktop.ini
find . -type f -name '*.ini' -delete
find . -type f -name '*.md' -delete
find . -name '*.tsv' -exec sh -c 'mv "$0" "${0%%.tsv}"' {} \;
find * -type d | cpio -pd ../DATASETSNEW
cd ..
Open Matlab and run LoadandFixUCRArchive
```
