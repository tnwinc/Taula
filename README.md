# Taula

![Taula](./Taula.jpg)

[![Build Status](https://travis-ci.org/tnwinc/Taula.svg?branch=master)](https://travis-ci.org/tnwinc/Taula)

"Infinite" or "Indefinite" scrolling in a react-based CardTable.

The name Taula comes from the Catalan word for Table.


## Usage

To use Taula in your code, you can simply do:
```
const InfiniteTable = require('Taula');
```

Then, use it like a regular React component.

### Props
All properties are optional unless specified otherwise.

- columnCount (required)
  - the number of columns that are present
- data (required)
  - contains the data that will be rendered into the table
  - all values are passed through to the customRowComponent, if used
  - Structure:
    - item (object or array)
      - an unstructured place to store the data for a row
      - If you don't provide a customRowComponent, it should be an Array
    - className
      - a className given to the row if customRowComponent isn't used
    - colSpanOverride
      - set as the colspan attribute of each `<td>`
      - useful if you want, for example, a cell to take up the full row
    - otherProps
      - a dumping ground for other row-implementation-specific properties
- chunkSize (required)
  - minimum number of pieces of data to load at a time
  - Taula should accomodate small chunks, but bigger chunks means better performance on the client
- customRowComponent
  - a React component that will be rendered for each piece of data passed in
  - must return a `<tr>` as its top level node
- headerElement
  - a React element that will be used as the table's `<thead>`
  - should have already been created using React.createElement
  - top level node must be a `<thead>`
- columnMetadata (array of objects)
  - useful for providing information about the columns to a customRowComponent
  - for example, could contain formatting info about the cells in each column
- loading
  - should be set to true while the parent is loading additional (or initial) data
  - when true, a loading message will be shown at the bottom of the table
- loadingMessage (node)
  - displayed at the bottom of the table when props.loading is true
- noDataMessage
  - displayed at the bottom of the table if no data has been passed in but the table is no longer loading
- loadData
  - a function that is used to request more data
  - it accepts a single parameter, bottomIndex
    - bottomIndex indicates that Taula needs the data from [0, bottomIndex)
- tableClassName
  - a className that is added to the top level component (currently a `<table>`)
