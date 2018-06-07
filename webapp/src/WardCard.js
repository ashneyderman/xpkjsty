import React, { Component } from 'react';
import { Button, Card, CardContent, Typography, CardActions } from 'material-ui';
import { withStyles } from 'material-ui/styles';

class WardCard extends Component {
  render() {
    let { classes, ward, clearHandler } = this.props;
    return (
      <div>
        <Card className={classes.card}>
          <CardContent>
            <Typography className={classes.title} color="primary">
              Ward #{ward.ward}
            </Typography>
            <Typography color="textSecondary">
              {ward.alderman}
            </Typography>
          </CardContent>
          <CardActions>
            <Button size="small" onClick={clearHandler}>Clear</Button>
          </CardActions>
        </Card>
      </div>
    );
  }
}

const styles = theme => ({
  card: {
    width: 180,
    maxWidth: 180,
  },
  title: {
    marginBottom: 16,
    fontSize: 14,
  },
});

export default withStyles(styles)(WardCard);
