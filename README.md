# numberdb-data

The raw data for [numberdb.org](https://numberdb.org) is contained in this repository, more specifically, in the folder [data](https://github.com/numberdb/numberdb-data/tree/main/data/).

## For authors/contributors:

Each table of numbers is stored in its own folder.
The main file for each table is called table.yaml.
It can import other files, such as id.yaml and numbers.yaml.

### Edit tables

[Guide to editing tables](https://numberdb.org/help#section-guide-to-editing-tables)

### New tables

[Guide to adding new tables](https://numberdb.org/help#section-guide-to-creating-new-tables)

### Suggesting new tables

Ideas for new tables can be posted on https://github.com/numberdb/numberdb-data/issues, which we treat as a to-do list.
Please add background information about the data, unless you plan to enter the table in yaml format yourself.

## For editors:

After accepting pull-requests that contain new tables, [run the indexer](https://github.com/numberdb/numberdb-data/actions/workflows/indexer.yaml) by clicking on Actions -> Indexer -> Run workflow -> Run workflow (on branch main). This will create id.yamls for the new tables.
