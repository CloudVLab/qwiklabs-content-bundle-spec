# Qwiklabs Content Bundle Specs

This repo houses specs for Qwiklabs content bundles. Each supported bundle type has a set of examples and a type-specific bundle specification.

## Notable Files and Folders

* `/examples/`: A list of example bundles (of any type)
* `lab-bundle-spec.md`: A formal-ish specification for `Lab` bundles
* `course-template-bundle-spec.md`: A formal-ish specification for `CourseTemplate` bundles
* `html-spec.md`: A document outlining what constitutes valid HTML in a content bundle (e.g. what is required, what is forbidden, etc.)

## Introduction

A Qwiklabs Bundle, or QLB, is a zip file that contains exactly one directory. Inside of that directory is a `qwiklabs.yaml` file which defines a learning entity in Qwiklabs. All other files in the bundle should also be inside of the single parent directory. This specification focuses specifically on the Lab entity.

The QLB format aims to:

1. Make it easy to author developer learning materials in your native tools.

2. Provide a simple format into which existing content can be **programmatically** transformed, making it convenient to migrate existing learning materials from diverse sources into Qwiklabs modules.

> **Note**: The Lab bundle specification is designed for long term support (even as the spec evolves) and machine-to-machine communication. As such, this spec errs on the side of being overly verbose and comprehensive, which can make it more cumbersome to author directly in this format.
>
> A Lab bundle should be the **output** of the authoring process, and not necessarily written directly by authors. Qwiklabs will create authoring tools that make the authoring experience easier, including a GDoc conversion tool and a Git repo management service, all of which will produce lab bundles as their end product. Users are also encouraged to build their own authoring tools that target this spec.

## Design Goals

### Localization is a first class concern

We understand that not all instructional content is localized... but it should be! Furthermore, localization requires a lot of work, so we want to make it as easy as possible to add localized content to a lab bundle.

Therefore, QLB will prioritize explicit and clear localization semantics at the risk of being overly verbose for authors who only work with one locale.

For instance, `locales` is a required field for external resources. If you only have one locale you still need to specify it:

```yml
- type: link
  ref_id: my-repo
  uri:
    locales:
      en: https://github.com/CloudVLab/qwiklabs-lab-bundle-spec/tree/v1-prerelease
  title:
    locales:
      en: Self-referential Github Repo
```

### Prefer explicit configuration over implicit convention

The only requirement we put on your bundle's file structure is the `qwiklabs.yaml` MUST be in the root folder of the bundle. You can arrange your other files in whatever folder structure you choose.

The lab definition in `qwiklabs.yaml` explicitly references files when specifying instructions, resources, etc. This makes static validation of your package easier and ensure that files you intended to be there aren't missing.


### Schema versions

The v1 spec will evolve in an additive manner. The spec is designed to easily accomodate new feature variants. In particular, content authors should expect:

- new external resource types (e.g. GitHub repos, YouTube videos, etc.),
- new environment resource types (e.g. GSuite domain, iPython notebook, etc.), and
- additional supported HTML components for instructions (e.g. inline quiz elements, embedded videos, etc.).

#### Breaking Changes

If a breaking change can not be avoided, a new schema version will be issued (i.e. v1 -> v2).

Older schema versions will be supported for a "reasonable" deprecation periods.

The Qwiklabs team will *try* to create migration tools that make schema updates a mostly automated process.
