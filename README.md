# dockerfile-mkdocs-pptrhtmltopdf

# Example

in mkdocs.yml

```yaml
extra_css:
  - extra.css
```

in src/extra.css

```css
body {
    font-family: "Noto Sans", "Noto Sans CJK JP", sans-serif;
}
```

Example: When compact style is suitable.

```css
@import url(//fonts.googleapis.com/earlyaccess/notosansjapanese.css);
body {
    font-family: "Noto Sans Japanese", "Noto Sans CJK JP", "Noto Sans", sans-serif;
}
p {
    font-size: small;
    text-indent: 1em;
}
.md-typeset p {
    font-size: small;
    margin-top: 0.25em;
    margin-bottom: 0em;
}
.md-typeset ol li, .md-typeset ul li {
    font-size: small;
    margin-bottom: 0.25em;
    line-height: 1.25em;
}
```

# Usage

## serve

```bash
docker run --rm -p 8000:8000 -v $(pwd):/mnt --name mkdocs-serve ghcr.io/netmarkjp/mkdocs-pptrhtmltopdf mkdocs serve
```

## build html and pdf

```bash
docker run --rm -v $(pwd):/mnt ghcr.io/netmarkjp/mkdocs-pptrhtmltopdf
```

=> `draft-html.zip` `draft.pdf` will generate.

# in GitLab CI

example of `.gitlab-ci.yml` is below.

```yaml
stages:
  - release
release:
  stage: release
  tags:
    - docker
  image: ghcr.io/netmarkjp/mkdocs-pptrhtmltopdf:latest
  script:
    - ./build.sh
  artifacts:
    paths:
      - draft.pdf
      - draft-html.zip
```

# in GitHub Actions

example of `.github/workflows/build.yml` is below.

```yaml
name: Build document

on:
  push:
    branches:
      - "*"

    # Publish `v1.2.3` tags as releases.
    tags:
      - v*

  # Run for any PRs.
  pull_request:

jobs:
  build:
    runs-on: ubuntu-latest
    if: github.event_name == 'push'

    steps:
      - uses: actions/checkout@v2

      - name: Build document
        run: docker run --rm -v $(pwd):/mnt ghcr.io/netmarkjp/mkdocs-pptrhtmltopdf:latest

      - uses: actions/upload-artifact@v2
        with:
          name: draft-files
          path: |
            draft.pdf
            draft-html.zip
```
