# Qwiklabs CourseTemplate Bundle Specification

**Version 1**

> This is a DRAFT document. We welcome feedback as this format evolves.

## `qwiklabs.yaml` Structure

Here's a sample `qwiklabs.yaml` file with all nested details removed to make it
easier to see the general file structure.

```yaml
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

auto_upgrade_to_latest_version: false

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

course_surveys:
  - my-library/new-cloud-training-survey-fayoci

# Resources that will not be surfaced to students, but may be referenced by an instructor
instructor_resources:
  - title:
      locales:
        en: How to teach
        es: Como enseñar
    uri:
      locales:
        en: https://www.wikihow.com/Teach
        es: https://www.wikihow.es/enseñar

tags: [sample, life-changing, gcp]
product_tags: ['compute engine', 'cloud storage']
role_tags: ['cloud architect', 'developers backend']
domain_tags: ['infrastructure']
level: 1
image: gcp-intro-course-image.png
badge: gcp-intro-course-badge.png

# Estimated time to take the course, in minutes
# This value will be calculated automatically if it is not provided by the author
estimated_duration_minutes: 0

# Pseudo-deprecated legacy field that we would like to remove
max_hot_labs: 30

# Resources that may be referenced below in steps
resources: ...

# The important part of a CourseTemplate which lists all of the activities
modules:
  - title:
      locales:
        en: What GCP is?
        es: ¿Qué es GCP?

    description:
      locales:
        en: Explains what is GCP
        es: Explica qué es GCP

    learning_objectives:
      locales:
        en:
          - Learn what is GCP
          - Identify what GCP offers
        es:
          - Más información sobre GCP
          - Identifica lo que ofrece GCP

    steps:
      ...

```

Note that all of the main chunks of localized content (title, description,
objectives, audience, and prerequisites) are HTML content that may be displayed
in various contexts. All of these chunks will be sanitized according to the
restricted set in the [HTML spec](./html/html-spec.md).

### Attribute specification

The full specification is as follows:

