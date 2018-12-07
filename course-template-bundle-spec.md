# Qwiklabs CourseTemplate Bundle Specification

**Version 1**

> This is a DRAFT document. We welcome feedback as this format evolves.

## `qwiklabs.yaml` Structure

Here's a sample `qwiklabs.yaml` file with all nested details removed to make it easier to see the general file structure.

```yml
entity_type: CourseTemplate
schema_version: 1

# CourseTemplate Attributes
default_locale: en

title:
  locales:
    en: GCP Intro Course

description:
  locales:
    en: Get a taste of what GCP has to offer.

# Versions should be considered decorators, and are not used as a source of truth for revision history.
version:
  locales:
    en: 2
    es: 1

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

tags: [sample, life-changing, gcp]
product_tags: ['compute engine', 'cloud storage']
role_tags: ['cloud architect', 'developers backend']
domain_tags: ['infrastructure']
level: 1
image: gcp-intro-course-image.png
badge: gcp-intro-course-badge.png

# Estimated time to take the course, in days
estimated_duration_days: 1

# Pseudo-deprecated legacy field that we would like to remove
max_hot_labs: 30

# Resources that will not be surfaced to students, but may be referenced by an instructor
instructor_resources: ...

# Resources that may be referenced below in steps
resources: ...

# The important part of a CourseTemplate which lists all of the activities
modules: ...

```

Note that all of the main chunks of localized content (title, description, objectives, audience, and prerequisites) are HTML content that may be displayed in various contexts. All of these chunks will be sanitized according to the restricted set in the [HTML spec](./html-spec.md).

### Attribute specification
The full specification is as follows:

attribute               | required | type        | notes
----------------------- | -------- | ----------- | -----------------------------------------
entity_type             | ✓        | string      | Must be `CourseTemplate`
schema_version          | ✓        | integer     |
default_locale          | ✓        | enum        | Must be a valid locale code
title                   | ✓        | dictionary  | A locale dictionary of titles
description             |          | dictionary  | A locale dictionary of descriptions
version                 |          | dictionary  | A locale dictionary of version strings. These version strings should be considered decorators, and are not used as a source of truth for revision history.
objectives              |          | dictionary  | A locale dictionary of objectives
audience                |          | dictionary  | A locale dictionary of audiences
prerequisites           |          | dictionary  | A locale dictionary of prerequisites
tags                    |          | array       | Array of strings to be used as hints in searching, etc
product_tags            |          | array       | Array of strings from the "Products" column in [this sheet](https://docs.google.com/spreadsheets/d/1hUUch85HBRsRJsgRo9VCg0Pn7ZXi21sl6JU7VOr9LP8)
role_tags               |          | array       | Array of strings from the "Roles" column in [this sheet](https://docs.google.com/spreadsheets/d/1hUUch85HBRsRJsgRo9VCg0Pn7ZXi21sl6JU7VOr9LP8)
domain_tags             |          | array       | Array of strings from the "Domain" column in [this sheet](https://docs.google.com/spreadsheets/d/1hUUch85HBRsRJsgRo9VCg0Pn7ZXi21sl6JU7VOr9LP8)
level                   |          | integer     | Integer between 1 and 4, with 1 being the easiest
image                   |          | string      | Link to an image file to be used as the image for the course
badge                   |          | string      | Link to an image file to be used as the badge for the course
estimated_duration_days |          | integer     | Estimated time to take the course, in days
max_hot_labs            |          | integer     | Maximum number of hot labs for this course. Pseudo-deprecated legacy field that we would like to remove.
instructor_resources    |          | array       | Instructor-specific resources. See the [Resource Spec](./resource-spec.md) for full specification.
resources               |          | array       | See below
modules                 | ✓        | array       | See below

### Modules

The meat of a `CourseTemplate` is an ordered list of modules, each of which is a collection of steps, defining what a learner needs to do to complete the course. A module has a `title`, `description`, and array of `steps`. The full specification is as follows:

attribute               | required | type        | notes
----------------------- | -------- | ----------- | -----------------------------------------
id                      | ✓        | string      | A unique identifier for this module
title                   | ✓        | dictionary  | A locale dictionary of titles
description             |          | dictionary  | A locale dictionary of descriptions
steps                   | ✓        | array       | See below

### Resources

While heavyweight activities like labs and quizzes must be defined elsewhere in the library, we allow simpler resources to be specified directly in `qwiklabs.yaml`. They can then be referenced in the `steps` just like labs and quizzes.

For details on how to specify resources, see the [Resource Spec](./resource-spec.md).

### Steps

A step consists of a set of one or more activity options, along with some metadata. Valid activity types are:

* `lab`
* `quiz`
* `resource`

`lab` and `quiz` will reference content defined elsewhere in the library, and `resource` will reference content defined elsewhere in the same `qwiklabs.yaml` file.

The overall format should look like:

```yml
steps:
  - id: overview-video
    activity_options:
    - type: resource
      id: intro-video
    prompt:
      locales:
        en: If you've never used GCP, we recommend this overview video.
    optional: true

  - id: intro-lab
    activity_options:
    - type: lab
      id: intro-to-gcp

  - id: choosing-compute
    activity_options:
    - type: resource
      id: choosing-compute

  - id: learn-compute
    activity_options:
    - type: lab
      id: intro-to-appengine-python
    - type: lab
      id: intro-to-kubernetes-engine
    - type: lab
      id: intro-to-cloud-functions
    prompt:
      locales:
        en: Learn more about one of these common compute resources.

  - id: compute-quiz
    activity_options:
    - type: quiz
      id: compute-quiz
```

The order in which steps are listed defines the order they will be displayed. When a step has multiple options, the learner will be expected to do exactly one of the activities.

The full specification for a step is as follows:

attribute        | required | type        | notes
---------------- | -------- | ----------- | -----------------------------------------
id               | ✓        | string      | A unique identifier for this step
activity_options | ✓        | array       | `activity_options` is an array of dictionaries with the format:
-- type          | ✓        | enum        | One of `lab`, `quiz`, `resource`
-- id            | ✓        | string      | Reference to the unique identifier for the activity. TODO: How to fully qualify `id` on labs and quizzes?
prompt           |          | dictionary  | Key is `locales` and each locale is a dictionary mapping locale codes to a prompt describing the step
optional         |          | boolean     | `true` if the step is *not* required for completion
