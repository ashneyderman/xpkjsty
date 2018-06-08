import React, { Component } from 'react';
import { Card, CardContent, CardActions, 
         Typography, FormGroup, FormHelperText, Button } from 'material-ui';
import { withStyles } from 'material-ui/styles';
import MonthSelction from './MonthSelection';
import YearSelection from './YearSelection';
import moment from 'moment';
import { SnackbarContext } from './SnackbarProvider';

class IntervalSelection extends Component {

  constructor(props) {
    super(props);
    this.state = { ...props.intervalSetup };
  }

  validCombination = (prospectiveState) => {
    let { fromYear, fromMonth, toYear, toMonth } = prospectiveState;

    if (!fromYear) { return "From year is a required parameter"; }

    fromMonth = fromMonth || 1;
    toYear    = toYear || fromYear;
    toMonth   = toMonth || 12;

    let fromDate = moment(`${fromYear}-${fromMonth}`, "YYYY-M", true);
    let toDate   = moment(`${toYear}-${toMonth}`, "YYYY-M", true);
    if(fromDate.isValid() && toDate.isValid()) {
      if (fromDate.isBefore(toDate)) {
        return null;
      } else {
        return "Please make sure from comes before the to.";
      }
    } else {
      return "Either from or the to combination of month and year is invalid.";
    }
  }

  onChange = (field, event, displayError) => {
    let prospectiveState = { ...this.state, [field]: event.target.value === "" ? null : event.target.value }
    let invalidMessage = this.validCombination(prospectiveState);
    if(invalidMessage == null) {
      this.setState(prospectiveState);
      this.props.onChange(prospectiveState);
    } else {
      displayError(invalidMessage);
    }
  }

  onReset = () => {
    const initialValue = { 
      fromYear: new Date().getFullYear(),
      fromMonth: null,
      toYear: null,
      toMonth: null 
    };

    this.props.onChange(initialValue);
    this.setState(initialValue);
  }

  render() {
    let { classes } = this.props;
    let { fromYear, fromMonth, toYear, toMonth } = this.state;
    return (
      <SnackbarContext.Consumer>
      {(displayError) => {
        return (
          <div>
          <Card className={classes.card}>
            <CardContent>
              <Typography className={classes.title} color="primary">
                Report Interval
              </Typography>
              <FormHelperText>From:</FormHelperText>  
              <FormGroup row>
                <YearSelection 
                  startYear={2010}
                  value={fromYear}
                  onChange={(event) => { this.onChange('fromYear', event, displayError); }}
                />
                <MonthSelction
                  value={fromMonth} 
                  onChange={(event) => { this.onChange('fromMonth', event, displayError); }}
                />
              </FormGroup>
              <FormHelperText>To:</FormHelperText>
              <FormGroup row>                            
                <YearSelection 
                  startYear={2010}
                  value={toYear} 
                  onChange={(event) => { this.onChange('toYear', event, displayError); }}
                />
                <MonthSelction 
                  value={toMonth}
                  onChange={(event) => { this.onChange('toMonth', event, displayError); }}
                />
              </FormGroup>
            </CardContent>
            <CardActions>
              <Button size="small" onClick={this.onReset}>Reset</Button>
            </CardActions>
          </Card>
        </div>
        )
      }}
      </SnackbarContext.Consumer>
    );
  }
}

const styles = theme => ({
  card: {
    width: 280,
  },
  title: {
    marginBottom: 16,
    fontSize: 14,
  },
});

export default withStyles(styles)(IntervalSelection);
