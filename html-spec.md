# HTML Specification

> **Note**: This is a very preliminary sketch of what the instruction format should look like. Feedback is appreciated.

Before rendering, Qwiklabs will aggressively sanitize the provided HTML.

- Remove all script tags.
- Remove all style tags.
- Remove all tags, classes, and attributes that are not white-listed.

The allowed tags, classes, and attributes depend on the context. We currently have two contexts: restricted, and instruction.

## Instruction HTML

### White-listed Tags

- h1, h2, h3, h4, h5, h6
- p
- div, span?
- b, i, em, strong, u
- img
- a
- aside
- button?
- ul, ol, li
- pre, code?
- blockquote


### Other semantic entities we need to support

- Code blocks
  - Console inputs
  - Console output
  - Code snippets (language specific syntax highlighting)
- Aside with different flavors, e.g. pleasant vs warning.
- Checkpoint interaction
- Interactive Questions (multiple choice, free response, etc)

## Features

- Automatic table of contents generation.
  - `<h1>` is the title of the document and will not be included in TOC.
  - `<h2>`s will be navigable links in the TOC.
- By not styling yourself, your instructions will not become outdated as the Qwiklabs learning interface changes.

## Open Questions?

- Should we implement the richer semantic features with white-listed classes/attributes, custom tags/attributes, or comment blocks?

  ```html
  <div class="checkpoint" data-checkpointId="step_1" />

  <div checkpoint-id="step_1" />

  <checkpoint id="step_1" />

  <!-- checkpoint: id="step_1" -->
  ```

## Restricted HTML

### White-listed Tags

- p
- em, strong
- a
- ul, ol, li

### White-listed attributes

- title
- href