# Sluis

## What is this?

It’s a small Sinatra application which provides a RESTful API to deploy projects managed with [fastlane](http://www.fastlane.tools).

## How I use it?

### Configure your `fastlane_configuration.yml` file

Add `fastlane_configuration.yml` to you project's fastlane folder (i.e. `{PROJECT_FOLDER}/fastlane`)
The Fastlane configuration file helps you to specify settings for your project which will be available in your `Fastfile`. This might be a perfect place where you define variables that you want to re-use in a `Fastfile` shared
    among all your projects.
    


### Retrieve managed projects

Retrieve a list of supported projects.

#### Output parameters

- __projects__ (Array) A collection of supported projects.

```
# GET /projects/{team_name}

+ Response 200 (application/json)

    + Body

            ["my_awesome_project", "my_awesome_project_again", "my_awesome_project_is_awesome"]
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
