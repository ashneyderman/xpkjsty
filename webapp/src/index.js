import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
import { ApolloClient } from 'apollo-client';
import { InMemoryCache } from 'apollo-cache-inmemory';
import { ApolloLink } from 'apollo-link';
import { HttpLink } from 'apollo-link-http';
import { ApolloProvider } from 'react-apollo';

import { MuiThemeProvider, createMuiTheme } from 'material-ui/styles';
import primary from 'material-ui/colors/blue';
import secondary from 'material-ui/colors/purple';
import 'typeface-roboto';

const uri = 'https://tcbchalapi.kocomojo.net/api';
const cache = new InMemoryCache();
const client = new ApolloClient({cache, link: ApolloLink.from([new HttpLink({uri})])});

const theme = createMuiTheme({
  palette: {
    primary: primary,
    secondary: secondary,
  }
});

ReactDOM.render(
  <ApolloProvider client={client}>
    <MuiThemeProvider theme={theme}>
      <App />
    </MuiThemeProvider>
  </ApolloProvider>, 
  document.getElementById('root'));
