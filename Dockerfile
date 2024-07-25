FROM python:3.9-slim AS builder

WORKDIR /md

COPY . /md

RUN pip install mkdocs mkdocs-material mkdocs-minify-plugin markdown-callouts mdx_gh_links mkdocs-click mkdocs-redirects mkdocs-autorefs mkdocs-literate-nav mkdocstrings[python]

RUN mkdocs build

FROM nginx:alpine

COPY --from=builder /md/site /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]