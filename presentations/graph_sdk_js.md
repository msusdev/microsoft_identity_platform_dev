---
title: 'The Microsoft Graph SDK for JavaScript'
author: 'Part 4 of 4 in the [Develop JavaScript Applications with the Microsoft Identity Platform](https://github.com/msusdev) series'
---

# The Microsoft Graph SDK for JavaScript

## Overview

### About us

Co-Presenter Name

☁️ *Co-Presenter Title*

Co-Presenter Name

☁️ *Co-Presenter Title*

> For questions or help with this series: <MSUSDev@Microsoft.com>

All demos and source code available online:

> <https://github.com/MSUSDEV/microsoft_identity_platform_dev>

## Setting the scene

### Series roadmap

* ~~Session 1:~~
  * ~~Authenticating users in JavaScript apps with MSAL.javascript~~
* ~~Session 2:~~
  * ~~Discover Microsoft Graph Toolkit Components~~
* ~~Session 3:~~
  * ~~Authenticating to Azure with MSAL.javascript~~
* **Session 4:**
  * **↪️ The Microsoft Graph SDK for JavaScript**

### Today's agenda

1. Item

## Demo: *Accessing Azure resource using MSAL.javascript and a Node.javascript server-side app*

::: notes

1. Open **Visual Studio Code** in an empty folder

1. Run ``git clone https://github.com/msusdev/example-static-javascript-app.git .`` to clone the sample Node.javascript web application

1. Run ``npm install`` to install the Node.javascript dependencies

1. Switch to the **example** branch

1. Fill-in the missing **client-id** and **tenant-id** fields in the **index.javascript** file.

1. Run ``npm start`` to start the web server and observe the server URL

1. Observe the working application

:::

::: notes

```html
<script src="https://unpkg.com/@microsoft/microsoft-graph-client@3.0.0/lib/graph-javascript-sdk.javascript" crossorigin></script>
<script src="https://unpkg.com/@microsoft/microsoft-graph-client@3.0.0/lib/graph-client-msalBrowserAuthProvider.javascript" crossorigin></script>
```

```javascript 
const options = {
    authProvider: new MSGraphAuthCodeMSALBrowserAuthProvider.AuthCodeMSALBrowserAuthenticationProvider(client, {
        account: {},
        scopes: ['user.read'],
        interactionType: msal.InteractionType.Popup,
    })
};
```

```javascript
var graphClient = MicrosoftGraph.Client.initWithMiddleware(options);
```

```javascript
let profile = await graphClient.api('/me').get();
console.dir(profile);
```

```javascript
scopes: ['user.read', 'tasks.readwrite'],
```

```javascript
let taskLists = await graphClient.api('/me/todo/lists').get();
console.dir(taskLists);
```

```javascript
var list = {
    displayName: 'demo'
};
let taskLists = await graphClient.api('/me/todo/lists').post(list);
console.dir(taskLists);
```

```javascript
var list = {
    displayName: 'demo'
};
let taskLists = await graphClient.api('/me/todo/lists/<list-id>/tasks').post(list);
console.dir(taskLists);
```

```javascript
var list = {
    title: 'This is fun!'
};
var listId = '<list-id>';
let taskLists = await graphClient.api('/me/todo/lists/' + listId + '/tasks').post(list);
console.dir(taskLists);
```

:::

::: notes

```json
{
  "name": "servernodegraph",
  "main": "app.js",
  "type": "module",
  "scripts": {
    "start": "node app.js"
  }
}
```

```bash
npm install @azure/identity --save
npm install @microsoft/microsoft-graph-client --save
```

```javascript
import { ClientSecretCredential } from '@azure/identity';
import { Client, TokenCredentialAuthenticationProvider } from "@microsoft/microsoft-graph-client";
```

```javascript
const credential = new ClientSecretCredential('<tenant-id>', '<client-id>', '<client-secret>');
```

```javascript

```

```javascript

```

:::
