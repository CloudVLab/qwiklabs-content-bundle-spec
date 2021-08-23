# Qwiklabs GameTemplate Bundle Specification

**Version 1**

> This is a DRAFT document. We welcome feedback as this format evolves.

## `qwiklabs.yaml` Structure

The `GameTemplate` bundle specification exactly matches the
[CourseTemplate bundle spec](./course-template-bundle-spec.md), with the
following exceptions:

*   `entity_type` should be set to `GameTemplate`.
*   `GameTemplate` does not have a `max_hot_labs` field.
*   `GameTemplate` does not have an `instructor_resources` section.
