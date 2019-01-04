This script modifies the new [UCR Time-Series Archive](https://www.cs.ucr.edu/%7Eeamonn/time_series_data_2018/) to make it backwards compatible with previous versions (so that code and scripts developed for previous versions can run again without changes).

Steps:
1. Create a new directory (e.g., DATASETSNEW). We assume DATASETSOLD contains the current UCR Archive.
2. Remove desktop.ini file
3. Remove \*.ini files from subdirectories
4. Remove \*.md files from subdirectories
5. Remove \*.tsv suffixes from TRAIN and TEST files in each subdirectories
6. Copy directory structure from DATASETSOLD to DATASETSNEW
7. Run the LoadandFixUCRArchive script in Matlab IDE.

The LoadandFixUCRArchive script fixes the following observed issues:

1. The numbering of classes is not consistent across datasets, which creates issues in various classification packages. We modify the names as follows:
    1. Case 1: Class enumeration starts from 0 instead of 1 (which is the case in the majority of the datasets)
    2. Case 2: Binary classes are -1 and 1 instead of 1 and 2 (which is the case for most binary datasets in the archive)
    3. Case 3. Class enumeration starts from 3 instead of 1 (which is the case in the majority of the datasets)
2. Ensures z-normalized datasets
3. Saves files using as delimiter ',' and with same precision as the original dataset.
4. TODO: handle different lengths
5. TODO: handle missing values

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
