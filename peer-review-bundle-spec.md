# Qwiklabs PeerReview Bundle Specification

**Version 1**

> This is a DRAFT document. We welcome feedback as this format evolves.

## `qwiklabs.yaml` Structure

Here's a sample `qwiklabs.yaml` file with all nested details removed to make it
easier to see the general file structure.

```yaml
entity_type: PeerReview
schema_version: 1

default_locale: en

title:
  locales:
    en: Create storyboards for your portfolio project

# The primary instruction content for this peer review
instruction: ...

review_criteria:
  locales:
    en: |
      There are a total of 6 points for this activity. At least two of your peers will evaluate your project. Your final grade will be the median of these scores. You must get 5 out of 6 total points to pass.

prompts: ...

```

Note that all of the main chunks of localized content (title, review_criteria, text, stem and title) are HTML content that may be displayed
in various contexts. All of these chunks will be sanitized according to the
restricted set in the [HTML spec](./html/html-spec.md).

### Attribute specification

The full specification is as follows:

attribute               | required | type       | notes
----------------------- | -------- | ---------- | -----
entity_type             | ✓        | string     | Must be `PeerReview`
schema_version          | ✓        | integer    |
default_locale          | ✓        | enum       | Must be a valid locale code
title                   | ✓        | dictionary | A locale dictionary of titles
instruction             | ✓        | dictionary | See [below](#Instruction)
review_criterial        | ✓        | dictionary | A locale dictionary of review criterial
prompts                 | ✓        | array      | See [below](#Prompts)
objectives              |          | dictionary | A locale dictionary of objectives
duration                |          | integer    | The estimate time for student to submit their answer, in minutes. If unspecified, the peer review will not be timed.




### Instruction

attribute | required | type              | notes
--------- | -------- | ----------------- | -----
type      | ✓        | enum              | [See list of valid types below]
uri       | ✓        | locale dictionary | Within the locale dictionary, the values are paths to files in the bundle.

```yaml
instruction:
  type: html
  uri:
    locales:
      en: instructions/en.html
      es: instructions/es.html
```

#### Valid types


*   `html`
*   `pdf`


HTML is the preferred format for stored instructions. PDFs will be displayed
embedded in the learner interface, but will lack any navigation or interactive
functionality. 


### Prompts

A prompts defines what a learner needs to do to complete the activity, and have multiple rubrics to help the other leaners work. The full
specification is as follows:

attribute            | required | type       | notes
-----------          | -------- | ---------- | -----------------------------------
id                   | ✓        | string     | A unique identifier for this module
text                 | ✓        | dictionary | A locale dictionary of text
response_types       |          | array      | Array of strings from "URL", "File upload", "Rich text"
rubrics              | ✓        | array      | See below

### Rubrics

Rubrics are used for peers to evaluate other learner submission. Rubrics are polymorphic - i.e. there are several different _rubric types_ that are
defined slightly differently. `rubrics` is an array of dictionaries with
appropriate attributes for the given `type`. The allowed values for `type` are:

*   `multiple-choice`
*   `true-false`
*   `ungraded-text`

#### multiple-choice Rubrics

A rubric that has multiple options and each option associate with points.

attribute | required | type       | notes
--------- | -------- | ---------- | -----
id        | ✓        | string     | A unique identifier for this rubric
type      | ✓        | string     | The rubric type, which is always `multiple-choice`
stem      | ✓        | dictionary | A locale dictionary of the text that asks the question, such as "The email includes the subject line, greeting, body and closing?"
options   | ✓        | array      | An array of `options` (see below for details);

#### true-false Rubrics

A rubric that has two predefined options: true and false. Each option associate with points.

attribute     | required | type       | notes
---------     | -------- | ---------- | -----
id            | ✓        | string     | A unique identifier for this rubric
type          | ✓        | string     | The rubric type, which is always `true-false`
stem          | ✓        | dictionary | A locale dictionary of the text that asks the question, such as "All parts of the big picture storyboard template are filled out."
true_points   | ✓        | integer    | Usually is 1
false_points  | ✓        | integer    | Usually is 0

#### ungraded-text Rubrics

A rubric that has a ungraded-text question. No matter what a learner answers, it doesnot graded.

attribute | required | type       | notes
--------- | -------- | ---------- | -----
id        | ✓        | string     | A unique identifier for this rubric
type      | ✓        | string     | The rubric type, which is always `ungraded-text`
stem      | ✓        | dictionary | A locale dictionary for the text that asks the question, such as "Provide constructive feedback for your classmates on their submission."


### Option

`multiple-choice` has an `options` array which contains all of the options that the user may
choose from. Option are defined below:

attribute | required | type       | notes
--------- | -------- | ---------- | -----
id        | ✓        | string     | A unique ID for this Option
title     | ✓        | dictionary | A locale dictionary for the content of this option, such as "The email includes 2-3 of these elements."
points    | ✓        | integer    | 
