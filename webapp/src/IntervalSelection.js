import React, { Component } from 'react';
import { Card, CardContent, CardActions, 
         Typography, FormGroup, FormHelperText, Button } from 'material-ui';
import { withStyles } from 'material-ui/styles';
import MonthSelction from './MonthSelection';
import YearSelection from './YearSelection';

class IntervalSelection extends Component {
  render() {
    let { classes } = this.props;
    return (
      <div>
        <Card className={classes.card}>
          <CardContent>
            <Typography className={classes.title} color="primary">
              Report Interval
            </Typography>
            <FormHelperText>From:</FormHelperText>  
            <FormGroup row>
              <YearSelection startYear={2010} /><MonthSelction />
            </FormGroup>
            <FormHelperText>To:</FormHelperText>
            <FormGroup row>                            
              <YearSelection startYear={2010} /><MonthSelction />
            </FormGroup>
          </CardContent>
          <CardActions>
            <Button size="small">Reset</Button>
          </CardActions>
        </Card>
      </div>
    );
  }
}

const styles = theme => ({
  card: {
    width: 280,
    // maxWidth: 3,
  },
  title: {
    marginBottom: 16,
    fontSize: 14,
  },
});

export default withStyles(styles)(IntervalSelection);
