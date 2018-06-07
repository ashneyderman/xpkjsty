import React, { Component } from 'react';
import { Table, TableHead, TableRow, TableBody, TableCell } from 'material-ui';
import { withStyles } from 'material-ui/styles';
import _ from 'lodash';

const data = [
  {
    "year": 2018,
    "ward": {
      "ward": "14",
      "alderman": "Edward M. Burke"
    },
    "month": 1,
    "count": 553
  },
  {
    "year": 2018,
    "ward": {
      "ward": "35",
      "alderman": "Carlos Ramirez-Rosa"
    },
    "month": 1,
    "count": 541
  },
  {
    "year": 2018,
    "ward": {
      "ward": "14",
      "alderman": "Edward M. Burke"
    },
    "month": 2,
    "count": 573
  },
  {
    "year": 2018,
    "ward": {
      "ward": "35",
      "alderman": "Carlos Ramirez-Rosa"
    },
    "month": 2,
    "count": 542
  },
  {
    "year": 2018,
    "ward": {
      "ward": "14",
      "alderman": "Edward M. Burke"
    },
    "month": 3,
    "count": 572
  },
  {
    "year": 2018,
    "ward": {
      "ward": "35",
      "alderman": "Carlos Ramirez-Rosa"
    },
    "month": 3,
    "count": 372
  },
  {
    "year": 2018,
    "ward": {
      "ward": "14",
      "alderman": "Edward M. Burke"
    },
    "month": 4,
    "count": 428
  },
  {
    "year": 2018,
    "ward": {
      "ward": "35",
      "alderman": "Carlos Ramirez-Rosa"
    },
    "month": 4,
    "count": 413
  },
  {
    "year": 2018,
    "ward": {
      "ward": "14",
      "alderman": "Edward M. Burke"
    },
    "month": 5,
    "count": 459
  },
  {
    "year": 2018,
    "ward": {
      "ward": "35",
      "alderman": "Carlos Ramirez-Rosa"
    },
    "month": 5,
    "count": 561
  },
  {
    "year": 2018,
    "ward": {
      "ward": "14",
      "alderman": "Edward M. Burke"
    },
    "month": 6,
    "count": 57
  },
  {
    "year": 2018,
    "ward": {
      "ward": "35",
      "alderman": "Carlos Ramirez-Rosa"
    },
    "month": 6,
    "count": 69
  }
];

class DataListing extends Component {
  render() {
    let { classes, wards, intervalSetup } = this.props;
    console.log('wards: ', wards);
    console.log('intervalSetup: ', intervalSetup);

    let columns = [ { name: "yearMonth", 
                      label: "YEAR-MONTH", 
                      width: 150, 
                      numeric: false 
                    } ];
    for (let ward of wards) {
      columns.push({ name: `ward${ward.ward}`, 
                     label: `WARD #${ward.ward}`, 
                     width: 100, 
                     numeric: true,
                     key: ward.ward });
    }

    let presentation = _.reduce(data, (acc, datapoint) => {
      console.log('datapoint: ', datapoint);
      let key = `${datapoint["year"]}-${datapoint["month"]}`
      if (acc[key]) {
        acc[key] = _.merge(acc[key], { [`${datapoint.ward.ward}`]: datapoint.count });
      } else {
        acc[key] = { [`${datapoint.ward.ward}`]: datapoint.count }
      }
      return acc;
    }, {});

    console.log('presentation: ', presentation);

    return (
      <Table className={classes.table}>
        <TableHead>
          <TableRow>
            {columns.map((column, idx) => (
              <TableCell
                key={idx}
                numeric={column.numeric}
                style={{ width: column.width }}
              >
                {column.label}
              </TableCell> 
            ))}
          </TableRow>
        </TableHead>
        <TableBody>
          {_.keys(presentation).map((key, rowIdx) => {
            let rowData = presentation[key];
            return (
              <TableRow key={rowIdx}>
                {columns.map((column, colIdx) => {
                  if (!column.key) {
                    return (
                      <TableCell 
                        numeric={column.numeric}
                        style={{ width: column.width }}
                        key={colIdx}
                      >
                        {key}
                      </TableCell>
                    );
                  } else {
                    return (
                      <TableCell 
                        numeric={column.numeric}
                        style={{ width: column.width }}
                        key={colIdx}
                      >
                        {rowData[column.key]}
                      </TableCell>
                    );
                  }
                })}
              </TableRow>
            );
          })}
        </TableBody>
      </Table>
    );
  }
}

const styles = theme => ({
  table: {
    // minWidth: 600,
    tableLayout: 'fixed'
  },
});

export default withStyles(styles)(DataListing);
