# Qwiklabs Certification Bundle Specification

**Version 1**

> This is a DRAFT document. We welcome feedback as this format evolves.

## `qwiklabs.yaml` Structure

Here's a sample `qwiklabs.yaml` file with all nested details removed to make it easier to see the general file structure.

```yml
entity_type: Certification
schema_version: 1

default_locale: en

title: 
  locales:
    en: Virtual Machines in GCP

description:
  locales:
    en: Prove what you know about VMs in GCP by doing these courses and exams!

objectives:
  locales:
    en:
      - 1st learning objective
      - 2nd learning objective
      - 3rd learning objective
      - etc...

audience:
  locales:
    en: >
      This certification is intended for people who want to test their knowledge
      of VMs in GCP.

prerequisites:
  locales:
    en: >
      It is recommended to know a little bit about Unix operating systems before
      beginning this certification.

tags:
product_tags:
role_tags:
domain_tags:

credits: 80

certificate_award: qwiklabs-accredible

steps: ...
```

### Certification attributes

attribute          | required | type       | notes
-------------------| -------- | ---------- | -----------------------------------------
default_locale     | ✓        | string     | Corresponds to the locale that the certification is authored in. Authoring tools can use this as a hint to notify localizers when content in the default locale is updated. Also, it provides a hint to the learner interface about which locale to display if an instruction/resource is not localized for the learner's current locale.
schema_version     | ✓        | integer    | Which version of the certification bundle schema you are using
title              | ✓        | dictionary | A locale dictionary of the certification title, such as "Virtual Machines in GCP"
description        |          | dictionary | A locale dictionary of the certification description which describes the contents of the certification
objectives         |          | dictionary | A locale dictionary of objective arrays
audience           |          | dictionary | A locale dictionary of audiences
prerequisites      |          | dictionary | A locale dictionary of prerequisites
tags               |          | array      | Array of strings to be used as hints in searching, etc.
product_tags       |          | array      | Array of strings from the "Products" column in [this sheet](https://docs.google.com/spreadsheets/d/1hUUch85HBRsRJsgRo9VCg0Pn7ZXi21sl6JU7VOr9LP8)
role_tags          |          | array      | Array of strings from the "Roles" column in [this sheet](https://docs.google.com/spreadsheets/d/1hUUch85HBRsRJsgRo9VCg0Pn7ZXi21sl6JU7VOr9LP8)
domain_tags        |          | array      | Array of strings from the "Domain" column in [this sheet](https://docs.google.com/spreadsheets/d/1hUUch85HBRsRJsgRo9VCg0Pn7ZXi21sl6JU7VOr9LP8)
credits            |          | integer    | Price of the certification
certificate_award  | ✓        | string     | A unique identifier for the corresponding award that this certification grants
steps              | ✓        | array      | An array of `steps` (see [Steps](#steps) below for details)

### Steps

A certification is composed of multiple `steps`. A step can be either a [CourseTemplate](./course-template-bundle-spec.md) or an [Exam](./exam-bundle-spec.md) that the user must complete to progress through the certification.

#### Gated Steps

Steps can optionally be marked as "gated". A gated step and all of its succeeding steps will be unavailable to the user until all preceding steps are completed.

For example, consider the following order of steps, where steps `C` and `E` are gated:

```
A -- B -- |C| -- D -- |E|
```

- At first, only `A` and `B` are available to the user.
- Once `A` and `B` are completed (in any order), `C` and `D` become available.
- Once `C` and `D` are completed (in any order), `E` becomes available.

#### Course Step Example

```yml
type: course_template
id: qwiklabs-test-content/my-cool-course
```

#### Exam Step Example

```yml
type: exam
id: qwiklabs-test-content/my-excellent-exam
gated: true
proctor: qwiklabs-live-plus
```

attribute          | required | type       | notes
-------------------| -------- | ---------- | -----------------------------------------
type               | ✓        | enum       | One of ["course_template", "exam"]
id                 | ✓        | string     | Unique identifier of this step's corresponding CourseTemplate or Exam
gated              |          | boolean    | Whether this step should be "gated" (see [Gated Steps](#gated-steps) above for details); `false` by default
proctor            |          | enum       | (exam steps only) Which service to use for proctoring this step's corresponding Exam. One of ["qwiklabs-live-plus", "qwiklabs-record-plus"]
