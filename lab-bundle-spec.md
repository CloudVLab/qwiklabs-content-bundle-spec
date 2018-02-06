# Qwiklabs Lab Bundle Specification

**Version 1**

> This is a DRAFT document. We welcome feedback as this format evolves.

## `qwiklabs.yaml` Structure

Here's a sample `qwiklabs.yaml` file, with all nested details removed to make it easier to see the general file structure.

```yml
entity_type: Lab
schema_version: 1

# Lab Attributes
id: my-awesome-lab
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

  Currently this can only be "Lab". In the future we will expand the QLB specification to include "Courses", "Quests", and other content that Qwiklabs supports.

- `schema_version`

  This notes which version of this spec the bundle is using. Currently, the only valid value is "1" but this will change as new features get added.

### Default Locale

The lab bundle MUST specify a `default_locale`. It corresponds to the locale that the lab is originally authored in. Authoring tools can use this as a hint to notify localizers when content in the default locale is updated. Also, it provides a hint to the learner interface about which locale to display if an instruction/resource is not localized for the learner's current locale.

### Lab attributes

attribute   | required | type        | notes
----------- | -------- | ----------- | -----------------------------------------
id          | ✓        | string      | Identifier for this lab, must be unique per "library" and URL friendly (think github org/repo)
title       | ✓        | locale dictionary |
description | ✓        | locale dictionary |
duration    | ✓        | integer     | Amount of time it should take an average learner to complete the lab (in minutes)
level       |          | string      | enum?
logo        |          | file path   |
tags        |          | array       |
copyright   |          | string/enum | v2 feature after more research?


```ruby
# NOTE: Unreferenced properties on Lab model that we may also want to add here.
t.string   "creator_tagline"
t.decimal  "price"

# NOTE: Currently on Lab model, but aren't really content concerns.
t.boolean  "send_end_lab_email"
t.boolean  "concurrent_allowed"
```

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
- Authors can specify interactive elements that will be displayed inline with your instructions in the learner's interface (quizzes, checkpoints, etc)

However, we will not accept arbitrary HTML. Your input will be heavily scrubbed.

- Only a standard subset of HTML elements will be supported (`<h1>`, `<p>`, `<strong>`, etc). All other tags will be stripped out of displayed content.
- All styling will be removed.
- All scripting will be removed.

See [Instruction HTML spec](./instruction-html-spec.md) for details.

### Resources

Resources are additional materials that learners may refer to while taking this lab.

We encourage content authors to use as few external links as possible. Qwiklabs cannot guarantee that those links will be available when a learner takes your lab. For instance, if you have a PDF that you wish to include in the lab, you should add it as a file in this lab bundle instead of referencing it as a link to Cloud Storage or S3.

[TODO: Recommendation for extremely large resources]

> **Note**: If you are linking to an external resource that has its own understanding of source control, please link to the specific revision of that resource. That way, if the external resource is updated, your learners will not be affected. For example, if you are referencing a Github repo, include the link to a specific tag, instead of the default branch.
>
> Brittle: <https://github.com/CloudVLab/qwiklabs-lab-bundle-spec/>
>
> Better: <https://github.com/CloudVLab/qwiklabs-lab-bundle-spec/tree/v1-prerelease>

attribute      | required | type        | notes
-------------- | -------- | ----------- | -----------------------------------------
type           | ✓        | enum        | [See list of valid types below]
ref            |          | string      | Identifier that can be used throughout project bundle
locales        | ✓        | dictionary  | Keys are locale codes, the values are dictionaries with the following attributes:
-- title       | ✓        | string      | Display title for the resource
-- description |          | string      | More content to display beyond just the title of the resource
-- uri         | ✓        | URL or path | External URL or path to local file in bundle

```yml
resources:
  - type: code
    ref_id: code_repo
    locales:
      en:
        title: Self-referential Github Repo
        uri: https://github.com/CloudVLab/qwiklabs-lab-bundle-spec/tree/v1-prerelease
      es:
        title: Auto-referencial Github Repo
        uri: https://github.com/CloudVLab/qwiklabs-lab-bundle-spec/tree/v1-prerelease
  - type: file
    locales:
      en:
        title: Sample PDF
        description: This PDF contains all of the code samples for the lab
        uri: resources/sample-en.pdf
