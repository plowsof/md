FROM python:3.9-slim AS builder

WORKDIR /md

# Set build arguments and environment variables
ARG REPO_URL
ARG COOLIFY_BRANCH
ENV REPO_URL=${REPO_URL}
ENV COOLIFY_BRANCH=${COOLIFY_BRANCH}

COPY . /md

RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Initialize a new Git repository
RUN git init

# Set the remote repository using the environment variable
#RUN git remote add origin ${REPO_URL}
RUN git remote add origin https://github.com/plowsof/md.git

# Fetch the commit history and metadata
RUN git fetch --all

# Checkout the branch specified by COOLIFY_BRANCH
#RUN git checkout -f ${COOLIFY_BRANCH}
RUN git checkout -f latest_mkdocs_test

RUN pip install mkdocs mkdocs-minify-plugin markdown-callouts mdx_gh_links mkdocs-click mkdocs-redirects mkdocs-autorefs mkdocs-literate-nav mkdocstrings[python] mkdocs-git-committers-plugin-2 mkdocs-git-revision-date-localized-plugin

RUN pip install mkdocs-material==9.5.30

RUN mkdocs build

FROM nginx:alpine

COPY --from=builder /md/site /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]