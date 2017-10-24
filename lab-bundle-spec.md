# Qwiklabs Lab Bundle Specification

> This is a DRAFT DOCUMENT and refers to QLB v1-alpha.
>
> We welcome feedback as this format evolves.

A Qwiklabs Bundle, or QLB, is any directory that contains a qwiklabs.yaml file which defines a learning entity in Qwiklabs. This specification focuses specifically on the Lab entity.

The QLB format aims to:

1. Make it easy to author developer learning materials in your native tools.

1. Provide a simple format into which existing content can be programmatically transformed, making it convenient to migrate existing learning materials from diverse sources into Qwiklabs modules.


## Structure Overview

- Instructions
- Resources
- "Assets"
- Additional Files


## QLB Structure Details

### Instructions

Specified as markdown files in root folder.

### Resources

| attribute | required | sample | notes |
|-----------|----------|--------|-------|
| type      | ✓ | github    | [See list of valid types] |
| title     | ✓ | My Awesome Doc | Display title for the resource |
| uri       | ✓ | ./resources/sample-en.pdf | External URL or path to local file in bundle |
| locale    |   | en             | If specified, the resource will only be displayed to users in the given locale. If unspecified, the resource will be displayed for all locales. |


##### Valid types

- Bundled file
- Url
- Github link
- Youtube link


### Assets

| attribute | required | sample | notes |
|-----------|----------|--------|-------|
| type      | ✓ | gcp-project    | [See list of valid types] |
| ref       |   | my_asset       | identifier that can be used throughout project bundle
| title     | ✓ | My Awesome Doc | Display title for the resource |
| locale    |   | en             | If specified, the resource will only be displayed to users in the given locale. If unspecified, the resource will be displayed for all locales. |

> Note: Localization is necessary primarily for the concept of title and alternate versions of the setup scripts.

#### Valid types

- gcp-project
- gcp-user
- aws-account
- gsuite-account
- multi-tennent????

Additional valid properties of the asset depend on the selected type.



#### GCP Project (gcp-project)

| attribute | required | sample | notes |
|-----------|----------|--------|-------|
| type      | ✓ | gcp-project    | |
| dm_script |  | ./deployment_manager/foo.yml | relative path to file in bundle |
| variant   |  | ASL | This maps to our current understanding of fleet |
| include_user | | true/false | ???? |

#### GCP User (gcp-user)

| attribute | required | sample | notes |
|-----------|----------|--------|-------|
| type         | ✓ | gcp-user    |      |
| permissions  |   | [See below] | Provide IAM roles |


```yaml
permissions:
  # Reference to a GCP project asset
  my_project:
    compute: editor
  other_project:
    compute: editor
    netword: editor
```

#### AWS Account (aws-account)

| attribute | required | sample | notes |
|-----------|----------|--------|-------|
| type      | ✓ | aws-account   | |
| cf_script |  | ./cloudformation/foo.json | relative path to file in bundle |

#### GSuite Account (gsuite-account)

...
