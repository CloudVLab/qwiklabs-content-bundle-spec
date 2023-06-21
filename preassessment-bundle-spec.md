# Preassessment Bundle Specification

This bundle specification is used to define pre-assessment labs and the
activities they test out of. A sample pre-assessment is provided below:

```
preassessment:
  id: gcp-spl-content/gsp610-fundamentals-of-cloud-logging
  equivalencies:
    - preassessment_step: 1
      tested_out_type: lab
      tested_out_id: advanced-gcp-task

    - preassessment_step: 2
      tested_out_type: video
      tested_out_id: storage-options
```

Pre-assessments are defined by a `preassessment` field, and contain the
following required attributes:

| attribute     | type   | notes                                               |
| ------------- | ------ | --------------------------------------------------- |
| id            | string | Reference to the unique identifier for the lab used as a pre-assessment - `library/slug` or `slug`. |
| equivalencies | array  | See [below](#equivalencies)                         |

## Equivalencies

The `equivalencies` field is an array that defines the content the
pre-assessment tests out of in terms of its assessment steps. Each entry in the
array contains the following required attributes:

| attribute          | type    | notes                                         |
| ------------------ | ------- | --------------------------------------------- |
| preassessment_step | integer | The step number of one of the pre-assessment lab's activity tracking steps, starting from 1. |
| tested_out_id      | string  | Reference to the unique identifier for the tested out activity - `library/slug` or `slug`. |
| tested_out_type    | string  | The type of the tested out activity - `lab`, `quiz`, `video`, or `document`(refers to both `link` and `file` activities). |

Pre-assessment bundle specifications also must adhere to the following rules:

*   The pre-assessment cannot test out itself.
*   `preassessment.equivalencies.tested_out_id` must refer to one of the
    activities in the underlying quest/course.
*   Duplicate equivalencies are not allowed. For example, the following would be
    invalid:

    ```
    - preassessment_step: 1
      tested_out_type: lab
      tested_out_id: slug1
    - preassessment_step: 1
      tested_out_type: lab
      tested_out_id: slug1
    ```