attribute                          | required | type       | notes
---------------------------------- | -------- | ---------- | -----
entity_type                        | ✓        | string     | Must be `CourseTemplate`
schema_version                     | ✓        | integer    |
default_locale                     | ✓        | enum       | Must be a valid locale code
title                              | ✓        | dictionary | A locale dictionary of titles
description                        | ✓        | dictionary | A locale dictionary of descriptions
version                            |          | dictionary | A locale dictionary of version strings. These version strings should be considered decorators, and are not used as a source of truth for revision history.
auto_upgrade_to_latest_version     |          | boolean    | `true` if course enrollees should automatically be upgraded to the latest course version. Otherwise, they'll be asked if they want to upgrade when a new version is available.
objectives                         |          | dictionary | A locale dictionary of objectives
audience                           |          | dictionary | A locale dictionary of audiences
prerequisites                      |          | dictionary | A locale dictionary of prerequisites
tags                               |          | array      | Array of strings to be used as hints in searching, etc
product_tags                       |          | array      | Array of strings from the "Products" column in [this sheet](https://docs.google.com/spreadsheets/d/1hUUch85HBRsRJsgRo9VCg0Pn7ZXi21sl6JU7VOr9LP8)
role_tags                          |          | array      | Array of strings from the "Roles" column in [this sheet](https://docs.google.com/spreadsheets/d/1hUUch85HBRsRJsgRo9VCg0Pn7ZXi21sl6JU7VOr9LP8)
domain_tags                        |          | array      | Array of strings from the "Domain" column in [this sheet](https://docs.google.com/spreadsheets/d/1hUUch85HBRsRJsgRo9VCg0Pn7ZXi21sl6JU7VOr9LP8)
level                              |          | integer    | Integer between 1 and 4, with 1 being the easiest
image                              |          | string     | Link to an image file to be used as the image for the course
badge                              |          | string     | Link to an image file to be used as the badge for the course, at least 640px x 640px.
estimated_duration_minutes         |          | integer    | Estimated time to take the course, in minutes. This value will be calculated automatically if it is not provided by the author.
max_hot_labs                       |          | integer    | Maximum number of hot labs for this course. Pseudo-deprecated legacy field that we would like to remove.
course_surveys                     |          | array      | Array of course survey 'library/slug'
instructor_resources               |          | array      | Instructor-specific resources. Array of dictionaries with keys `title` and `uri` and values locale dictionaries.
resources                          |          | array      | See [below](#resources)
modules                            | ✓        | array      | See [below](#modules)
retake_policies                    |          | array      | See [below](#retake-policies)

### Modules

The meat of a `CourseTemplate` is an ordered list of modules, each of which is a
collection of steps, defining what a learner needs to do to complete the course.
A module has a `title`, `description`, `learning_objectives`, and array of
`steps`. The full specification is as follows:

attribute          | required | type       | notes
------------------ | -------- | ---------- | -----------------------------------
id                 | ✓        | string     | A unique identifier for this module
title              | ✓        | dictionary | A locale dictionary of titles
description        |          | dictionary | A locale dictionary of descriptions
steps              | ✓        | array      | See below
learning_objectives|          | dictionary | A locale dictionary of array of learning objectives
### Resources

While heavyweight activities like labs and quizzes must be defined elsewhere in
the library, we allow simpler resources to be specified directly in
`qwiklabs.yaml`. They can then be referenced in the `steps` just like labs and
quizzes.

For details on how to specify resources, see the
[Resource Spec](./resource-spec.md).

### Steps

A step consists of a set of one or more activity options, along with some
metadata. Valid activity types are:

*   `lab`
*   `challenge_lab`
*   `quiz`
*   `peer_assignment`
*   `resource`

`lab`, `challenge_lab`, `quiz` and `peer_assignment` will reference content
defined elsewhere in the library, and `resource` will reference content defined
elsewhere in the same `qwiklabs.yaml` file.

The overall format should look like:

```yaml
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
      category: graded
      id: compute-quiz
      version: '1.0'

  - id: peer-assignment
    activity_options:
    - type: peer_assignment
      id: peer-assignment

  - id: challenge-lab
    activity_options:
    - type: challenge_lab
      id: challenge-lab
```

The order in which steps are listed defines the order they will be displayed.
When a step has multiple options, the learner will be expected to do exactly one
of the activities.

The full specification for a step is as follows:

attribute        | required | type       | notes
---------------- | -------- | ---------- | -----
id               | ✓        | string     | A unique identifier for this step
activity_options | ✓        | array      | `activity_options` is an array of dictionaries with the format:
-- type          | ✓        | enum       | One of `lab`, `challenge_lab`, `quiz`, `resource`, `peer_assignment`
-- category      |          | string     | A subordinate descriptor for an activity of the above `type` used in the context of retakes to indicate the applicable retake policy.
-- id            | ✓        | string     | Reference to the unique identifier for the activity - `library/slug`.
-- version       |          | string     | Reference to the semantic version of the activity to which the course step should be frozen.
prompt           |          | dictionary | Key is `locales` and each locale is a dictionary mapping locale codes to a prompt describing the step
optional         |          | boolean    | `true` if the step is *not* required for completion

### Retake Policies

A retake policy defines any required cooldown periods, retake limits, and retake
windows applicable to a given `CourseTemplate` activity.

The overall format should look like:

```yaml
retake_policies:
  - id: default-lab-policy
    activity_type: Lab
    retake_cooldown:
      - 1
      - 2
      - 5

  - id: practice-quiz-policy
    activity_type: Quiz
    activity_category: practice
    retake_limit: 3
    retake_window: 1

  - id: graded-quiz-policy
    activity_type: Quiz
    activity_category: graded
    retake_cooldown:
      - 1
    retake_limit: 3
    retake_window: 1
```

attribute         | required | type    | notes
----------------- | -------- | ------- | -----
activity_type     | ✓        | enum    | The type of retakeable activity to which this retake policy applies; one of `Lab` or `Quiz`
activity_category |          | string  | Distinguishes a subset of a given type of retakeable activity to which this retake policy applies (e.g. `graded` for quiz); category must match one of the categories given on a retakeable activity
retake_cooldown   |          | array   | An array of `n` integers (greater than or equal to 0) specifying the required cooldown periods (in days) between consequent retakes; the last integer will be the cooldown period for all retakes after the `nth`; For example, a retake_cooldown of `[1, 2, 5]` would require a student to wait 1 day before their 1st retake, 2 days between their 1st and 2nd retakes, and 3 days between their 2nd and 3rd retakes, 3rd and 4th retakes, and so on. If a student has waited for the appropriate coooldown period, they will only be allowed to retake the activity given they have not exceeded any retake limit.
retake_limit      |          | integer | The total number of attempts (greater than 0) allowed for the given type and subtype of retakeable activity; required if `retake_window` below is specified. For example, a retake_limit of `3` would indicate a student will *not* be allowed to retake the activity after a total of 3 attempts. If a student is within the retake_limit, they will only be allowed to retake the activity given they have waited for the appropriate cooldown period.
retake_window     |          | integer | An integer (greater than 0) specifying the period (in days) for which the `retake_limit` above applies. For example, a retake_limit of `3` paired with a retake_window of `1` would indicate a student can retake the activity as long as no more than 3 attempts are made within a 1 day period.
