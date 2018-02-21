# Qwiklabs Quest Bundle Specification

**Version 1**

> This is a DRAFT document. We welcome feedback as this format evolves.

## `qwiklabs.yaml` Structure

Here's a sample `qwiklabs.yaml` file with all nested details removed to make it easier to see the general file structure.

```yml
entity_type: Quest
schema_version: 1

# Quest Attributes
id: my-awesome-quest
default_locale: en

title:
  locales:
    en: Best Quest Ever

description:
  locales:
    en: I kid you not. It's the best quest ever!

objectives:
  locales:
    en: |
      <p>This course will teach people</p>
      <ul><li>The power of frienship</li></ul>

audience:
  locales:
    en: |
      <p>This course is intended for people who</p>
      <ul><li>Do not understand the power of frienship</li></ul>

prerequisites:
  locales:
    en: <p>A firm understanding of interpersonal interactions is recommended but not required.</p>

tags: [sample, life-changing, gcp]
logo: ./quest-logo.png

# Estimated time to take the quest, *in days*
duration: 1

# The important part of a quest which lists all of the
resources: ...
```

With the exception of `resources`, all of these fields are identical or analogous to lab bundles.

Note that all of the main chunks of localized content (title, description, objectives, audience, and prerequisites) are all HTML content that may be displayed in various ways. All of these chunks will be sanitized according to [instruction-html-spec.md](./instruction-html-spec.md)

### Resources

The meat of a quest is an ordered list of resources which define what a learner needs to do in order to a complete a quest. `resources` is defined exactly the same way in lab bundles with the addition that a lab can also be a resource to a quest bundle. Some valid resources include:

* `lab`
* `link`
* `video`

The overall format should look like:

```yml
resources:
  - type: lab
    ref_id: my-awesome-lab
  - type: link
    locales:
      en:
        uri: https://github.com/CloudVLab/qwiklabs-lab-bundle-spec
        title: Self-referencial Github Repo
  - type: file
    locales:
      en:
        title: Sample PDF
        description: This PDF contains all of the code samples for the lab
        uri: resources/sample-en.pdf
```

# TODO: How to fully qualify `ref_id` on labs?

Note that a lab cannot be defined inline within a `resources` list. It must be created independently and then referenced in a quest.

Also note that the order resources are listed defines the order the resources will be displayed to a learner.

## Extra Fields We're Considering

* Manual setup time estimates?
* Quest Type?
[
    [0] "Service Area",
    [1] "Use Case (Advanced)",
    [2] "Use Case (Experienced)",
    [3] "Use Case (Beginner)",
    [4] "Exam Prep",
    [5] "AWS for Windows"
]
* Optional learning steps?
* Badges?
* Subdomain filters?
* Where does LearningPathCollection fit in?

### ILT Course Bundle Considerations

* How to designate ILT vs. SPL?
* disable_fraud_protection: true?
* Trainer-only instructions/content?
* DRM?
