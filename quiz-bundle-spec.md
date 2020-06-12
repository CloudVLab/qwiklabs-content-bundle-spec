# Qwiklabs Quiz Bundle Specification

**Version 1**

> This is a DRAFT document. We welcome feedback as this format evolves.

## `qwiklabs.yaml` Structure

Here's a sample `qwiklabs.yaml` file with all nested details removed to make it easier to see the general file structure.

```yml
entity_type: Quiz
schema_version: 1

passing_percentage: 67
default_locale: en

items: ...
```

Note that all of the localized content (stem, option titles, rationales, etc) are HTML content that may be displayed in various contexts. All of these chunks will be sanitized according to the restricted set in the [HTML spec](./html-spec.md).

### Quiz attributes

attribute          | required | type       | notes
-------------------| -------- | ---------- | -----------------------------------------
default_locale     | ✓        | string     | Corresponds to the locale that the quiz is authored in. Authoring tools can use this as a hint to notify localizers when content in the default locale is updated. Also, it provides a hint to the learner interface about which locale to display if an instruction/resource is not localized for the learner's current locale.
schema_version     | ✓        | integer    | Which version of the quiz bundle schema you are using
title              |          | dictionary | A locale dictionary of the quiz title, such as "My Awesome Quiz"
passing_percentage | ✓        | integer    | The threshold grade that a student needs to achieve in order to count as "passing" the quiz.
duration           |          | integer    | The default time a student is allotted for the quiz, in minutes. If unspecified, the quiz will not be timed.
items              | ✓        | array      | An ordered array of `items` (see below for details) in this quiz - items will appear to students in this order

### Items
Items are polymorphic - i.e. there are several different _item types_ that are defined slightly differently. `items` is an array of dictionaries with appropriate attributes for the given `type`. The allowed values for `type` are:
- `multiple-choice`
- `multiple-select`
- `true-false`
- `match`

#### multiple-choice Items

A quiz item that has multiple options and one answer. One option is the _answer_, and the rest are _distractors_. There must be exactly one answer.

attribute | required | type       | notes
----------| -------- | -----------| -----------------------------------------
id        | ✓        | string     | A unique identifier for this item
type      | ✓        | string     | The item type, which is always `multiple-choice`
stem      | ✓        | dictionary | A locale dictionary of the text that asks the question, such as "Which of the following is a color?"
options   | ✓        | array      | An array of `options` (see below for details); order does not matter

#### multiple-select Items

A quiz item that has multiple options, any number of which are answers. Correct options are _answers_, and incorrect options are _distractors_.

attribute | required | type       | notes
----------| -------- | -----------| -----------------------------------------
id        | ✓        | string     | A unique identifier for this item
type      | ✓        | string     | The item type, which is always `multiple-select`
stem      | ✓        | dictionary | A locale dictionary for the text that asks the question, such as "Which of the following is a color?"
options   | ✓        | array      | An array of `options` (see below for details); order does not matter

#### true-false Items

A quiz item that has two predefined options: true and false. The correct option (e.g. "True") is the answer and the other is the distractor.

attribute       | required | type       | notes
----------------| -------- | -----------| -----------------------------------------
id              | ✓        | string     | A unique identifier for this item
type            | ✓        | string     | The item type, which is always `true-false`
stem            | ✓        | dictionary  | A locale dictionary of text that asks the question, such as "True or false: the world is round."
answer          | ✓        | boolean     | The correct answer. `true` for "True", `false` for "False"
true_rationale  | ✓        | dictionary  | A locale dictionary for the text that explains why "True" is correct or incorrect
false_rationale | ✓        | dictionary  | A locale dictionary for the text that explains why "False" is correct or incorrect

#### match Items

A quiz item that has multiple stems with a "lead in" prompt. The correct option for each matching stem is directly specified as the answer. A match item
will be scored based on correctly matching *all* the stems.

attribute       | required | type       | notes
----------------| -------- | -----------| -----------------------------------------
id              | ✓        | string     | A unique identifier for this item
type            | ✓        | string     | The item type, which is always `match`
lead_in         | ✓        | dictionary  | A locale dictionary of text that provides a lead-in, such as "Can You Match the Capital City to the Correct US State?"
stems           | ✓        | array      | An array of `matching stems` (see below for details); order does not matter
options         | ✓        | array      | An array of `options` (see below for details); order does not matter

### matching Stems

Match items need an additional `stems` array which contains the question(s) for which the user must provide the matching answer.

attribute    | required | type       | notes
-------------| -------- | -----------| -----------------------------------------
id        | ✓        | string     | A unique ID for this matching Stem
title     | ✓        | dictionary | A locale dictionary for the content of this stem, such as "Springfield"
answer    | ✓        | string     | ID for option that is the answer for this stem

### Option

`multiple-choice`, `multiple-select` and `match` items all have an `options` array which contains all of the answer(s) and distractors that the user may choose from. Options are defined for these item types below:

attribute    | required | type       | notes
-------------| -------- | -----------| -----------------------------------------
id        | ✓        | string     | A unique ID for this Option
title     | ✓        | dictionary | A locale dictionary for the content of this option, such as "Blue"
rationale | ✓        | dictionary | A locale dictionary for an explanation of why this option is correct or incorrect (optional for `match` type)
is_answer | ✓        | boolean    | `true` if this option is an answer, and `false` if it is a distractor (unused for `match` type)
