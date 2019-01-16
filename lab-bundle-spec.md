# Qwiklabs Lab Bundle Specification

**Version 1**

> This is a DRAFT document. We welcome feedback as this format evolves.

Previously (in b6086b8f824aa398c1f4413b92351a4956e744cd), the robust example had some cool ideas for how deployment manager and activity tracking should look in the future. None of it is implemented yet but the ideas may be useful in the future.

## `qwiklabs.yaml` Structure

Here's a sample `qwiklabs.yaml` file, with all nested details removed to make it easier to see the general file structure.

```yml
entity_type: Lab
schema_version: 1
default_locale: en

title:
  locales:
    en: Best Lab Ever

description:
  locales:
    en: No, seriously. It's the best lab ever. You're going to love it!

duration: 60
level: intro
tags: [sample, life-changing, gcp]

...


# The primary instruction content for this lab
instructions: ...

# Other resources the learner may access while taking this lab
resources: ...

# Lab resources that are provisioned by Qwiklabs
#  e.g. cloud account, databases, etc.
environment_resources: ...

# Checkpoint evaluation and quiz data
assessment: ...
```

Two properties are critical for specifying your lab bundle:

- `entity_type`

  Currently this can only be `Lab` or `CourseTemplate`. In the future we will expand the QLB specification to include `Quiz`, and other content that Qwiklabs supports.

- `schema_version`

  This notes which version of this spec the bundle is using. Currently, the only valid value is `1` but this will change as new features get added.

### Default Locale

The lab bundle MUST specify a `default_locale`. It corresponds to the locale that the lab is originally authored in. Authoring tools can use this as a hint to notify localizers when content in the default locale is updated. Also, it provides a hint to the learner interface about which locale to display if an instruction/resource is not localized for the learner's current locale.

### Lab attributes

attribute   | required | type        | notes
----------- | -------- | ----------- | -----------------------------------------
title       | ✓        | locale dictionary |
description | ✓        | locale dictionary |
duration    | ✓        | integer     | Amount of time it should take an average learner to complete the lab (in minutes)
level       |          | string      |
logo        |          | file path   |
tags        |          | array       |
copyright   |          | string/enum | v2 feature after more research?


### Instructions

attribute | required | type       | notes
--------- | -------- | ---------- | -----------------------------------------
type      | ✓        | enum       | [See list of valid types below]
locales   | ✓        | dictionary | Keys are locale codes, the values are paths to files in the bundle.

```yml
instruction:
  type: html
  locales:
    en: instructions/en.html
    es: instructions/es.html
```

#### Valid types

- `html`
- `pdf`

HTML is the preferred format for stored instructions. PDFs will be displayed embedded in the learner interface, but will lack any navigation or interactive functionality.

##### Qwiklabs supported HTML

There are benefits to formating lab instructions as HTML.

- Instruction styling will be updated automatically as the Qwiklabs interface evolves.
- Qwiklabs will help users navigate within your instruction document with a table of contents or direct links. It will also remember the learner's location in the document if they leave the page.
- Authors can specify interactive elements that will be displayed inline with your instructions in the learner's interface (quizzes, checkpoints, etc).

However, we will not accept arbitrary HTML. Your input will be heavily scrubbed.

- Only a standard subset of HTML elements will be supported (`<h1>`, `<p>`, `<strong>`, etc). All other tags will be stripped out of displayed content.
- All styling will be removed.
- All scripting will be removed.

See the Instruction part of the [HTML spec](./html-spec.md) for details.

### Resources

Resources are additional materials that learners may refer to while taking this lab.

See [Resource Spec](./resource-spec.md) for details.

### Environment Resources

The sandbox learning environment is a key features of Qwiklabs. As the author of a lab, you need to tell us which cloud accounts to provision for a learner, and what resources we should create in that account before handing it over to the learner.

The properties of each environment resource will depend on their type, i.e. AWS Accounts and GSuite Users require different configuration data. However, there are two properties that all resources have regardless of type:


