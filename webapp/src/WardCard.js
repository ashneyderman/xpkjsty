import React, { Component } from 'react';
import { Button, Card, CardContent, Typography, CardActions } from 'material-ui';
import { withStyles } from 'material-ui/styles';

import { Query } from 'react-apollo';
import gql from 'graphql-tag';

const FETCH_WARD_BY_ID = gql`
query FetchWard($wardId: ID){
  fetchWard(ward:$wardId){
    ward
    alderman
  }
}`;

class WardCard extends Component {
  render() {
    let { classes, ward, clearHandler } = this.props;
    return (
      <div>
        <Query
          query={FETCH_WARD_BY_ID}
          variables={{
            wardId: ward
          }}>
          {({loading, error, data}) => {
            if (loading) { 
              return (
                <Card className={classes.card}>
                  <CardContent>
                    <Typography className={classes.title} color="primary">
                      Data for ward #{ward} is being loaded ...
                    </Typography>
                  </CardContent>
                </Card>
              ); 
            }
            if (error) { 
              return (
                <Card className={classes.card}>
                  <CardContent>
                    <Typography className={classes.title} color="primary">
                      Error loading data for ward #{ward}: {error}
                    </Typography>
                  </CardContent>
                </Card>
              ); 
            }

            return (
              <Card className={classes.card}>
                <CardContent>
                  <Typography className={classes.title} color="primary">
                    Ward #{data.fetchWard.ward}
                  </Typography>
                  <Typography color="textSecondary">
                    {data.fetchWard.alderman}
                  </Typography>
                </CardContent>
                <CardActions>
                  <Button size="small" onClick={() => { clearHandler(ward) }}>Remove</Button>
                </CardActions>
              </Card>
            );
          }}
        </Query>
      </div>
    );
  }
}

const styles = theme => ({
  card: {
    width: 200,
    maxWidth: 200,
  },
  title: {
    marginBottom: 16,
    fontSize: 14,
  },
});

export default withStyles(styles)(WardCard);
