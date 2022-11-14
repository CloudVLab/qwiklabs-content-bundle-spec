# Qwiklabs Quiz Bundle Specification

**Version 1**

> This is a DRAFT document. We welcome feedback as this format evolves.

## `qwiklabs.yaml` Structure

Here's a sample `qwiklabs.yaml` file with all nested details removed to make it
easier to see the general file structure.

```yaml
entity_type: Quiz
schema_version: 1

passing_percentage: 67
default_locale: en

items: ...
```

Note that all of the localized content (stem, option titles, rationales, etc)
are HTML content that may be displayed in various contexts. All of these chunks
will be sanitized according to the restricted set in the
[HTML spec](./html/html-spec.md).

### Quiz attributes

attribute          | required | type       | notes
------------------ | -------- | ---------- | -----
default_locale     | ✓        | string     | Corresponds to the locale that the quiz is authored in. Authoring tools can use this as a hint to notify localizers when content in the default locale is updated. Also, it provides a hint to the learner interface about which locale to display if an instruction/resource is not localized for the learner's current locale.
schema_version     | ✓        | integer    | Which version of the quiz bundle schema you are using
title              |          | dictionary | A locale dictionary of the quiz title, such as "My Awesome Quiz"
passing_percentage | ✓        | integer    | The threshold grade that a student needs to achieve in order to count as "passing" the quiz.
fixed_place        |          | boolean    | `true` if the items should be presented in a fixed order rather than shuffled (this is treated as `false` if it's missing).
duration           |          | integer    | The default time a student is allotted for the quiz, in minutes. If unspecified, the quiz will not be timed.
sections           |          | array      | An ordered array of `sections` (see [below for details](#sections)) in this quiz; not allowed if `items` are specified; required if `items` are unspecified.
items              |          | array      | An ordered array of `items` (see [below for details](#items)) in a default section of this quiz; not allowed if `sections` are specified; required if `sections` are unspecified.

### Sections

Sections are groupings of related quiz items. Can be used as item banks grouping
"equivalent" items.

```yaml
id: section-0
name: Networking
item_count: 2
items: ...
```

attribute  | required | type    | notes
---------- | -------- | ------- | -----
id         | ✓        | string  | A unique identifier for this section
name       |          | string  | A name for this section
item_count |          | integer | The number of items to select from this section when composing the quiz displayed to the student. Can be used to indicate the number of items to choose from an item bank. If unspecified, defaults to the total number of `items` specified below.
items      | ✓        | array   | An ordered array of `items` (see below for details) in this section

### Items

Items are polymorphic - i.e. there are several different _item types_ that are
defined slightly differently. `items` is an array of dictionaries with
appropriate attributes for the given `type`. The allowed values for `type` are:

*   `multiple-choice`
*   `multiple-select`
*   `true-false`
*   `reflective-text`
*   `match`

#### multiple-choice Items

A quiz item that has multiple options and one answer. One option is the
_answer_, and the rest are _distractors_. There must be exactly one answer.

attribute | required | type       | notes
--------- | -------- | ---------- | -----
id        | ✓        | string     | A unique identifier for this item
type      | ✓        | string     | The item type, which is always `multiple-choice`
stem      | ✓        | dictionary | A locale dictionary of the text that asks the question, such as "Which of the following is a color?"
options   | ✓        | array      | An array of `options` (see below for details); order does not matter

#### multiple-select Items

A quiz item that has multiple options, any number of which are answers. Correct
options are _answers_, and incorrect options are _distractors_.

attribute | required | type       | notes
--------- | -------- | ---------- | -----
id        | ✓        | string     | A unique identifier for this item
type      | ✓        | string     | The item type, which is always `multiple-select`
stem      | ✓        | dictionary | A locale dictionary for the text that asks the question, such as "Which of the following is a color?"
options   | ✓        | array      | An array of `options` (see below for details); order does not matter

#### true-false Items

A quiz item that has two predefined options: true and false. The correct option
(e.g. "True") is the answer and the other is the distractor.

attribute       | required | type       | notes
--------------- | -------- | ---------- | -----
id              | ✓        | string     | A unique identifier for this item
type            | ✓        | string     | The item type, which is always `true-false`
stem            | ✓        | dictionary | A locale dictionary of text that asks the question, such as "True or false: the world is round."
answer          | ✓        | boolean    | The correct answer. `true` for "True", `false` for "False"
true_rationale  | ✓        | dictionary | A locale dictionary for the text that explains why "True" is correct or incorrect
false_rationale | ✓        | dictionary | A locale dictionary for the text that explains why "False" is correct or incorrect

#### reflective-text

A quiz item that has a free-text question. No matter what a learner answers, it
will always be correct as long as the answer has more than five words.

attribute | required | type       | notes
--------- | -------- | ---------- | -----
id        | ✓        | string     | A unique identifier for this item
type      | ✓        | string     | The item type, which is always `reflective-text`
stem      | ✓        | dictionary | A locale dictionary for the text that asks the question, such as "What skills do you already have that can help you on your journey to becoming a UX designer?"
feedback  | ✓        | dictionary | A locale dictionary for the text that responses to the learner's written text, such as "Thank you for reflecting on the skills you bring to this certificate program."

#### match Items

A quiz item that has multiple stems with a "lead in" prompt. The correct option
for each matching stem is directly specified as the answer. A match item will be
scored based on correctly matching *all* the stems.

attribute | required | type       | notes
--------- | -------- | ---------- | -----
id        | ✓        | string     | A unique identifier for this item
type      | ✓        | string     | The item type, which is always `match`
lead_in   | ✓        | dictionary | A locale dictionary of text that provides a lead-in, such as "Can You Match the Capital City to the Correct US State?"
stems     | ✓        | array      | An array of `matching stems` (see below for details); order does not matter
options   | ✓        | array      | An array of `options` (see below for details); order does not matter

### matching Stems

Match items need an additional `stems` array which contains the question(s) for
which the user must provide the matching answer.

attribute | required | type       | notes
--------- | -------- | ---------- | -----
id        | ✓        | string     | A unique ID for this matching Stem
title     | ✓        | dictionary | A locale dictionary for the content of this stem, such as "Springfield"
answer    | ✓        | string     | ID for option that is the answer for this stem

### Option

`multiple-choice`, `multiple-select` and `match` items all have an `options`
array which contains all of the answer(s) and distractors that the user may
choose from. Options are defined for these item types below:

attribute | required | type       | notes
--------- | -------- | ---------- | -----
id        | ✓        | string     | A unique ID for this Option
title     | ✓        | dictionary | A locale dictionary for the content of this option, such as "Blue"
rationale | ✓        | dictionary | A locale dictionary for an explanation of why this option is correct or incorrect (optional for `match` type)
is_answer | ✓        | boolean    | `true` if this option is an answer, and `false` if it is a distractor (unused for `match` type)
fixedPlace |          | boolean    | `true` if this option should be fixed in place when shuffling the answer (this is treated as `false` if it's missing)
