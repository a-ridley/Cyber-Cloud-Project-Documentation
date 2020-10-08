'use strict';
const fetch = require("node-fetch");
const express = require('express');

// Constants
const OS_AUTH_URL="http://192.168.128.18:5000/v3"
const OS_COMPUTE_API="http://192.168.128.18:8774/v2.1"
const OS_USERNAME="admin"
const OS_PASSWORD="<REPLACE_THIS_WITH_PASSWORD>"
const OS_USER_DOMAIN_NAME="default"
const OS_PROJECT_DOMAIN_NAME="default"
const OS_PROJECT_NAME="admin"
const PORT = 8069;
const HOST = '0.0.0.0';

// App
const app = express();
app.get('/hostname', async (req, res) => {
    const ip = req.query.ip;
    if(ip) {
      authenticate().then(token => {
        listServers(token).then(servers => {
          const matches = servers.filter(server => {
            for(const network in server.addresses) {
              for(const connection of server.addresses[network]) {
                var address = connection.addr;
                if(address === ip) {
                  return true;
                }
              }
            }
            return false;
          })
          console.log('found matches', JSON.stringify(matches, null, 2));
          res.send(matches[0].name);
        }) 
      });
    } else {
      res.send("an ip must be specified");
    }
})

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);

function listServers(token) {
  return fetch(`${OS_COMPUTE_API}/servers/detail?all_tenants=true`, {
    method: 'GET',
    headers: {
      'X-Auth-Token': token,
    }
  })
  .then(s => s.json())
  .then(s => {
    console.log('servers found', s)
    return s.servers;
  }).catch(e => {
    console.log('unable to fetch servers', e);
    return []
  })
}

function authenticate() {
  const auth_payload = `{ "auth": { "identity": { "methods": ["password"],"password": {"user": {"domain": {"name": "${OS_USER_DOMAIN_NAME}"},"name": "${OS_USERNAME}", "password": "${OS_PASSWORD}"} } }, "scope": { "project": { "domain": { "name": "${OS_PROJECT_DOMAIN_NAME}" }, "name":  "${OS_PROJECT_NAME}" } } }}`;
  return fetch(OS_AUTH_URL + "/auth/tokens?nocatalog", {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: auth_payload
  })
  .then(response => {
    const token = JSON.stringify(response.headers.get('X-Subject-Token'));
    console.log('received token', token);
    return token;
  })
  .catch(e => {
    console.log(e)
  });
}
