# Sluis

## What is this?

It’s a small Sinatra application which provides a RESTful API to deploy projects managed with [fastlane](http://www.fastlane.tools).

## How I use it?

Sluis provides automated project deployment *only* for projects that supports sluis integration.
Any attempt to deploy projects which are not supported will immediatelly fail. 

### Retrieve managed projects

Retrieve a list of supported projects.

#### Output parameters

- __projects__ (Array) A collection of supported projects.

```
# GET /projects/{team_name}

+ Response 200 (application/json)

    + Body

            ["weeronline-universal", "brandbite-ios", "ING Creditview"]
```

### Deploy a managed project

Takes a JSON body which contains the name of lane used by `fastlane` when deploying

#### Input parameters

- __lane__ (string, required) The name of the lane used by *fastlane*

```
# PUT /projects/{team_name}/{project_name}

+ Request

        {"lane":"development"}

+ Response 204

```