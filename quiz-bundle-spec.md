# Qwiklabs Quiz Bundle Specification

**Version 1**

> This is a DRAFT document. We welcome feedback as this format evolves.

## `qwiklabs.yaml` Structure

Here's a sample `qwiklabs.yaml` file with all nested details removed to make it easier to see the general file structure.

```yml
entity_type: Quiz
schema_version: 1

# The authoring title of the quiz - not visible to learners.
title: Super Hard Quiz

# The threshold grade that a student needs to achieve in order to count as "passing" the quiz.
passing_percentage: 67

# The "items" (i.e. questions) contained in this quiz.
items: ...
```

Note that all of the localized content (stem, option titles, rationales, etc) are HTML content that may be displayed in various contexts. All of these chunks will be sanitized according to the restricted set in the [HTML spec](./html-spec.md).

### Items
Items are polymorphic - i.e. there are several different _item types_ that are defined slightly differently. `items` is an array of items defined correctly for their type as defined by the `type` attribute. The allowed values for `type` are:
- `multiple-choice`
- `multiple-select`
- `true-false`

#### Multiple Choice Items

A quiz item that has multiple options and one answer. One option is the _answer_, and the rest are _distractors_.

attribute               | required | type              | notes
----------------------- | -------- | ----------------- | -----------------------------------------
id                      | ✓        | string            | A unique identifier for this item
type                    | ✓        | string            | The item type, which is always 'multiple-choice'
stem                    | ✓        | dictionary        | A locale dictionary of the text that asks the question, such as "Which of the following is a color?"
options                 | ✓        | array             | An array of item options
-- id                   | ✓        | string            | A unique ID for this item option
-- title                | ✓        | dictionary        | A locale dictionary of locales for the content of this option, such as "Blue"
-- rationale            | ✓        | dictionary        | A locale dictionary of locales for an explanation of why this option is correct or incorrect
-- is_answer            | ✓        | boolean           | `true` if this option is an answer, and `false` if it is a distractor

#### Multiple Select Items

A quiz item that has multiple options and multiple answers. Correct options are _answers_, and incorrect options are _distractors_.

attribute               | required | type              | notes
----------------------- | -------- | ----------------- | -----------------------------------------
id                      | ✓        | string            | A unique identifier for this item
type                    | ✓        | 'multiple-select' | The item type, which is always 'multiple-select'
stem                    | ✓        | dictionary        | A locale dictionary of locales for the text that asks the question, such as "Which of the following is a color?"
options                 | ✓        | array             | An array of item options
-- id                   | ✓        | string            | A unique ID for this item option
-- title                | ✓        | dictionary        | A locale dictionary of locales for the content of this option, such as "Blue"
-- rationale            | ✓        | dictionary        | A locale dictionary of locales for an explanation of why this option is correct or incorrect
-- is_answer            | ✓        | string            | Whether this option is an answer or distractor

#### True False Items

A quiz item that has two predefined options: true and false. The correct option (e.g. "True") is the answer and the other is the distractor.

attribute               | required | type              | notes
----------------------- | -------- | ----------------- | -----------------------------------------
id                      | ✓        | string            | A unique identifier for this item
type                    | ✓        | 'true-false'      | The item type, which is always 'true-false'
stem                    | ✓        | dictionary        | A locale dictionary of text that asks the question, such as "True or false: the world is round."
answer                  | ✓        | boolean           | The correct answer. `true` for "True", `false` for "False"
true_rationale          | ✓        | string            | Explains why "True" is correct or incorrect
false_rationale         | ✓        | string            | Explains why "False" is correct or incorrect
