This script fixes a few issues observed in the new [UCR Time-Series Archive](https://www.cs.ucr.edu/%7Eeamonn/time_series_data_2018/) to make it backward compatible with previous versions (so that code and scripts developed for previous versions can run again without changes).

Steps:
1. Create a new directory (e.g., DATASETSNEW). We assume DATASETSOLD contains the current UCR Archive.
2. Remove desktop.ini file
3. Remove \*.ini files from subdirectories
4. Remove \*.md files from subdirectories
5. Remove \*.tsv suffixes from TRAIN and TEST files in each subdirectories
6. Copy directory structure from DATASETSOLD to DATASETSNEW
7. Run the LoadandFixUCRArchive script in Matlab IDE.

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
