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

attribute          | required | type    | notes
-------------------| -------- | ------- | -----------------------------------------
default_locale     | ✓        | string  | Corresponds to the locale that the quiz is authored in. Authoring tools can use this as a hint to notify localizers when content in the default locale is updated. Also, it provides a hint to the learner interface about which locale to display if an instruction/resource is not localized for the learner's current locale.
schema_version     | ✓        | integer   | Which version of the quiz bundle schema you are using
passing_percentage | ✓        | integer | The threshold grade that a student needs to achieve in order to count as "passing" the quiz.
items              | ✓        | array   | An ordered array of `items` (see below for details) in this quiz - items will appear to students in this order

### Items
Items are polymorphic - i.e. there are several different _item types_ that are defined slightly differently. `items` is an array of dictionaries with appropriate attributes for the given `type`. The allowed values for `type` are:
- `multiple-choice`
- `multiple-select`
- `true-false`

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
true_rationale  | ✓        | dictionary  | Explains why "True" is correct or incorrect
false_rationale | ✓        | dictionary  | Explains why "False" is correct or incorrect

### Option

`multiple-choice` and `multiple-select` items both have an `options` array which contains all of the answer(s) and distractors that the user may choose from. Options are defined for both item types below:

attribute    | required | type       | notes
-------------| -------- | -----------| -----------------------------------------
id        | ✓        | string     | A unique ID for this Option
title     | ✓        | dictionary | A locale dictionary for the content of this option, such as "Blue"
rationale | ✓        | dictionary | A locale dictionary for an explanation of why this option is correct or incorrect
is_answer | ✓        | boolean    | `true` if this option is an answer, and `false` if it is a distractor
