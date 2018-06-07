import React, { Component } from 'react';
import { AppBar, Grid, Button, Typography } from 'material-ui';
import { withStyles } from 'material-ui/styles';

import WardCard from './WardCard';
import IntervalSelection from './IntervalSelection';
import DataListing from './DataListing';

import AddIcon from 'material-ui-icons/Add';

class App extends Component {

  state = {
    wards: [{ward: 14, alderman: "Alex Shneyderman"}, 
            {ward: 35, alderman: "Rick Herman"}],
    intervalSetup: {
      fromYear: 2018,
      fromMonth: null,
      toYear: null,
      toMonth: null
    }
  }
  
  addWard = (ward) => {
    this.setState((prevState) => {
      return { ...prevState, wards: prevState.wards.push(ward) }
    });
  }

  clearWard = (ward) => {
  }

  resetIntervalSetup = (newSetup) => {

  }

  render() {
    let { classes } = this.props;
    let { wards, intervalSetup }   = this.state;
    return (
      <div className={classes.root}>
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
              <Grid key={4} item>
                <Button variant="fab" color="secondary" aria-label="add" className={classes.button}>
                  <AddIcon />
                </Button>
              </Grid>
            </Grid>
          </Grid>
          <Grid item xs={12}>
            <DataListing wards={wards} intervalSetup={intervalSetup} />
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
