---
title: 'Discover Microsoft Graph Toolkit Components'
author: 'Part 2 of 4 in the [Develop JavaScript Applications with the Microsoft Identity Platform](https://github.com/msusdev) series'
---

# Discover Microsoft Graph Toolkit Components

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
  * ~~Authenticating users in JavaScript apps with MSAL.js~~
* **Session 2:**
  * **↪️ Discover Microsoft Graph Toolkit Components**
* Session 3:
  * Authenticating to Azure with MSAL.js
* Session 4:
  * The Microsoft Graph SDK for JavaScript

### Today's agenda

1. Microsoft Graph
1. Microsoft Graph Toolkit
1. Using the toolkit with Vanilla 
1. Using the toolkit with React

## Demo: *Getting Started with the Microsoft Graph Toolkit*

::: notes

### Graph Person Template

```html
<mgt-person id="target" view="twoLines">
</mgt-person>
```

```js
const person = document.querySelector('#target');

person.personDetails = {
    displayName: 'Webinar Presenter',
    mail: 'msusdev@microsoft.com'
};

person.personImage = 'https://raw.githubusercontent.com/msusdev/media-assets/main/squirrel.png';
```

### Graph Get Template

```html
<mgt-get resource="me/photo/$value" type="image">
    <template>
        <img src="{{image}}" />
    </template>
</mgt-get>
```

```css
img {
    border-style: solid;
    border-color: black;
    border-width: 5px;
    border-radius: 35%;
    box-shadow: 10px 10px 10px rgba(0, 0, 0, 0.5);
}
```

### Graph Tasks Template

```html
<mgt-tasks read-only>
    <template data-type="task">
        {{this}}
    </template>
</mgt-tasks>
```

```html
<mgt-tasks read-only>
    <template data-type="task">
        <h1>{{task.title}}</h1>
        <p>
            {{task.groupTitle}} | <strong>{{task.folderTitle}}</strong>
        </p>
    </template>
</mgt-tasks>
```

```html
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KyZXEAg3QhqLMpG8r+8fhAXLRk2vvoC2f3B09zVXn8CA5QIVfZOJ3BCsw2P0p/We" crossorigin="anonymous">

<mgt-tasks read-only>
    <template data-type="task">
        <div class="card my-2">
            <div class="card-header">
                {{task.groupTitle}}
            </div>
            <div class="card-body">
                <h5 class="card-title">{{task.title}}</h5>
                <p class="card-text">{{task.folderTitle}}</p>
            </div>
        </div>
    </template>
</mgt-tasks>
```

### Vanilla Graph Toolkit

```html
<script src="https://unpkg.com/@microsoft/mgt/dist/bundle/mgt-loader.js"></script>

<mgt-msal2-provider client-id="<client-id>"></mgt-msal2-provider>
<mgt-login></mgt-login>
<section class="list-group">
    <mgt-todo read-only>
        <template data-type="task">
            <label class="list-group-item">
              <input class="form-check-input me-1" type="checkbox" value="">
              {{task.title}}
            </label>
        </template>
    </mgt-todo>
</section>
```

##### React Graph Toolkit

```bash
npx create-react-app . --template typescript --use-npm

npm i @microsoft/mgt-react
npm i @microsoft/mgt-element @microsoft/mgt-msal2-provider

npm start
```

```typescript
import { Providers } from '@microsoft/mgt-element';
import { Msal2Provider } from '@microsoft/mgt-msal2-provider';

Providers.globalProvider = new Msal2Provider({
  clientId: '<client-id>',
  scopes: ['calendars.read', 'user.read']
});

```

```typescript
import { Login, Agenda, Person, PersonViewType } from '@microsoft/mgt-react';

const view = PersonViewType.threelines;

function App() {
  return (
    <main className="App">
      <Login />
      <hr />
      <Person personQuery="me" view={view} />
      <hr />
      <Agenda />
    </main>
  );
}
```

```typescript
import { Login, Agenda, Person, PersonViewType, Todo, MgtTemplateProps } from '@microsoft/mgt-react';

const view = PersonViewType.threelines;

const ItemTemplate = (props: MgtTemplateProps) => {
  const { task } = props.dataContext;
  return (
    <span>{JSON.stringify(task)}</span>
  );
};

function App() {
  return (
    <main className="App">
      <Login />
      <hr />
      <Person personQuery="me" view={view} />
      <hr />
      <Agenda />
      <Todo>
        <ItemTemplate template="task" />
      </Todo>
    </main>
  );
}
```

```typescript
import { Login, Todo, MgtTemplateProps } from '@microsoft/mgt-react';

const ItemTemplate = (props: MgtTemplateProps) => {
  const { task } = props.dataContext;
  return (
    <label className="list-group-item">
      <input className="form-check-input me-1" type="checkbox" value="" />
      {task.title}
    </label>
  );
};

function App() {
  return (
    <main className="App">
      <Login />
      <Todo readOnly>
        <ItemTemplate template="task" />
      </Todo>
    </main>
  );
}
```

:::
