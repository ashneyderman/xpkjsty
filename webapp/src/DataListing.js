import React, { Component } from 'react';
import PropTypes from 'prop-types';
import _ from 'lodash';
import { Table, TableHead, TableRow, TableBody, TableCell, Typography } from 'material-ui';
import { withStyles } from 'material-ui/styles';
import { Query } from 'react-apollo';
import gql from 'graphql-tag';

const GET_GRAFITTI_REPORT = gql`
query GetGrafittiReport($fromYear: Int!, 
                        $fromMonth: Int, 
                        $toYear: Int,
                        $toMonth: Int, 
                        $wardIds: [ID]) {
  grafittiReport(fromYear: $fromYear, fromMonth: $fromMonth, 
                 toYear: $toYear, toMonth: $toMonth, 
                 wardIds: $wardIds){
    count
    year
    month
    ward {
      ward
      alderman
    }
  }
}`;

class DataListing extends Component {
  render() {
    let { classes, wards, intervalSetup } = this.props;
    let { fromYear, fromMonth, toYear, toMonth } = intervalSetup; 

    if(!(wards.length > 0 && fromYear)) {
      return (
        <Typography color="error">Incomplete Criteia. At least one ward and from year has to be specified.</Typography>
      );
    }

    let columns = [ { name: "yearMonth", 
                      label: "YEAR-MONTH", 
                      width: 150, 
                      numeric: false 
                    } ];

    for (let ward of wards) {
      columns.push({ name: `ward${ward}`, 
                     label: `WARD #${ward}`, 
                     width: 100, 
                     numeric: true,
                     key: ward });
    }

    let params = {
      wardIds: wards,
      fromYear: fromYear
    };

    if(fromMonth) { params = { ...params, fromMonth } }
    if(toYear) { params = { ...params, toYear } }
    if(toMonth) { params = { ...params, toMonth} }

    return (
      <Query
        query={GET_GRAFITTI_REPORT}
        variables={params}
      >
      {({loading, error, data}) => {
        if (loading) {
          return (
            <Typography color="textSecondary">Loading data ...</Typography>
          );
        }
        if (error) {
          return (
            <Typography color="error">Error fetching the data: {error}</Typography>
          );
        }

        let presentation = _.reduce(data.grafittiReport, (acc, datapoint) => {
          let key = `${datapoint["year"]}-${datapoint["month"]}`
          if (acc[key]) {
            acc[key] = _.merge(acc[key], { [`${datapoint.ward.ward}`]: datapoint.count });
          } else {
            acc[key] = { [`${datapoint.ward.ward}`]: datapoint.count }
          }
          return acc;
        }, {});
    
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
      }} 
      </Query>
    );
  }
}

const styles = theme => ({
  table: {
    tableLayout: 'fixed'
  },
});

DataListing.propTypes = {
  classes: PropTypes.object.isRequired,
  intervalSetup: PropTypes.object.isRequired, 
  wards: PropTypes.arrayOf(PropTypes.string).isRequired
};

export default withStyles(styles)(DataListing);