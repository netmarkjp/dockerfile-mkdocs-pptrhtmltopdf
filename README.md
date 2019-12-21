# dockerfile-mkdocs-wkhtmltopdf

# Pre requirements

in mkdocs.yml

```yaml
extra_javascript:
  - extra.js
extra_css:
  - extra.css
```

in src/extra.js

```javascript
window.addEventListener('load', function(){window.status="ready"});
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
docker run --rm -p 8000:8000 -v $(pwd):/mnt --name mkdocs-serve netmarkjp/mkdocs-wkhtmltopdf mkdocs serve
```

## build html and pdf

```bash
docker run --rm -v $(pwd):/mnt netmarkjp/mkdocs-wkhtmltopdf
```

=> `draft-html.zip` `draft.pdf` will generate.

# in GitLab CI

example of .gitlab-ci.yml is below.

```yaml
stages:
  - release
release:
  stage: release
  tags:
    - docker
  image: netmarkjp/mkdocs-wkhtmltopdf:latest
  script:
    - ./build.sh
  artifacts:
    paths:
      - draft.pdf
      - draft-html.zip
```
