---
name: bdocs-publishing
description: Publish and manage HTML documents on Base Docs (bdocs.cbhq.net). Use when the user asks to publish a report, upload an HTML document, push a notebook to bdocs, list their documents, check review comments, or update an existing document.
---

# Base Docs Publishing

## When to Use

Apply this skill when the user wants to:
- Publish an HTML report or notebook export to Base Docs
- Update an existing document with a new version
- List their published documents
- Read reviewer comments on a document

## Base URL

`https://bdocs.cbhq.net`

## Authentication

Base Docs uses an agentic auth flow. If no API key is stored locally, run this flow:

1. `POST /api/auth/agent/start` → returns `{ "agent_session_id": "...", "auth_url": "..." }`
2. Ask the user to open `auth_url` in their browser to sign in.
3. Poll `GET /api/auth/agent/poll?session={agent_session_id}` until `{ "status": "completed", "api_key": "bd_..." }`.
4. Store the API key locally for subsequent requests.

All authenticated endpoints require `Authorization: Bearer <API_KEY>`.

## API Reference

### Publish a new document

```
POST /api/docs
Content-Type: application/json

{
  "title": "My Document",
  "html_content": "<html>...</html>",
  "slug": "optional-custom-slug"
}
```

Response: `{ "id", "slug", "title", "version": 1, "version_id" }`

Viewable at `https://bdocs.cbhq.net/d/{slug || id}`.

### Update an existing document

```
PUT /api/docs/{id}
Content-Type: application/json

{
  "title": "Updated Title (optional)",
  "html_content": "<html>...</html>"
}
```

Response: `{ "id", "version": N, "version_id", "title" }`

### List documents

```
GET /api/docs
```

Add `?owner=me` with a Bearer token to list only your own documents.

### Read comments

```
GET /api/docs/{id}/versions/{version}/comments
```

- No authentication required.
- Use `latest` as `{version}` to get comments on the most recent version.
- Response: `{ "comments": [...] }`

Each comment includes: `id`, `parent_id` (non-null for replies), `body`, `resolved`, `author_name`, `author_address`, `anchor_value.selected_text`, `created_at`.

## Published Document Registry

The **"Published Documents" table in `README.md`** is the source of truth for
which local notebooks map to which bdocs URLs and slugs. Always read it before
publishing or updating.

## Dollar Signs in Notebook Markdown

The nbconvert HTML template loads MathJax with `inlineMath: [['$','$']]` and
`processEscapes: true`. A single-escaped `\$` in notebook markdown is consumed
by the markdown-to-HTML renderer and produces a bare `$` in the HTML, which
MathJax then interprets as an inline-math delimiter — eating the dollar sign.

**Fix:** double-escape dollar amounts in notebook markdown cells:

- Write `\\$100` in the markdown source (stored as `\\\\$100` in the `.ipynb` JSON).
- The markdown renderer produces `\$100` in HTML.
- MathJax sees the `\$` escape and renders a literal `$`.

This does **not** apply to code cells — only markdown cells. Code output is
wrapped in `<pre>` tags which MathJax skips.

## Typical Workflows

### Publish a new document

1. Generate the HTML (e.g. `make report-parking`)
2. Authenticate if needed (see Authentication above)
3. Read the HTML file contents
4. `POST /api/docs` with the HTML content and a descriptive title
5. Add a row to the Published Documents table in `README.md`
6. Return the published URL to the user

### Update an existing document after notebook changes

This is the most common flow — the user modifies a notebook and says
"generate the report" or "update the bdoc."

1. Read the Published Documents table in `README.md` to find the slug and make target
2. Run the corresponding `make` target to generate the HTML
3. Authenticate if needed
4. Read the generated HTML file
5. `PUT /api/docs/{slug}` with the updated HTML content
6. Return the new version URL to the user

Always check the README first. If the user references a bdocs URL or says
"update the bdoc," match it to a row in the table to find the local source,
make target, and slug.
