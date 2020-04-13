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

steps: ...
```

### Certification attributes

attribute          | required | type       | notes
-------------------| -------- | ---------- | -----------------------------------------
default_locale     | ✓        | string     | Corresponds to the locale that the certification is authored in. Authoring tools can use this as a hint to notify localizers when content in the default locale is updated. Also, it provides a hint to the learner interface about which locale to display if an instruction/resource is not localized for the learner's current locale.
schema_version     | ✓        | integer    | Which version of the certification bundle schema you are using
title              | ✓        | dictionary | A locale dictionary of the certification title, such as "Virtual Machines in GCP"
description        |          | dictionary | A locale dictionary of the certification description which describes the contents of the certification
steps              | ✓        | array      | An array of `steps` (see [Steps](#steps) below for details)

### Steps

A certification is composed of multiple `steps`. A step can be either a Course Template or an exam that the user must complete to progress through the certification.

#### Gated Steps

Steps can optionally be marked as "gated". A gated step will be unavailable to the user until all preceding steps are completed, and all succeeding steps will be unavailable to the user until the gated step is complete.

For example, consider the following order of steps, where steps `C` and `E` are gated:

```
A -- B -- |C| -- D -- |E|
```

- At first, only `A` and `B` are available to the user.
- Once `A` and `B` are completed (in any order), `C` becomes available.
- Once `C` is completed, `D` becomes available.
- Once `D` is completed, `E` becomes available.

#### Course Step Example

```yml
id: step-0
gated: false
step_type: course
course_template_id: my-cool-course
```

#### Exam Step Example

```yml
id: step-1
gated: true
step_type: exam
proctoring: ProctorU
exam_id: my-excellent-exam
```

attribute          | required | type       | notes
-------------------| -------- | ---------- | -----------------------------------------
id                 | ✓        | string     | A unique identifier for this step, to be consistent across revisions
gated              | ✓        | boolean    | Whether this step should be "gated" (see [Gated Steps](#gated-steps) above for details)
step_type          | ✓        | enum       | One of ["course", "exam"]
course_template_id | ✓*       | string     | (*course steps only) Unique identifier of this step's corresponding CourseTemplate
exam_id            | ✓*       | string     | (*exam steps only) Unique identifier of this step's corresponding Exam
proctoring         |          | enum       | (exam steps only) Which service to use for proctoring this step's corresponding Exam. One of ["ProctorU", ...TODO(shoffing)]
