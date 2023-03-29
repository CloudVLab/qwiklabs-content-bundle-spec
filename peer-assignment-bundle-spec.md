# Qwiklabs Peer Assignment Bundle Specification

> **Version 1**

## `qwiklabs.yaml` Structure

Here's a sample `qwiklabs.yaml` file, with all nested details removed to make it
easier to see the general file structure.

```yaml
entity_type: PeerAssignment
schema_version: 1
default_locale: en

title: Create storyboards for your portfolio project

review_criteria: "There are a total of 6 points for this activity. At least two of your peers will evaluate your project. Your final grade will be the median of these scores. You must get 5 out of 6 total points to pass."

duration: 120

# The primary instruction content for this peer assignment
instruction: ...

prompts: ...

exemplars: ...
```

Note that all of the main chunks of localized content (title, review_criteria,
text, stem and title) are HTML content that may be displayed in various
contexts. All of these chunks will be sanitized according to the restricted set
in the HTML spec.

### Default Locale

The peer assignment bundle MUST specify a `default_locale`. It corresponds to
the locale that the peer assignment is originally authored in. Authoring tools
can use this as a hint to notify localizers when content in the default locale
is updated. Also, it provides a hint to the learner interface about which locale
to display if an instruction/resource is not localized for the learner's current
locale.


Add an additional locale specific file of the form "qwiklabs.xx.yaml" for each
locale to be included. For example, Japanese entries would be in a file named
"qwiklabs.ja.yaml". Within a single piece of content, be sure to use consistent
`ids` across all the "qwiklabs.xx.yaml" files for data that contains lists of
objects.


### Attribute specification

attribute              | required | type              | notes
---------------------- | -------- | ----------------- | -----
entity_type            | ✓        | string            | Must be `PeerAssignment`
schema_version         | ✓        | integer           |
default_locale         | ✓        | string            | Must be a valid locale code
instruction            | ✓        | locale dictionary |
title                  | ✓        | string            |
review_criteria        | ✓        | string            |
objectives             |          | string            | Objectives of the assignment
duration               | ✓        | integer           | Estimated amount of time it should take an average learner to complete the assignment (in minutes)
passing_score          |          | integer           | If none, default is 0
prompts                | ✓        | array             | See [below](#prompt)
exemplars              |          | array             | See [below](#exemplar)

### Instructions

Place your instruction files under "instructions" folder. Name of the file MUST
be same as the locale key.

Your folder structure may look like:
```
my-peer-assignment/instructions/en.md
my-peer-assignment/instructions/es.html
```
You can only have one file per locale.

attribute | required | type              | notes
--------- | -------- | ----------------- | -----
type      | ✓        | enum              | [See list of valid types below]
uri       | ✓        | string            | Relative path to a file

```yaml
instruction:
  type: html
  uri: instructions/en.html
```

#### Valid types


*   `html`
*   `pdf`
*   `md`



Markdown (MD) or HTML are the preferred formats for stored instructions. PDFs
will be displayed embedded in the learner interface, but will lack any
navigation or interactive functionality. 
##### Qwiklabs supported markup

There are benefits to formatting lab instructions as HTML.

*   Instruction styling will be updated automatically as the Qwiklabs interface
    evolves.
*   Qwiklabs will help users navigate within your instruction document with a
    table of contents or direct links. It will also remember the learner's
    location in the document if they leave the page.
*   Authors can specify interactive elements that will be displayed inline with
    your instructions in the learner's interface (quizzes, checkpoints, etc).

However, we will not accept arbitrary HTML. Your input will be heavily scrubbed.

*   Only a standard subset of HTML elements will be supported (`<h1>`, `<p>`,
    `<strong>`, etc). All other tags will be stripped out of displayed content.
*   All styling will be removed.
*   All scripting will be removed.

See the Instruction part of the [HTML spec](./html/html-spec.md) for details.

### Prompt

A prompt defines what a learner needs to do to complete the activity, and has rubric criteria to help the other learners evaluate. The full specification is as follows:

attribute      | required | type              | notes
-------------- | -------- | ----------------- | -----
id             | ✓        | string            | A unique identifier for this module
stem           | ✓        | string            | Prompt text
response_types | ✓        | enum   | One of: "url", "file_upload", "rich_text"
rubric_items   | ✓        | array  | Array of rubric items. See [below](#rubric_item)

Note: We do not allow more than 2 prompts in one peer assignment.

### Rubric Item

Rubric items are used for peers to evaluate other learner submission. Rubric items are polymorphic - i.e. there are several different types that are defined slightly differently. `rubric_items` is an array of dictionaries with appropriate attributes for the given type. The allowed values for `type` are:

* `multiple-choice`
* `true-false`
* `reflective-text`

#### multiple-choice Rubric Item

A rubric item that has multiple options, each associated with points.

attribute | required | type              | notes
--------- | -------- | ----------------- | -----
id        | ✓        | string            | A unique identifier for this item
type      | ✓        | enum              | The item type, which is always `multiple-choice`
stem      | ✓        | string            | e.g. _"The email includes the subject line, greeting, body, and closing."_
options   | ✓        | array             | Array of `options`. See [below](#option)

#### true-false Rubric Item

A rubric item that has two predefined options (true and false), each associated with points.

attribute    | required | type              | notes
------------ | -------- | ----------------- | -----
id           | ✓        | string            | A unique identifier for this item.
type         | ✓        | enum              | The item type, which is always `true-false`
stem         | ✓        | string            | e.g. _"All parts of the big picture storyboard template are filled out."_
true_points  | ✓        | integer           | Usually 1
false_points | ✓        | integer           | Usually 0

#### reflective-text Rubric Item

A rubric item that has an reflective text question, associated with no points.

attribute    | required | type              | notes
------------ | -------- | ----------------- | -----
id           | ✓        | string            | A unique identifier for this item.
type         | ✓        | enum              | The item type, which is always `reflective-text`
stem         | ✓        | string            | e.g. _"Provide constructive feedback for your classmates on their submission."_

### Option

`multiple-choice` contains an array of all the `options` that the user may choose from. The full specification is as follows:

attribute    | required | type              | notes
------------ | -------- | ----------------- | -----
id           | ✓        | string            | A unique identifier for this option.
title        | ✓        | string            | e.g. _"The email includes 2-3 of these elements."_
points       | ✓        | integer           |

### Exemplar

An exemplar is a sample answer for the prompts in this assignment:

attribute       | required | type              | notes
--------------  | -------- | ----------------- | -----
id              | ✓        | string            | A unique identifier for this examplar
prompt_responses| ✓        | array             | Array of prompt response. See [below](#prompt_response)


### Prompt Response

A prompt response is a sample answer for the prompt. The number of prompt
responses is the same as the number of prompts.

attribute      | required | type              | notes
-------------- | -------- | ----------------- | -----
id             | ✓        | string            | A unique identifier for this prompt response.
prompt_id      | ✓        | string            | Corresponding prompt id.
response_type  | ✓        | enum              | One of: "url", "rich_text"
response_content | ✓        | string            | url link or free text content
