---
title: 'Authenticating users in .NET apps with MSAL.NET'
author: 'Part 1 of 4 in the [Develop .NET Applications with the Microsoft Identity Platform](https://github.com/msusdev) series'
---

# Welcome

## Overview

### About us

Sidney Andrews

☁️ *Azure MVP, Microsoft Certified Trainer*

> For questions or help with this series: <MSUSDev@Microsoft.com>

All demos and source code available online:

> <https://github.com/MSUSDEV/microsoft_identity_platform_dev>

## Setting the scene

### Series roadmap

* Session 1:
  * **↪️ Authenticating users in JavaScript apps with MSAL.NET**
* Session 2:
  * Bring identity components to apps with the Microsoft Graph Toolkit
* Session 3:
  * Authenticating to Azure services with Azure AD and MSAL.NET
* Session 4:
  * Getting Started with the Microsoft Graph SDK from your .NET apps

### Today's agenda

1. What is the Microsoft Identity Platform?
1. How do we authenticate manually?
1. How can the MSAL help us authenticate?
1. Where can we use the MSAL token?

## Identity Development with the Microsoft Identity Platform

### Goal

![ ](diagrams/process.svg)

### Identity as a control plane

![ ](diagrams/controlplane.svg)

### Azure Active Directory

![ ](diagrams/aad.svg)

### Active Directory Authentication Library

![ ](diagrams/aadendpoint.svg)

### Microsoft Identity Platform

**<https://docs.microsoft.com/azure/active-directory/develop/>**

> Unified full-stack development tools to work with *all Microsoft identities*.

### Microsoft Identity Platform Breakdown

![ ](diagrams/mipendpoint.svg)

## Demo: *Microsoft Identity Platform documentation*

::: notes

1. Open a browser and navigate to <https://docs.microsoft.com/en-us/azure/active-directory/develop/>

1. Review the various sections of the landing page

1. In the **About Microsoft identity platform** section, within the **Overview** sub-sectoin, selet **Microsoft identity plateform (v2.0)**

1. Review the documentation on this page

:::

## Authenticating to Microsoft

### AAD Applications

* Register applications with AAD to get access to authentication and tokens
* Usually include a redirect URI for the application
* Registration will yield client credentials required to authenticate
* Can register different types of applications

### Application Types

* Single-page applications
* Web applications
* Web APIs
* Desktop/Mobile applications
* Server-side applications

## Demo: *Registering an application in Azure AD*

::: notes

1. Open a browser and navigate to <https://portal.azure.com>

1. Navigate to **Azure Active Directory**

1. Navigate to **App registrations**

1. Create a new registration using the following settings:

    * Name: **Example**

    * Supported account types: **Accounts in any organization dirctory (Any Azure AD directory - Multitenant)**

    * Redirect URI: **Public client/native (mobile & desktop) - <http://localhost>**

1. In the new registration, navigate to the **API permissions** section

1. Observe the built-in **Microsoft Graph** permission for **User.Read**

:::

### Authentication flows

| Flow | Description |
| --- | --- |
| Authorization code | Native and web apps securely obtain tokens in the name of the user |
| Client credentials | Service applications run without user interaction |
| On-behalf-of | The application calls a service/web API, which in turns calls Microsoft Graph |
| Implicit | Used in browser-based applications |
| Device code | Enables sign-in to a device by using another device that has a browser |
| Integrated Windows | Windows computers silently acquire an access token when they are domain joined |
| Interactive | Mobile and desktops applications call Microsoft Graph in the name of a user |
| Username/password | The application signs in a user by using their username and password | |

### Interactive authentication flow

![ ](diagrams/interactiveflow.svg)

::: notes

1. The application redirects the user to the Azure AD sign-in portal, and the user acquires a token interactively from Azure AD

1. The application uses the token to access Microsoft Graph

:::

### Device code flow

![ ](diagrams/devicecodeflow.svg)

::: notes

1. The application requests a unique device code from Azure AD

1. The user uses another workstation along with the device code to sign in to the Azure AD sign-in portal

1. The original application acquires a token from Azure AD based on the user sign-in

1. The application uses the token to access Microsoft Graph

:::

### Login URL

* One base URL for all login and token queries:
  * <https://login.microsoftonline.com/tenant_id/oauth2/v2.0>
* Relative URLs for specific actions:
  * **login**: \/authorize
  * **acquire token**: \/token

### Tenants

* <https://login.microsoftonline.com/tenant_id/oauth2/v2.0>
  * Unique **Tenant Id** for just your organization
  * ``organizations``: Any organizational (work/school) account
  * ``consumers``: Any Microsoft account
  * ``common``: Any account

::: notes

The different values influence the in-browser user experience when logging in. For example; if you specify the tenant id, then the user will immediately see your organization's branding.

:::

### Authorize with Azure AD using OAuth 2.0

