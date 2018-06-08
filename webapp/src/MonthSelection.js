import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { MenuItem, FormControl, Select } from 'material-ui';
import { withStyles } from 'material-ui/styles';

const styles = theme => ({
  formControl: {
    margin: theme.spacing.unit,
    minWidth: 120,
  },
});

const months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
]

class MonthSelection extends Component {
  render() {
    const { classes, onChange, value } = this.props;

    return (
      <form autoComplete="off">
        <FormControl className={classes.formControl}>
          <Select
            value={value || ''}
            onChange={onChange}
            placeholder={'Month'}
            inputProps={{
              name: 'value',
              id: 'controlled-open-select',
            }}
          >
            <MenuItem key="none" value="">
              <em>None</em>
            </MenuItem>
            {(() => (
              months.map((month, idx) => (
                <MenuItem key={idx+1} value={idx+1}>{month}</MenuItem>    
              ))
            ))()}
          </Select>
        </FormControl>
      </form>
    );
  }
}

MonthSelection.propTypes = {
  classes: PropTypes.object.isRequired,
};

export default withStyles(styles)(MonthSelection);