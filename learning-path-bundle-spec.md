# Qwiklabs LearningPath Bundle Specification

**Version 1**

> This is a DRAFT document. We welcome feedback as this format evolves.

## `qwiklabs.yaml` Structure

The `LearningPath` bundle specification exactly matches the
[CourseTemplate bundle spec](./course-template-bundle-spec.md), with the
following exceptions:

*   `entity_type` should be set to `LearningPath`.
*   `LearningPath` does not have a `max_hot_labs` field.
*   `LearningPath` can have a `resources` section.
*   `LearningPath` does not have an `instructor_resources` section.
*   `LearningPath` must have exactly 1 module.
*   `LearningPath` can contain a pre-assessment lab that allows learners to test
    out of the `LearningPath`'s learning activities depending on their
    performance in the pre-assessment. The pre-assessment is defined by a
    `preassessment` section and its bundle specification can be found
    [here](./preassessment-bundle-spec.md).
