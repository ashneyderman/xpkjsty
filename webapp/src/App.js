import React, { Component } from 'react';
import _ from 'lodash';
import { AppBar, Grid, Button, Typography, Divider } from 'material-ui';
import { withStyles } from 'material-ui/styles';

import WardCard from './WardCard';
import IntervalSelection from './IntervalSelection';
import DataListing from './DataListing';
import AddWardDialog from './AddWardDialog';

import AddIcon from 'material-ui-icons/Add';

class App extends Component {

  state = {
    wards: [],
    intervalSetup: {
      fromYear: new Date().getFullYear(),
      fromMonth: null,
      toYear: null,
      toMonth: null
    },
    addingWard: false
  }
  
  handleAddWardDialogOpen = () => {
    this.setState((prevState) => ({ ...prevState, addingWard: true }));
  }

  handleAddWardDialogClose = () => {
    this.setState((prevState) => ({ ...prevState, addingWard: false }));
  }

  addWard = (ward) => {
    this.setState((prevState) => (
      { ...prevState,
        addingWard: false, 
        wards: [ ...prevState.wards, `${ward}`] 
      }
    ));
  }

  clearWard = (ward) => {
    this.setState((prevState) => (
      { ...prevState,
        wards: _.remove(prevState.wards, (o) => ( o !== ward ))
      }
    ))
  }

  resetIntervalSetup = (newSetup) => {
    console.log('newSetup: ', newSetup);
    this.setState((prevState) => ({
      ...prevState,
      intervalSetup: newSetup
    }));
  }

  render() {
    let { classes } = this.props;
    let { wards, intervalSetup, addingWard } = this.state;
    return (
      <div className={classes.root}>
        <AddWardDialog 
          excluded={wards}
          addingWard={addingWard} 
          handleDialogClose={this.handleAddWardDialogClose}
          handleSelection={this.addWard}
        />
        <AppBar position="absolute" className={classes.appBar}>
          <Typography variant="title">
            Chicago Grafitti Requests Reporting
          </Typography>
        </AppBar> 
        <Grid container className={classes.container} spacing={16}>
          <Grid item xs={3}>
            <IntervalSelection 
              intervalSetup={intervalSetup}
              onChange={this.resetIntervalSetup} />
          </Grid>
          <Grid item xs={9}>
            <Grid container justify="flex-start" spacing={16}>
              {wards.map((ward, idx) => (
                <Grid key={idx} item>
                  <WardCard ward={ward} clearHandler={this.clearWard} />
                </Grid>
              ))}
              <Grid item>
                <Button 
                  variant="fab" 
                  color="secondary" 
                  aria-label="add" 
                  className={classes.button}
                  onClick={this.handleAddWardDialogOpen}
                  disabled={this.state.wards.length >= 3}
                >
                  <AddIcon />
                </Button>
                
                {(() => {
                  if (wards.length === 0) {
                    return (
                      <React.Fragment>
                      <Typography component="p">
                        To view report data, please click the plus button above
                        to select a ward.<br /> 
                        You will be able to selct up-to three different wards. <br />
                        The data will show up below when enough criteria is specified.
                      </Typography>
                      </React.Fragment>
                    );
                  }
                })()}
                
              </Grid>
            </Grid>
          </Grid>
          <Grid item xs={12}>
          <Divider />
          </Grid>
          <Grid item xs={12}>
            <DataListing 
              wards={wards} 
              intervalSetup={intervalSetup} 
            />
          </Grid>
        </Grid>
      </div>
    );
  }
}

const styles = theme => ({
  root: {
    flexGrow: 1,
    height: '100%',
    zIndex: 1,
    overflow: 'hidden',
    display: 'flex',
  },
  container: {
    // flexGrow: 1,
    // backgroundColor: theme.palette.background.default,
    paddingTop: theme.spacing.unit * 1 + 64,
    paddingLeft: theme.spacing.unit * 5,
    paddingRight: theme.spacing.unit * 5,
    paddingBottom: theme.spacing.unit * 5,
    // minWidth: 0,
    // height: '100%',
  },
  appBar: {
    height: 56,
    paddingTop: 16,
    textAlign: 'center', 
  },
  textField: {
    marginLeft: theme.spacing.unit,
    marginRight: theme.spacing.unit,
    width: 200,
  },
  wardCard: {
    height: 140,
    width: 150,
  },
  intervalCard: {
    height: 50,
    width: 150,
  },
});

export default withStyles(styles, { withTheme: true})(App);