1. Navigate to the **\/authorize** endpoint for **login.microsoftonline.com**
    1. Provide appropriate query string parameters
        * ``client_id``: Unique **Client Id** for application registration
        * ``response_type``: Set to ``code``
        * ``redirect_uri``: One of the **Redirect Uri**s specified in application registration process
        * ``scope``: List of permissions that you are requesting consent to
        * ``response_mode``: Either ``form_post`` or ``query``
        * *(Optional)* ``state``: Sanity-check value
1. Login using your browser
1. Observe the response
    1. If ``response_mode=query``, will include a unique code on the query string
        * Use this code to acquire a token
    1. (Optional) Echoes the state parameter

### Authorize Query String and URI Parameters

| Parameter | Description |
| --- | --- |
| ``client_id`` | AAD application unique identifier |
| ``response_type`` | Usually ``code`` |
| ``redirect_uri`` | Where to go after authentication |
| ``response_mode`` | Usually ``query`` but can be ``form_post`` |
| ``scope`` | What permissions are required |
| ``state`` (optional) | Value that can be used to validate response |

### Example Authorization Request

```sh
GET https://login.microsoftonline.com/organizations/oauth2/v2.0/authorize?
    client_id=06b9debd-a372-496f-916c-856dc9dd1f8a
    &response_type=code
    &redirect_uri=http%3A%2F%2Flocalhost%2F
    &response_mode=query
    &scope=user.read
    &state=demo
```

### Example Authorization Response

```sh
GET http://localhost?
    code=6a3095c1-48ca-4d00-939e-eca0e5b8f1a4
    &state=demo
```

### Acquire a Bearer Token using OAuth 2.0

1. Send a **POST** request to the **\/token** endpoint for **login.microsoftonline.com**
    1. Provide appropriate form parameters
        * ``client_id``: Unique **Client Id** for application registration
        * ``redirect_uri``: One of the **Redirect Uri**s specified in application registration process
        * ``scope``: List of permissions that you are requesting consent to
        * ``code``: Use the value of the **code** from the authorization request
        * ``grant_type``: Use ``authorization_code``
1. Observe the response
    1. The ``access_token`` property has your OAuth 2.0 Bearer token

### Token Query String and URI Parameters

| Parameter | Description |
| --- | --- |
| ``client_id`` | AAD application unique identifier |
| ``code`` | Code from previous request |
| ``grant_type`` | ``authorization_code`` |
| ``redirect_uri`` | Where to go after authentication |
| ``scope`` | What permissions are required |

### Example Token Request

```sh
POST https://login.microsoftonline.com/organizations/oauth2/v2.0/token?
    client_id=06b9debd-a372-496f-916c-856dc9dd1f8a
    &redirect_uri=http%3A%2F%2Flocalhost%2F
    &grant_type=authorization_code
    &code=OAAABAAAAiL9Kn2Z27UubvWFPbm0gLWQJVzCTE9UkP3pSx1aXxUjq3n8b2JRLk4OxVXr...
```

::: notes

The ``code`` value has been concatenated for brevity.

:::

### Example Token Response

```js
{
    "token_type": "Bearer",
    "scope": "user.read",
    "expires_in": 3600,
    "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Ik5HVEZ2ZEstZnl0aEV1Q...",
    "refresh_token": "AwABAAAAvPM1KaPlrEqdFSBzjqfTGAMxZGUTdM0t4B4..."
}
```

::: notes

The ``access_token`` and ``refresh_token`` values have been concatenated for brevity.

:::

## Demo: *Manually acquiring a token from Microsoft*

::: notes

1. Open a browser and navigate to <https://portal.azure.com>

1. Navigate to **Azure Active Directory**

1. Native to your recently created application registration

1. Record the value of the **Client Id** field

1. Build a URL using the following steps:

    1. Start with ``https://login.microsoftonline.com/common/oauth2/v2.0/authorize``

    1. Add the ``client_id=`` query string value with your unique **Client Id** from the application registration

    1. Add the ``&redirect_uri=http%3A%2F%2Flocalhost%2F`` query string parameter

    1. Add the ``&scope=user.read`` query string parameter

    1. Add the ``&response_type=code`` query string parameter

    1. Add the ``&response_mode=query`` query string parameter

1. Open a browser and navigate to the URL that you just built

1. Login using any organizational (work/school) account

1. Consent to the application's request to view your user profile information (``user.read``)

1. Azure AD will redirect to localhost which should return a HTTP 404 error

1. Record the value of the redirect URL that is in the browser address bar

1. Record the value of the ``code`` query string parameter in the response

