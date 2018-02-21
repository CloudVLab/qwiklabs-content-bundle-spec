# Qwiklabs Content Bundle Specs

This repo currently houses the specs for both lab bundles and quest bundles. Information about lab bundles can be found under `/labs` and information about quests can be found under `/quests`.

See [the spec](./lab-bundle-spec.md) for documentation on authoring [Qwiklabs](https://www.qwiklabs.com/) labs.

## Notable Files and Folders

* `/examples/`: A list of example bundles (of any type)
* `lab-bundle-spec.md`: A formal-ish specification for lab bundles
* `quest-bundle-spec.md`: A formal-ish specification for quest bundles
* `instruction-html-spec.md`: A document outlining what constitutes valid HTML in a content bundle (e.g. what is required, what is forbidden, etc.)

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
- type: code
  ref_id: code_repo
  locales:
    en:
      title: Self-referential Github Repo
      uri: https://github.com/CloudVLab/qwiklabs-lab-bundle-spec/tree/v1-prerelease
```

### Prefer explicit configuration over implicit convention

The only requirement we put on your bundle's file structure is the `qwiklabs.yaml` MUST be in the root folder of the bundle. You can arrange your other files in whatever folder structure you choose.

The lab definition in `qwiklabs.yaml` explicitly references files when specifying instructions, resources, etc. This makes static validation of your package easier and ensure that files you intended to be there aren't missing.

[TODO: Add Dave's example of forgetting to add a file to a git repo, thus loosing an entire locale]

### Schema versions

[TODO: Flesh out...]

- v1 the spec will evolve in an "additive" manner (e.g. new resource types)
- Breaking changes will result in a new version change.
- Older schema versions will be supported for a "reasonable" deprecation periods.
- The Qwiklabs team will try to create migration tools that make schema updates a mostly automated process
