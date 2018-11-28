# Qwiklabs Course Bundle Specification

**Version 1**

> This is a DRAFT document. We welcome feedback as this format evolves.

## `qwiklabs.yaml` Structure

Here's a sample `qwiklabs.yaml` file with all nested details removed to make it easier to see the general file structure.

```yml
entity_type: Course
schema_version: 1

# Course Attributes
id: gcp-intro-course
default_locale: en

title:
  locales:
    en: GCP Intro Course

description:
  locales:
    en: Get a taste of what GCP has to offer.

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
logo: ./gcp-intro-course-logo.png
badge: ./gcp-intro-course-badge.png

# Estimated time to take the course, *in days*
duration: 1

# Resources that may be referenced below in steps
resources: ...

# The important part of a course which lists all of the activities
steps: ...

```

Note that all of the main chunks of localized content (title, description, objectives, audience, and prerequisites) are HTML content that may be displayed in various contexts. All of these chunks will be sanitized according to [instruction-html-spec.md](./instruction-html-spec.md).

### Resources

While heavyweight activities like labs and quizzes must be defined elsewhere in the library, we allow simpler resources to be specified directly in the course's `qwiklabs.yaml`. They can then be referenced in the `steps` just like labs and quizzes.

For details on how to specify resources, see the [Resource Spec](./resource-spec.md).

### Steps

The meat of a course is an ordered list of steps defining what a learner needs to do to complete the course. A step consists of a set of one or more activity options, along with some metadata. Valid activity types are:

* `lab`
* `quiz`
* `resource`

`lab` and `quiz` will reference content defined elsewhere in the library, and `resource` will reference content defined elsewhere in the same `qwiklabs.yaml` file.

The overall format should look like:

```yml
steps:
  - activity_options:
    - type: resource
      content: intro-video
    prompt:
      locales:
        en: If you've never used GCP, we recommend this overview video.
    optional: true

  - activity_options:
    - type: lab
      content: intro-to-gcp

  - activity_options:
    - type: resource
      content: choosing-compute

  - activity_options:
    - type: lab
      content: intro-to-appengine-python
    - type: lab
      content: intro-to-kubernetes-engine
    - type: lab
      content: intro-to-cloud-functions
    prompt:
      locales:
        en: Learn more about one of these common compute resources.

  - activity_options:
    - type: quiz
      content: compute-quiz
```

The order in which steps are listed defines the order they will be displayed. When a step has multiple options, the learner will be expected to do exactly one of the activities.

The full specification for a step is as follows:

attribute        | required | type        | notes
---------------- | -------- | ----------- | -----------------------------------------
activity_options | ✓        | array       | `activity_options` is an array of dictionaries with the format:
-- type          | ✓        | enum        | One of `lab`, `quiz`, `resource`
-- content       | ✓        | string      | Reference to the unique identifier for the activity. TODO: How to fully qualify `id` on labs and quizzes?
prompt           |          | dictionary  | Key is `locales` and each locale is a dictionary mapping locale codes to a prompt describing the step
optional         |          | boolean     | `true` if the step is *not* required for completion
