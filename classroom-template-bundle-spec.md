# Qwiklabs ClassroomTemplate Bundle Specification

**Version 1**

> **Note: For Interim Use Only**
>
> This specification is for existing Qwiklabs platform users that are currently using the `ClassroomTemplate` model. It should be used to help transition from `ClassroomTemplates` to [`CourseTemplates`](./course-template-bundle-spec.md). If you are not currently using `ClassroomTemplates`, please use `CourseTemplates` instead.


## `qwiklabs.yaml` Structure

Here's a sample `qwiklabs.yaml` file with all nested details removed to make it easier to see the general file structure.

```yml
entity_type: ClassroomTemplate
schema_version: 1

# ClassroomTemplate Attributes
default_locale: en

# Versions should be considered decorators, and are not used as a source of truth for revision history.
version: ver. 2

# one of ["Self-paced", "Bootcamp/Workshop", "Instructor-led"]
classroom_type: Instructor-led

course_code: T-AHYXXX-I

title:
  locales:
    en: Architecting with Google Cloud Platform.

description:
  locales:
    en: Learn GCP basics in a classroom setting.

objectives:
  locales:
    en: |
      <p>This course will teach people</p>
      <ul>
        <li>What GCP is</li>
        <li>How to use some of its core components</li>
      </ul>

audience:
  locales:
    en: |
      <p>This course is intended for people who</p>
      <ul><li>Are new to GCP</li></ul>

prerequisites:
  locales:
    en: <p>A basic understanding of serverless architecture is recommended but not required.</p>

# Outline is a JSON formatted string
outline:
  locales:
    en: >
      {\"subhead\":\"The course includes presentations and hands-on labs.\",\"modules\":[{\"name\":\"Module 1: Anthos Overview\",\"items\":[\"Describe challenges of hybrid cloud\",\"Discuss modern solutions\",\"Describe the Anthos Technology Stack\"]}]}

external_content_url:
  locales:
    en: "https://www.coursera.org/specializations/architecting-hybrid-cloud-infrastructure-anthos"

tags: [sample, life-changing, gcp]
product_tags: ['compute engine', 'cloud storage']
role_tags: ['cloud architect', 'developers backend']
domain_tags: ['infrastructure']
level: 1

# course_surveys
course_surveys: ['cloud-training-l2io16cn5i']

# Estimated time to take the course, in days
estimated_duration_days: 1

# Estimated time to take the course, in minutes
estimated_duration: 60

# Allow lab order to be changed by the trainer
lock_activity_position: false

# Trainers must stay within the limits
max_hot_labs: 30

# Enable DRM on instructions if supported
enable_drm: false

# Check classroom for fraud
resource_limit_check: false

# Instructions that will be surfaced to students
student_resources: ...

# Instructions that will not be surfaced to students, but may be referenced by an instructor
instructor_resources: ...

# The important part of a ClassroomTemplate which lists all of the labs
modules: ...

```

Note that all of the main chunks of localized content (title, description, objectives, audience, prerequisites, etc.) are HTML content that may be displayed in various contexts. All of these chunks will be sanitized according to the restricted set in the [HTML spec](./html-spec.md).

### Attribute specification
The full specification is as follows:

attribute               | required | type        | notes
----------------------- | -------- | ----------- | -----------------------------------------
entity_type             | ✓        | string      | Must be `ClassroomTemplate`
schema_version          | ✓        | integer     |
default_locale          | ✓        | enum        | Must be a valid locale code
version                 |          | string      | Version string used as content decorator
classroom_type          |          | enum        | One of ["Self-paced", "Bootcamp/Workshop", "Instructor-led"]
course_code             |          | string      | Id for Course, e.g. T_AHYXXX-I, usually determined by Training Ops. Not the same as the Git "slug"
title                   | ✓        | dictionary  | A locale dictionary of titles
description             | ✓        | dictionary  | A locale dictionary of descriptions
objectives              |          | dictionary  | A locale dictionary of objectives
audience                |          | dictionary  | A locale dictionary of audiences
prerequisites           |          | dictionary  | A locale dictionary of prerequisites
outline                 |          | dictionary  | A locale dictionary of outline elements usually formatted as a JSON string
external_content_url    |          | dictionary  | A locale dictionary of URL's to Coursera (or other) external content
tags                    |          | array       | Array of strings to be used as hints in searching, etc.
product_tags            |          | array       | Array of strings from the "Products" column in [this sheet](https://docs.google.com/spreadsheets/d/1hUUch85HBRsRJsgRo9VCg0Pn7ZXi21sl6JU7VOr9LP8)
role_tags               |          | array       | Array of strings from the "Roles" column in [this sheet](https://docs.google.com/spreadsheets/d/1hUUch85HBRsRJsgRo9VCg0Pn7ZXi21sl6JU7VOr9LP8)
domain_tags             |          | array       | Array of strings from the "Domain" column in [this sheet](https://docs.google.com/spreadsheets/d/1hUUch85HBRsRJsgRo9VCg0Pn7ZXi21sl6JU7VOr9LP8)
level                   |          | integer     | Integer between 1 and 4, with 1 being the easiest
course_surveys          |          | array       | Array of course survey 'slugs'
estimated_duration_days |          | integer     | Estimated time to take the course, in days
estimated_duration      |          | integer     | Estimated time to take the course, in minutes
lock_activity_position  |          | boolean     | Allow lab order to be changed by the trainer
max_hot_labs            |          | integer     | Maximum number of hot labs for this course.
enable_drm              |          | boolean     | Enable DRM on instructions if supported
resource_limit_check    |          | boolean     | Check classroom for fraud
student_resources       |          | array       | Student-specific instructions. See the [Resource Spec](./resource-spec.md) for full specification.
instructor_resources    |          | array       | Instructor-specific instructions. See the [Resource Spec](./resource-spec.md) for full specification.
modules                 |          | array       | See below

### Modules

A `ClassroomTemplate` presents labs to the learner in a specific order. To keep some compatibilty with other "bundle entities" we will use a simple collection of steps, each with one lab activity.

attribute               | required | type        | notes
----------------------- | -------- | ----------- | -----------------------------------------
id                      | ✓        | string      | A unique identifier for this module
steps                   |          | array       | See below

### Steps

For a ClassroomTemplate, a step consists of one activity option. The valid activity type is:

* `lab`

Where `lab` references content defined elsewhere in the library.

The overall format should look like:

```yml
steps:
  - id: intro-lab
    activity_options:
    - type: lab
      id: intro-to-gcp

  - id: learn-compute
    activity_options:
    - type: lab
      id: intro-to-appengine-python
```

The order in which steps are listed defines the order they will be displayed.
