import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { MenuItem, FormControl, Select } from 'material-ui';
import { withStyles } from 'material-ui/styles';
import _ from 'lodash';

const styles = theme => ({
  formControl: {
    margin: theme.spacing.unit,
    minWidth: 80,
  },
});

class YearSelection extends Component {
  state = {
    value: ""
  };

  handleChange = event => {
    this.setState({ [event.target.name]: event.target.value });
  };

  render() {
    let { classes, startYear } = this.props;
    let years = _.range(new Date().getFullYear(), startYear - 1)

    return (
      // <form autoComplete="off">
        <FormControl className={classes.formControl}>
          <Select
            value={this.state.value}
            onChange={this.handleChange}
            placeholder={'Year'}
            inputProps={{
              name: 'value',
              id: 'year-select',
            }}
          >
            <MenuItem key="none">
              <em>None</em>
            </MenuItem>
            {(() => (
              years.map((year) => (
                <MenuItem key={year} value={year}>{year}</MenuItem>    
              ))
            ))()}
          </Select>
        </FormControl>
      // </form>
    );
  }
}

YearSelection.propTypes = {
  classes: PropTypes.object.isRequired,
};

export default withStyles(styles)(YearSelection);