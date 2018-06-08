import React, { Component } from 'react';
import PropTypes from 'prop-types';
import _ from 'lodash';
import { Dialog, DialogContent, DialogContentText,
         DialogActions, Button, Select, MenuItem,
         FormControl } from 'material-ui';
import { withStyles } from 'material-ui/styles';
import { Query } from 'react-apollo';
import gql from 'graphql-tag';

const GET_ALL_WARDS = gql`
query GetAllWards{
  allWards{
    ward
    alderman
  }
}`;

class AddWardDialog extends Component {
  state = {
    value: ''
  }

  handleChange = event => {
    this.setState((prevState) => ({ value: event.target.value }));
  };

  render() {
    let { classes, excluded, addingWard, 
          handleDialogClose, handleSelection } = this.props;

    excluded = excluded || [];
    return (
      <Dialog
        open={addingWard}
        aria-labelledby="form-dialog-title"
      >
        <DialogContent>
          <DialogContentText>Please select a ward you would like to see the counts for</DialogContentText>
          <Query 
            query={GET_ALL_WARDS} 
          >
          {({loading, error, data}) => {
            if (loading) { return 'Loading wards data ...'; }
            if (error) { return `Uanble to load data error occured: ${error}` }

            let wardsListing = _.filter(data.allWards, (item) => (_.indexOf(excluded, item.ward) === -1))
            return (
              <FormControl className={classes.formControl}>
                <Select 
                  value={this.state.value}
                  onChange={this.handleChange}
                  placeholder={'Ward Alderman'}
                  inputProps={{
                    name: 'value',
                  }}>
                  <MenuItem value="">None</MenuItem>
                  {wardsListing.map((ward, idx) => {
                    return <MenuItem key={idx} value={ward.ward}>Ward {ward.ward}: {ward.alderman}</MenuItem>
                  })}
                </Select>
              </FormControl>
            );
          }}
          </Query>
        </DialogContent>
        <DialogActions>
          <Button 
            onClick={() => { 
              this.setState((prevState) => ({ ...prevState, value: "" }));
              handleDialogClose()
            }} 
            color="primary"
          >
            Cancel
          </Button>
          <Button 
            onClick={() => { 
              handleSelection( this.state.value );
              this.setState((prevState) => ({ ...prevState, value: "" }))
            }}
            color="primary" 
            disabled={this.state.value === ''}
          >
            Ok
          </Button>
        </DialogActions>
      </Dialog>
    );
  }
}

const styles = theme => ({
  title: {
    marginBottom: 16,
    fontSize: 14,
  },
  formControl: {
    width: '100%',
  }
});

AddWardDialog.propTypes = {
  classes: PropTypes.object.isRequired,
  handleDialogClose: PropTypes.func.isRequired,
  handleSelection: PropTypes.func.isRequired,
  excluded: PropTypes.arrayOf(PropTypes.string),
  addingWard: PropTypes.bool.isRequired
};

export default withStyles(styles)(AddWardDialog);