```

#### Valid types

- `file`  - a relative path to a file in the lab bundle
- `link`  - a url to an external resource
- `code`  - A link to code outside of the bundle such as on Github
- `video` - A link to a video outside of the bundle such as on Youtube

To prevent confusion, all resources much explicitly define what type they are. This helps distinguish between a link to a GitHub repo and a link to a code snippet on GitHub.

TODO:
- Does the fact that we know it's a Github repo give us any additional functionality when referencing it elsewhere in the bundle?

### Environment Resources

The sandbox learning environment is a key features of Qwiklabs. As the author of a lab, you need to tell us which cloud accounts to provision for a learner, and what resources we should create in that account before handing it over to the learner.

The properties of each environment resource will depend on their type, i.e. AWS Accounts and GSuite Users require different configuration data. However, there are two properties that all resources have regardless of type:


attribute | required | type   | notes
--------- | -------- | ------ | -----------------------------------------
type      | ✓        | enum   | [See list of valid types]
ref       |          | string | Identifier that can be used throughout project bundle

```yml
environment_resources:
  - type: gcp_project
    ref_id: my_primary_project
    dm_script:
      locales:
        en: deployment_manager/instance_pool-en.py
        es: deployment_manager/instance_pool-es.py
  - type: gcp_user
    ref_id: primary_user
    permissions:
      - project: my_primary_project
        roles:
          - roles/editor
            roles/bigquery.admin
  - type: gcp_user
    ref_id: secondary_user
```

#### Valid types

##### AWS Account (aws-account)

attribute | required | type           | notes
--------- | -------- | -------------- | ---------------------------------------
cf_script |          | localized_path | relative path to file in bundle
variant   |          | enum           | TODO: This maps to our current understanding of fleet

```yml
- type: aws-account
  ref_id: primary_account
  variant: STS
  cf_script:
    locales:
      en: cloudformation/intro-dynamo-db.yaml
      es: cloudformation/intro-dynamo-db-es.yaml
```

```ruby
# NOTE: Unreferenced properties on Lab model that we may also want to add here.
t.decimal  "billing_limit"
t.string   "aws_region"
t.boolean  "global_set_vnc_password"
t.boolean  "allow_aws_vpc_deletion"
t.boolean  "allow_aws_subnet_deletion"
t.boolean  "allow_aws_spot_instances"
t.string   "allow_aws_ondemand_instances"
t.boolean  "allow_aws_dedicated_instances"
t.string   "allow_aws_rds_instances"
```

##### GCP Project (gcp-project)

attribute | required | type           | notes
--------- | -------- | -------------- | --------------------------------------
dm_script |          | localized_path | relative path to file in bundle
variant   |          | enum           | TODO: This maps to our current understanding of fleet

```yml
- type: gcp-project
  ref_id: secondary_project
  variant: ASL
  dm_script:
    locales:
      en: deployment_manager/instance_pool.yaml
      es: deployment_manager/instance_poolb-es.yaml
```

```ruby
# NOTE: Unreferenced properties on Lab model that we may also want to add here.
t.string   "cloud_region",                              limit: 255
```

##### GCP User (gcp-user)

attribute   | required | type       | notes
----------- | -------- | ---------- | ----------------------------------------
credentials |          | boolean    | Should the learner be given credentials for this user
roles       |          | dictionary | Specificy IAM roles per project

```yml
- type: gcp-user
  ref_id: learner_user
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

[TODO: Ask @davetchen what defines a GSuite fleet]

### Assessment

[TODO]
