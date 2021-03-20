# numberdb-data

The raw data for [numberdb.org](https://numberdb.org) is contained in this repository, more specifically, in the folder [data](https://github.com/bmatschke/numberdb-data/tree/main/data/).

## For authors/contributors:

Each table of numbers is stored in its own folder.
The main file for each table is called table.yaml.
It can import other files, such as id.yaml and numbers.yaml.

### Edit tables

To edit an existing table, find the folder that contains it, and edit the contained table.yaml (or some of the files that it refers to).

When saving the file, create a pull request onto the main branch with your changes; make sure to give sufficiently detailed comments about your commit(s) and pull request: For fixed typos, "fixed typos" will be enough; for larger mathematical changes more explanation might be necessary.

### New tables

New tables should be sufficiently relevant and have a sufficiently simple description.
The higher the revelance, the less simple the description may be.
In the end, numberdb.org should contain what users might search for.

To create a new table, copy the folder of an existing table, remove id.yaml (as it will be automatically created), and modify the content accordingly. 
Important: The folder name (just the top level, not the whole path) will also work as a url for that table, thus it needs to be unique and it should be named in an appropriate way; although it can be renamed later.


## For editors:

After accepting pull-requests that contain new tables, [run the indexer](https://github.com/bmatschke/numberdb-data/actions/workflows/indexer.yaml) by clicking on Actions -> Indexer -> Run workflow -> Run workflow (on branch main). This will create id.yamls for the new tables.
