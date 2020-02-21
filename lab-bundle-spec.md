# Qwiklabs Lab Bundle Specification

**Version 2**

> This is a DRAFT document. We welcome feedback as this format evolves.

Previously (in b6086b8f824aa398c1f4413b92351a4956e744cd), the robust example had some cool ideas for how deployment manager and activity tracking should look in the future. None of it is implemented yet but the ideas may be useful in the future.

## Changelog

The primary changes made from v1 to v2 are:

- Adding `environment` as a top level property with two children:
  - `resources` matches the usage of `environment_resources` in v1
  - `student_visible_outputs` specifies which properties of those resources should be provided to the student (e.g. only display the username and password for the `primary_user` instead of every `gcp_user` created by the lab). See the [Student Visible Outputs section](#student-visible-outputs) for details.

- Renaming the `fleet` attribute on the `gcp_project` resource type to `variant`, and allowing for `variant` to be specified on other resource types.

- Replacing the `dm_template` attribute on the `gcp_project` resource type with a `startup_script` and `cleanup_script`.

- Allowing `custom_properties` to include a `reference` (rather than `value`) that can be filled in from running resources.

- Adding an `ssh_key_user` attribute on the `gcp_project` resource type.

## Concepts

### Resource References

Sometimes it is useful to reference values that are unknown at authoring time. For example, an author may specify that a GCP Project username should be displayed to the student, but this username is not known until the lab is started. To address this, we have the concept of resource references.

A resource reference has the form `[RESOURCE_ID].[RESOURCE_ATTRIBUTE]`. Each environment resource type has an allowed set of attributes that can be referenced, defined in its "Valid resource references" section. When an attribute has type "resource reference", the value should be of this form.

Currently, this can only be used for `student_visible_outputs` and `custom_properties` (of startup/cleanup scripts). In the future, we hope to allow interpolating these resource references into the lab instructions.

## `qwiklabs.yaml` Structure

Here's a sample `qwiklabs.yaml` file, with all nested details removed to make it easier to see the general file structure.

```yml
entity_type: Lab
schema_version: 2
default_locale: en

title:
  locales:
    en: Best Lab Ever

description:
  locales:
    en: "No, seriously. It's the best lab ever. You're going to love it!"

duration: 60
level: intro
tags: [sample, life-changing, gcp]

# The primary instruction content for this lab
instruction: ...

# Other resources the learner may access while taking this lab
resources: ...

environment:
  # Lab resources that are provisioned by Qwiklabs
  #  e.g. cloud account, databases, etc.
  resources: ...

  # Properties of the lab environment that are displayed to the user
  #  e.g. gcp project, username, password. etc.
  student_visible_outputs: ...


# Checkpoint evaluation and quiz data
assessment: ...
```

Two properties are critical for specifying your lab bundle:

- `entity_type`

  This should be set to `Lab` for lab bundles. For other entity types such as `CourseTemplate` or `Quiz` please see their own bundle spec.

- `schema_version`

  This notes which version of this spec the bundle is using. The valid values are `1` (deprecated) and `2` (current).

### Default Locale

The lab bundle MUST specify a `default_locale`. It corresponds to the locale that the lab is originally authored in. Authoring tools can use this as a hint to notify localizers when content in the default locale is updated. Also, it provides a hint to the learner interface about which locale to display if an instruction/resource is not localized for the learner's current locale.

### Lab attributes

attribute              | required | type        | notes
---------------------- | -------- | ----------- | -----------------------------------------
title                  | ✓        | locale dictionary |
description            | ✓        | locale dictionary |
duration               | ✓        | integer     | Amount of time it should take an average learner to complete the lab (in minutes)
level                  |          | string      |
logo                   |          | file path   |
tags                   |          | array       |
legacy_display_options |          | array       | Elements to hide/show in ql-lab-control-panel widget

### Instructions

attribute | required | type              | notes
--------- | -------- | ----------------- | -----------------------------------------
type      | ✓        | enum              | [See list of valid types below]
uri       | ✓        | locale dictionary | Within the locale dictionary, the values are paths to files in the bundle.

```yml
instruction:
  type: html
  uri:
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

### Environment

#### Resources (Environment)

The sandbox learning environment is a key feature of Qwiklabs. As the author of a lab, you need to tell us which cloud accounts to provision for a learner, and what resources we should create in that account before handing it over to the learner.

The properties of each environment resource will depend on their type, e.g. AWS Accounts and GSuite Users require different configuration data. However, there are three properties that all resources have regardless of type:

attribute | required | type   | notes
--------- | -------- | ------ | -----------------------------------------
type      | ✓        | enum   | [See list of valid types]
id        |          | string | Identifier that can be used throughout project bundle.
variant   |          | string | The subtype resource being requested. Each type below lists its valid variants and specifies which is the default.

```yml
environment:
  resources:
    - type: gcp_project
      id: my_primary_project
    - type: gcp_project
      id: secondary_project
      variant: gcpfree
    - type: gcp_user
      id: primary_user
    - type: gcp_user
      id: secondary_user
```

##### GCP Project (gcp_project)

attribute                        | required | type    | notes
---------------------------------| -------- | ------- | --------------------------------------
startup_script.type              |          | string  | The type of startup script. Only `deployment_manager` is supported.
startup_script.path              |          | path    | Relative path to a directory tree with the script contents.
startup_script.custom_properties |          | array   | Array of pairs. See below for details.
cleanup_script.type              |          | string  | The type of cleanup script. Only `deployment_manager` is supported.
cleanup_script.path              |          | path    | Relative path to a directory tree with the script contents.
cleanup_script.custom_properties |          | array   | Array of pairs. See below for details.
ssh_key_user                     |          | string  | If this project should use a user's SSH key, the id of that user.

```yml
- type: gcp_project
  id: secondary_project
  variant: gcpfree
  startup_script:
    type: deployment_manager
    path: dm_startup.zip
    custom_properties:
      - key: userNameWindows
        value: student
  cleanup_script:
    type: deployment_manager
    path: dm_cleanup.zip
    custom_properties:
      - key: primary_project_zone
        reference: my_primary_project.zone
```

> **NOTE:** The existing concept of Qwiklabs' Fleets does not have a single
> analog in content bundles.
>
> Some fleet types map to resource types (e.g. `gsuite_multi_tenant` fleet is
> now the `gsuite-domain` resource type), while other fleets are allowed as
> "variants" of `gcp_project` (see below).

###### Variants for GCP Project

The allowed variants are:

- gcpd [default]
- gcpfree
- gcpasl
- gcpedu

###### Custom Script Properties

attribute | required | type               | notes
----------| -------- | ------------------ | --------------------------------------
key       | ✓        | string             | How the property will be referenced within the script.
value     |          | string             | A value to be passed into the script.
reference |          | resource reference | A [resource reference](#resource-references) to be passed into the script.

###### Valid resource references

The valid `reference`s for the `gcp_project` resource are:

- [PROJECT].project_id
- [PROJECT].default_zone

##### GCP User (gcp_user)

attribute   | required | type       | notes
----------- | -------- | ---------- | ----------------------------------------
permissions |          | array      | Array of project/roles(array) pairs

```yml
  - type: gcp_user
    id: primary_user
    permissions:
      - project: my_primary_project
        roles:
          - roles/editor
          - roles/bigquery.admin
```

The `gcp_user` type could more properly be called `gaia_user`, since that's what it provisions. However, the term `gaia` is less well-known, so we stick with `gcp`.

###### Valid resource references

The valid `reference`s for the `gcp_user` resource are:

- [USER].username
- [USER].password

##### GSuite Domain (gsuite_domain)

attribute   | required | type       | notes
----------- | -------- | ---------- | ----------------------------------------
No additional attributes

```yml
- type: gsuite_domain
  id: primary_domain
```

##### GCP Shell (gcp_shell)

> _PROPOSED ONLY: GCP Shell is not yet supported by Qwiklabs runtime._

attribute   | required | type       | notes
----------- | -------- | ---------- | ----------------------------------------
permissions | ✓        | array      | Array of project/roles(array) pairs

```yml
  - type: gcp_shell
    id: shell
    permissions:
      - project: my_primary_project
        roles:
          - roles/editor
```

##### AWS Account (aws_account)

attribute   | required | type       | notes
----------- | -------- | ---------- | ----------------------------------------
account_restrictions.allow_dedicated_instances  |          | boolean | Default false.
account_restrictions.allow_spot_instances       |          | boolean | Default false.
account_restrictions.allow_subnet_deletion      |          | boolean | Default false.
account_restrictions.allow_vpc_deletion         |          | boolean | Default false.
account_restrictions.allowed_ondemand_instances |          | array   | Array of [EC2 instance types](#valid-eC2-instance-types) that are valid for Ondemand usage. Default none.
account_restrictions.allowed_rds_instances      |          | array   | Array of [EC2 instance types](#valid-eC2-instance-types) that are valid for RDS usage. Default none.
startup_script.type              |          | string  | The type of startup script. Only `cloud_formation` is supported.
startup_script.path              |          | path    | Relative path to a directory tree with the script contents.
startup_script.custom_properties |          | array   | Array of pairs. See [Custom Script Properties](#custom-script-properties) for details.
cleanup_script.type              |          | string  | The type of cleanup script. Only `cloud_formation` is supported.
cleanup_script.path              |          | path    | Relative path to a directory tree with the script contents.
cleanup_script.custom_properties |          | array   | Array of pairs. See [Custom Script Properties](#custom-script-properties) for details.
user_policy                      |          | path    | Relative path to a [JSON policy](https://awspolicygen.s3.amazonaws.com/policygen.html) document.

```yml
- type: aws_account
  id: the_account
  variant: sts
  startup_script:
    type: cloud_formation
    path: ./lab.template
    custom_properties:
      - key: userNameWindows
        value: student
  user_policy: ./student.policy
  account_restrictions:
    allow_dedicated_instances: false
    allow_spot_instances: false
    allow_subnet_deletion: false
    allow_vpc_deletion: false
    allowed_ondemand_instances: []
    allowed_rds_instances: ['db.t2.micro']
```

###### Variants for AWS Account

- aws_beta
- aws_ec2
- aws_rt53labs_ilt
- aws_sts
- aws_vpc
- awsiam

... or ....

List of all fleets as currently used:
https://console.cloud.google.com/bigquery?sq=403355294977:d397a1416639404e9b320ec78f476209

###### Valid EC2 Instance Types

The list of valid EC2 instance types is not fixed.

TODO(joshgan): Find link for evergreen reference to valid content types.

TODO(joshgan): Should Qwiklabs/Alexandria validate this at time of ingestion/publishing?

###### AWS Account Default Policy

The default policy is an important tool for limiting the actions a student can take in a lab.

TODO(joshgan): Add more details

TODO(joshgan): Do we want to allow the lab author to specify this as another policy file?

###### Valid custom property references

The valid `reference`s for an `aws_account` resource are:

- [AWS_ACCOUNT].account_id
- [AWS_ACCOUNT].username
- [AWS_ACCOUNT].password

Note: Even though the spec supports any number of projects with any number roles, Qwiklabs only supports a shell having access to a single project and it must have the `roles/editor` role in that project. This note will be removed when Qwiklabs supports multiple projects and different roles for `gcp_shell`.

<!-- Legacy display option replacements -->

- [AWS_ACCOUNT].sts_link
- [AWS_ACCOUNT].access_key_id
- [AWS_ACCOUNT].fleet_console_credentials
- [AWS_ACCOUNT].rdp_credentials
- [AWS_ACCOUNT].ssh_credentials
- [AWS_ACCOUNT].vnc_link

#### Student Visible Outputs

Specify which resource properties are given to the lab taker.

Not all details of the lab environment should be exposed to the lab taker. For example, a lab may involve a GCP project and two GCP users. The lab taker is expected to log into GCP as one user, and manipulate the IAM privileges of the other. Since the lab taker is not expected to log in as the second user, there is no reason to display the second user's password and doing so may be distracting.

attribute | required | type               | notes
----------| -------- | ------------------ | --------------------------------------
label     | ✓        | string             | A label identifying to the student what the displayed reference is.
reference | ✓        | resource reference | A [resource reference](#resource-references) for a value to be displayed to the student.

```yml
environment:
  student_visible_outputs:
    - label:
        locales:
          en: "GCP Project"
      reference: primary_project.project_id
    - label:
        locales:
          en: "Username"
      reference: primary_user.username
    - label:
        locales:
          en: "Password"
          es: "Contraseña"
      reference: primary_user.password
```

### Activity Tracking (Alpha)

Activity tracking is a feature for evaluating a student's performance in a lab by running a script at "checkpoints". These scripts can call APIs relevant to any environment resource to query their current state. For example, the script may inspect and validate the configuration of GCE instances running in `my-project`, to ensure the user is following the instructions properly.

Lab bundles will provisionally support the JSON representation of Activity Tracking currently used in the Qwiklabs web interface. The JSON definition should be stored in file separately from (and referenced directly in) `qwiklabs.yaml`.

```yaml
entity_type: Lab

...

activity_tracking: ./assessment/activity_tracking.json
```

> **Note:** Support for this format should be considered deprecated.
>
> Further work will be done to define a new DSL for expressing Activity Tracking logic. Exploratory sketches of this DSL can be found in the `./examples` directory of this repository.
