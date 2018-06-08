import React, {Component} from 'react';
import { Snackbar } from 'material-ui';

export const SnackbarContext = React.createContext(null);

export class SnackbarProvider extends Component {
  state = {
    open: false,
    error: null
  }

  displayError = (error) => {
    this.setState({ open: true, error });
  }

  handleClose = () => {
    this.setState({ open: false, message: null });
  }

  render() {
    const { open, error } = this.state;
    let spanEl = (
      <span id="message-id">{error}</span>
    );
    return (
      <div>
        <Snackbar
          open={open}
          onClose={this.handleClose}
          ContentProps={{
            'aria-describedby': 'message-id',
          }}
          message={spanEl}
        />
        <SnackbarContext.Provider value={this.displayError}>
          {this.props.children}
        </SnackbarContext.Provider>
      </div>
    )
  }
}