attribute | required | type   | notes
--------- | -------- | ------ | -----------------------------------------
type      | ✓        | enum   | [See list of valid types]
id        |          | string | Identifier that can be used throughout project bundle

```yml
environment_resources:
  - type: gcp_project
    id: my_primary_project
    dm_template:
      script:
        locales:
          en: deployment_manager/instance_pool-en.py
          es: deployment_manager/instance_pool-es.py
  - type: gcp_user
    id: primary_user
    permissions:
      - project: my_primary_project
        roles:
          - roles/editor
            roles/bigquery.admin
  - type: gcp_user
    id: secondary_user
```

#### Valid types

##### GCP Project (gcp-project)

attribute                     | required | type    | notes
----------------------------- | -------- | ------- | --------------------------------------
dm_template.script            |          | path    | A relative path to a Deployment Manager file.
dm_template.custom_properties |          | array   | Array of key/value pairs
fleet                         |          | enum*   | Specify a Qwiklabs fleet to pull the project from.

```yml
- type: gcp-project
  id: secondary_project
  fleet: gcpfree
  dm_template:
    script: deployment_manager/instance_pool.yaml
    custom_properties:
      - key: userNameWindows
        value: student
```

> **NOTE:** Not all GCP fleet names are supported.
>
> The existing concept of Qwiklabs' Fleets does not have a single analog in
> content bundles. Notice that some fleet types map to resource types (e.g.
> `gsuite_multi_tenant` fleet is now the `gsuite-domain` resource type).
> However other fleets are "variants" of the same resource type (e.g.
> "free", "ASL", and "standard" GCP projects). Therefore, not all fleet names that
> an experienced Qwiklabs author may be familiar with, are allowed in the `fleet`
> field.
>
> Presently, authors are allowed to specify one of the following fleet types for
> a gcp-project:
> - gcpd [default]
> - gcpfree
> - gcpasl
>
> Future versions of the Content Bundle spec may use different terminology for
> resource_type variations to avoid conflation.

##### GCP User (gcp-user)

attribute   | required | type       | notes
----------- | -------- | ---------- | ----------------------------------------
credentials |          | boolean    | Should the learner be given credentials for this user
roles       |          | dictionary | Specificy IAM roles per project

```yml
- type: gcp-user
  id: learner_user
  credentials: true
  roles:
    # Reference to a GCP project asset
    my_project:
      - project.editor
    other_project:
      - pubsub.editor
      - storage.admin
```

##### GSuite Domain (gsuite-domain)

attribute   | required | type       | notes
----------- | -------- | ---------- | ----------------------------------------
No additional attributes

```yml
- type: gsuite_domain
  id: primary_domain
```

##### Future Resource Types

- AWS Account (aws-account)
- iPython Notebook (ipython-notebook)

> **NOTE:** A draft of the `aws-account` resource type was previously specified
> in this document. See [previous version](https://github.com/CloudVLab/qwiklabs-content-bundle-spec/blob/93896ced4ae5b543132d7a10d838ac17bd5ae3e1/lab-bundle-spec.md) for details.

### Activity Tracking (Alpha)

Activity tracking is a feature for evaluating a students performance in a lab by running a script at "checkpoints". These scripts can call APIs relavent to any environment resource to query their current state. For example, the script may inspect and validate the configuration of GCE instances running in `my-project`, to ensure the user is following the instructions properly.

Lab bundles will provisionally support the JSON representation of Activity Tracking currently used in the Qwiklabs web interface. The JSON definition should be stored in file separately from (and referenced directly in) `qwiklabs.yaml`.

```yaml
entity_type: Lab

...

activity_tracking: ./assessment/activity_tracking.json
```

> **Note:** Support for this format should be considered deprecated.
>
> Further work will be done to define a new DSL for expressing Activity Tracking logic. Exploratory sketches of this DSL can be found in the `./examples` directory of this repository.