1. Open a HTTP request tool

    * *Note: It is recommended to use [Postman](https://www.postman.com/) to demo the HTTP POST request*

1. Build a HTTP **POST** request using the endpoint ``https://login.microsoftonline.com/common/oauth2/v2.0/token`` and following these steps:

    1. Add a ``client_id`` parameter with your unique **Client Id** from the application registration

    1. Add a ``code`` parameter with the **code** you recorded earlier in this lab

    1. Add a ``redirect_uri`` parameter with a value of ``http://localhost``

    1. Add a ``scope`` parameter with a value of ``user.read``

    1. Add a ``grant_type`` parameter with a value of ``authorization_code``

    1. Issue the HTTP POST request

1. Observe the JSON response of the request, it should contain an ``access_token`` property with your MSAL token

1. Build a HTTP **GET** request using the endpoint ``https://graph.microsoft.com/beta/me`` and following these steps:

    1. Add an **OAuth 2.0** bearer token header using your **Access Token** created earlier.

    1. Issue the HTTP GET request

1. Observe the result of the request

:::

## Microsoft Authentication Library (MSAL)

### MSAL SDK

**<https://docs.microsoft.com/azure/active-directory/develop/msal-overview>**

* Consistent single library for authentication with *all Microsoft identities*
* Can be used to access:
  * Microsoft Graph
  * other Microsoft APIs
  * third-party Web APIs
  * your own APIs
* Available in various programming languages and platforms:
  * .NET
  * JavaScript
  * Python
  * Java
  * Android/iOS

### NuGet

* Available on NuGet
  * **[Microsoft.Identity.Client](https://www.nuget.org/packages/Microsoft.Identity.Client/)**

### Provider model

* **Public client applications**
  * Applications always sign-in users
  * Uses the MSAL ``PublicClientApplication`` class
  * Examples:
    * Desktop apps calling web APIs on behalf of the signed-in user
    * Mobile apps
    * Apps running on devices that don't have a browser, like those running on iOT
* **Confidential client applications**
  * Applications may sign-in automatically
  * Uses the MSAL ``ConfidentialClientApplication`` class
  * Examples:
    * Web apps calling a web API
    * Web APIs calling a web API
    * Daemon apps, even when implemented as a console service like a Linux daemon or a Windows service

### Builder model

```csharp
var clientApp = PublicClientApplicationBuilder.Create(client_id)
    .Build();
```

### Authority modifier

```csharp
var clientApp = PublicClientApplicationBuilder.Create(client_id)
    .WithAuthority(AzureCloudInstance.AzurePublic, tenant_id)
    .Build();
```

### Redirect URI modifier

```csharp
var clientApp = PublicClientApplicationBuilder.Create(client_id)
    .WithAuthority(AzureCloudInstance.AzurePublic, tenant_id)
    .WithRedirectUri("http://localhost")
    .Build();
```

### Acquring a token interactively

```csharp
string[] scopes = { "user.read" };

var authResult = await clientApp
    .AcquireTokenInteractive(scopes)
    .ExecuteAsync();

string token = authResult.AccessToken;
```

## Demo: *Interactive authentication using MSAL.NET*

::: notes

1. Open a browser and navigate to <https://portal.azure.com>

1. Navigate to **Azure Active Directory**

1. Native to your recently created application registration

1. Record the value of the **Client Id** field

1. Open **Visual Studio Code**

1. Using a terminal, create a new .NET project named **MsalDemo**:

    ```sh
    dotnet new console --name MsalDemo --output .
    ```

1. Import the **Microsoft.Identity.Client** package from NuGet:

    ```sh
    dotnet add package Microsoft.Identity.Client
    ```

1. Open the **Program.cs** file

1. Add the following using statements:

    ```csharp
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Microsoft.Identity.Client;
    ```

1. Update the **Main** method to be an asynchronous entry point:

    ```csharp
    static async Task Main(string[] args)
    ```

1. Within the **Main** method, add the following code:

    ```csharp
    string clientId = "<client-id>";
    var app = PublicClientApplicationBuilder
        .Create(clientId)
        .WithAuthority("https://login.microsoftonline.com/common")
        .WithRedirectUri("http://localhost")
        .Build();
    List<string> scopes = new List<string> 
    { 
        "user.read" 
    };
    var result = await app.AcquireTokenInteractive(scopes)
        .ExecuteAsync();
    Console.WriteLine(result.AccessToken);
    ```

1. Using a terminal, build and run the application:

    ```sh
    dotnet run
    ```

1. Observe the updated messages in the console

1. Return to **Visual Studio Code** and run the following command in the terminal to import the **Flurl.Http** package:

    ```sh
    dotnet add package Flurl.Http
    ```

1. Return to the **Program.cs** file and add the following using statements:

    ```csharp
    using Flurl.Http;
    ```

1. Within the **Main** method, add the following code:


    ```csharp
    string json = await "https://graph.microsoft.com/beta/me"
        .WithOAuthBearerToken(result.AccessToken)
        .GetStringAsync();
    Console.WriteLine(json);
    ```

1. Using a terminal, build and run the application:

    ```sh
    dotnet run
    ```

1. Observe the updated messages in the console

:::