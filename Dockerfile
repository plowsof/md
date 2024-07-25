FROM python:3.9-slim AS builder

WORKDIR /md

COPY . /md

RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

RUN pip install mkdocs mkdocs-minify-plugin markdown-callouts mdx_gh_links mkdocs-click mkdocs-redirects mkdocs-autorefs mkdocs-literate-nav mkdocstrings[python] mkdocs-git-authors-plugin  mkdocs-git-revision-date-localized-plugin

RUN pip install mkdocs-material==9.5.30

RUN mkdocs build

FROM nginx:alpine

COPY --from=builder /md/site /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]