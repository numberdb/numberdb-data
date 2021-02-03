# numberdb-data

The raw data for numberdb.org is contained in this repository, more specifically, in the folder data/.

## For authors/contributors:

Each collection of numbers is stored in its own folder.
The main file for each collection is called collection.yaml.
It can import other files, such as id.yaml and numbers.yaml.

### Edit collections

To edit an existing collection, find the folder that contains it, and edit the contained collection.yaml (or some of the files that it refers to).

When saving the file, create a pull request onto the main branch with your changes; make sure to give sufficiently detailed comments about your commit(s) and pull request: For fixed typos, "fixed typos" will be enough; for larger mathematical changes more explanation might be necessary.

### New collections

New collections should be sufficiently relevant and have a sufficiently simple description.
The higher the revelance, the less simple the description may be.
In the end, numberdb.org should contain what users might search for.

To create a new collection, copy the folder of an existing collection, remove id.yaml (as it will be automatically created), and modify the content accordingly. 
Important: The folder name (just the top level, not the whole path) will also work as a url for that collection, thus it needs to be unique and it should be named in an appropriate way; although it can be renamed later.


## For editors:

After accepting pull-requests that contain new collections, run the indexer by clicking on Actions -> Indexer -> Run workflow -> Run workflow (on branch main). This will create id.yamls for the new collections.
