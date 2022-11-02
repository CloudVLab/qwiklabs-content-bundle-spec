# Qwiklabs PeerAssignment Bundle Specification

**Version 1**

> This is a DRAFT document. We welcome feedback as this format evolves.

## `qwiklabs.yaml` Structure

Here's a sample `qwiklabs.yaml` file with all nested details removed to make it
easier to see the general file structure.

```yaml
entity_type: PeerAssignment
schema_version: 1

default_locale: en

title: Create storyboards for your portfolio project

# The primary instruction content for this peer assignment
instruction: ...

review_criteria: There are a total of 6 points for this activity. At least two of your peers will evaluate your project. Your final grade will be the median of these scores. You must get 5 out of 6 total points to pass.

prompts: ...

```

Note that all of the main chunks of localized content (title, review_criteria, text, stem and title) are HTML content that may be displayed in various contexts. All of these chunks will be sanitized according to the restricted set in the [HTML spec](./html/html-spec.md).

### Default Locale

The peer assignment bundle MUST specify a `default_locale`. It corresponds to the locale
that the peer assignment is originally authored in. Authoring tools can use this as a hint
to notify localizers when content in the default locale is updated. Also, it
provides a hint to the learner interface about which locale to display if an
instruction/resource is not localized for the learner's current locale.


Add an additional locale specific file of the form "qwiklabs.xx.yaml" for each
locale to be included. For example, Japanese entries would be in a file named
"qwiklabs.ja.yaml". Within a single piece of content, be sure to use consistent
`ids` across all the "qwiklabs.xx.yaml" files for data that contains lists of
objects.


### Attribute specification

The full specification is as follows:

attribute               | required | type       | notes
----------------------- | -------- | ---------- | -----
entity_type             | ✓        | string     | Must be `PeerAssignment`
schema_version          | ✓        | integer    |
default_locale          | ✓        | enum       | Must be a valid locale code
title                   | ✓        | string     | Unique PeerAssignment title that a student sees
instruction             | ✓        | dictionary | See [below](#Instruction)
review_criteria         | ✓        | string     |
prompts                 | ✓        | array      | See [below](#Prompts)
duration                | ✓        | integer    | The estimate time for student to submit their answer, in minutes.
objectives              |          | string     | PeerAssignment objectives
passing_score           |          | integer    | if none, default is 0



### Instruction

attribute | required | type              | notes
--------- | -------- | ----------------- | -----
type      | ✓        | enum              | [See list of valid types below]
uri       | ✓        | string            | Relative path to a file.

```yaml
instruction:
  type: html
  uri: instructions/en.html
```

#### Valid types


*   `html`
*   `pdf`
*   `md`

Markdown (MD) or HTML are the preferred formats for stored instructions. PDFs will be displayed
embedded in the learner interface, but will lack any navigation or interactive
functionality. 


### Prompts

A prompt defines what a learner needs to do to complete the activity, and have multiple rubrics to help the other learners work. The full
specification is as follows:

attribute            | required | type       | notes
-----------          | -------- | ---------- | -----------------------------------
id                   | ✓        | string     | A unique identifier for this module
stem                 | ✓        | string     | Prompt text
response_types       | ✓        | array      | Array of strings from "URL", "File upload", "Rich text"
rubrics              | ✓        | array      | See below

### Rubrics

Rubrics are used for peers to evaluate other learner submission. Rubrics are polymorphic - i.e. there are several different _rubric types_ that are defined slightly differently. `rubrics` is an array of dictionaries with appropriate attributes for the given `type`. The allowed values for `type` are:

*   `multiple-choice`
*   `true-false`
*   `ungraded-text`

#### multiple-choice Rubrics

A rubric that has multiple options and each option associate with points.

attribute | required | type       | notes
--------- | -------- | ---------- | -----
id        | ✓        | string     | A unique identifier for this rubric
type      | ✓        | string     | The rubric type, which is always `multiple-choice`
stem      | ✓        | string     | String that asks the question, such as "The email includes the subject line, greeting, body and closing?"
options   | ✓        | array      | An array of `options` (see below for details);

#### true-false Rubrics

A rubric that has two predefined options: true and false. Each option associate with points.

attribute     | required | type       | notes
---------     | -------- | ---------- | -----
id            | ✓        | string     | A unique identifier for this rubric
type          | ✓        | string     | The rubric type, which is always `true-false`
stem          | ✓        | string     | String that asks the question, such as "All parts of the big picture storyboard template are filled out."
true_points   | ✓        | integer    | Usually is 1
false_points  | ✓        | integer    | Usually is 0

#### ungraded-text Rubrics

A rubric that has a ungraded-text question. No matter what a learner answers, it doesnot graded.

attribute | required | type       | notes
--------- | -------- | ---------- | -----
id        | ✓        | string     | A unique identifier for this rubric
type      | ✓        | string     | The rubric type, which is always `ungraded-text`
stem      | ✓        | string     | String that asks the question, such as "Provide constructive feedback for your classmates on their submission."


### Option

`multiple-choice` has an `options` array which contains all of the options that the user may
choose from. Option is defined below:

attribute | required | type       | notes
--------- | -------- | ---------- | -----
id        | ✓        | string     | A unique ID for this Option
title     | ✓        | string     | The content of this option, such as "The email includes 2-3 of these elements."
points    | ✓        | integer    | 