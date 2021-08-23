# Qwiklabs Resource Specification

Resources are additional materials that learners may refer to while taking a lab
or course.

We encourage content authors to use as few external links as possible. Qwiklabs
cannot guarantee that those links will be available when a learner takes your
lab or course. For instance, if you have a PDF that you wish to include, you
should add it as a file in this bundle instead of referencing it as a link to
Cloud Storage or S3.

For files larger than 50MB, please use an externally referenced resource. Your
entire content bundle should be less than 100MB.

> **Note**: If you are linking to an external resource that has its own
> understanding of source control, please link to the specific revision of that
> resource. That way, if the external resource is updated, your learners will
> not be affected. For example, if you are referencing a Github repo, include
> the link to a specific tag, instead of the default branch.
>
> Brittle: <https://github.com/CloudVLab/qwiklabs-lab-bundle-spec/>
>
> Better:
> <https://github.com/CloudVLab/qwiklabs-lab-bundle-spec/tree/v1-prerelease>

| attribute   | required | type       | notes                                  |
| ----------- | -------- | ---------- | -------------------------------------- |
| type        | ✓        | enum       | [See list of valid types below]        |
| id          |          | string     | Identifier that can be used throughout |
:             :          :            : project bundle                         :
| title       | ✓        | dictionary | Key is `locales` and each locale is a  |
:             :          :            : dictionary mapping locale codes to     :
:             :          :            : localized titles                       :
| description |          | dictionary | Key is `locales` and each locale is a  |
:             :          :            : dictionary mapping locale codes to     :
:             :          :            : localized descriptions                 :
| uri         |          | dictionary | Key is `locales` and each locale is a  |
:             :          :            : dictionary mapping locale codes to     :
:             :          :            : localized uris.                        :

## Videos

Videos have the following additional attributes:

| attribute      | required | type       | notes                               |
| -------------- | -------- | ---------- | ----------------------------------- |
| video_id       | ✓        | dictionary | Key is `locales` and each locale is |
:                :          :            : a dictionary mapping locale codes   :
:                :          :            : to localized video_ids.             :
| video_provider | ✓        | string     | The video provider.                 |
| duration       | ✓        | integer    | The duration of the video (in       |
:                :          :            : seconds).                           :

## Example

```yaml
resources:
  - type: link
    id: repo-link
    title:
      locales:
        en: Self-referential Github Repo
        es: Auto-referencial Github Repo
    uri:
      locales:
        en: https://github.com/CloudVLab/qwiklabs-lab-bundle-spec/tree/v1-prerelease
        es: https://github.com/CloudVLab/qwiklabs-lab-bundle-spec/tree/v1-prerelease
  - type: file
    title:
      locales:
        en: Sample PDF
        es: Ejemplo de PDF
    description:
      locales:
        en: This PDF contains all of the code samples for the lab.
        es: Este PDF contiene todos los ejemplos de código para el laboratorio.
    uri:
      locales:
        en: "./resources/sample-en.pdf"
        es: "./resources/sample-es.pdf"
  - type: video
    id: lab-video
    title:
      locales:
        en: Welcome to GCP!
        es: ¡Bienvenido a GCP!
    uri:
        locales:
          en: https://youtu.be/oHg5SJYRHA0
          es: https://youtu.be/7jjoyy7_RCk
    duration: 120
  - type: video
    id: course-video
    title:
      locales:
        en: Welcome to GCP!
        es: ¡Bienvenido a GCP!
    video_id:
        locales:
          en: oHg5SJYRHA0
          es: 7jjoyy7_RCk
    video_provider: YouTube
    duration: 360
```

## Valid types

-   `file` - A relative path to a file in the bundle
-   `link` - A url to an external resource
-   `video` - A link to a video outside of the bundle such as on Youtube

To prevent confusion, all resources must explicitly define what type they are.

> **Aside:** Why define external resources instead of putting links directly in
> lab instructions?
>
> 1.  You can reference your resource directly in your instructions and will be
>     displayed in a special format, depending on its type. For example, a
>     YouTube link will be displayed as an embedded widget.
>
> 2.  You can edit the resource in one location and every place it is referenced
>     will be updated (also across locales).
>
> 3.  In courses resources appear as standalone steps, which raises learners'
>     awareness of them.
