# Task Platform — v2.0.0-vibe

A monorepo delivering a small, modern tasks platform:
- **Backend**: FastAPI, SQLite (async SQLAlchemy 2.0), modular routers, scheduler hooks.
- **Frontend**: FastHTML + Sakura CSS, HTMX-style interactions, PWA.
- **Worker**: Headless scheduler runner calling backend cron endpoints.
- **CI/CD**: Dockerfiles, Compose, GHCR workflows, Makefile helpers.
- **Tests**: Unit, integration, performance, stress.

## Architecture & Principles

- **Clean modularity**: `/backend/app/routers` isolates each concern (tasks, categories, tags, attachments, relationships, views, notifications, config).
- **Storage**: SQLite file DB; attachments stored on disk under `backend/app/storage/`.
- **Runtime settings**: Single-row `AppSettings(id=1)` cached in memory and hot-reloaded on PATCH.
- **Notifications**: `Apprise` destinations from `AppSettings.apprise_urls`. Markdown templates in `NotificationTemplate` (`due_soon`, `overdue`).
- **Scheduler design**: Worker periodically calls `/api/notifications/cron` with mode `near_due` and `overdue`. Interval is fetched from `/api/config`.
- **Security**: Only SQLAlchemy ORM expressions are used (parameterized). No string-concatenated SQL.
- **Non-functional expectations**: lightweight (<200MB images), simple local dev, startup <3s on laptop, handles ~1k tasks comfortably.

## API Sketch

- `POST /api/tasks` — create
- `DELETE /api/tasks/{id}` — remove
- `POST /api/tasks/{id}/complete` — mark done
- `PATCH /api/tasks/{id}/description` — set description
- `PATCH /api/tasks/{id}/due` — set due date
- `POST /api/tasks/{id}/tags` — add tags
- `GET /api/tasks` — list/filter (`q`, `tag`, `overdue_only`, `category`, `status`)
- `GET /api/tasks/all` — list all/filter (same filters)
- `GET /api/tasks/search` — full-textish name/description search
- `GET /api/tasks/next` — next N hours/days window (`hours` | `days`)
- `POST /api/categories` / `GET /api/categories`
- `GET /api/categories/{id}/tasks`
- `POST /api/tags` / `GET /api/tags`
- `GET /api/tags/{id}/tasks`
- `POST /api/relationships` (generic or dependency) / `GET /api/relationships?task_id=`
- `POST /api/tasks/{id}/attachments` (UploadFile) / `GET /api/tasks/{id}/attachments`
- `GET /api/views/categories-summary` / `status-summary` / `tags-summary`
- `POST /api/notifications/cron?mode=near_due|overdue|both`
- `POST /api/notifications/test`
- `GET /api/notifications/logs`
- `GET /api/notifications/templates/{key}` / `PATCH ...`
- `GET /api/config` / `PATCH /api/config`

See each router for details and Pydantic schemas.

## Frontend UX
- `/app` provides a shell with navigation.
- Pages: Home, Tasks, All Tasks, Categories, Tags, Next 48h, Notifications, Settings.
- Filters: text (`q`), tags, overdue toggle. Categories/Tags pages support name contains and show/hide completed.
- Settings lets you edit runtime settings and Markdown templates, plus fire manual triggers.

## Build & Run

```bash
make compose-up        # builds images & starts the stack
make bootstrap         # load sample data
make test              # run tests
make package           # build monorepo zip
```

## Images
- `backend`: `ghcr.io/OWNER/task-platform-backend:v2.0.0-vibe`
- `frontend`: `ghcr.io/OWNER/task-platform-frontend:v2.0.0-vibe`
- `worker`: `ghcr.io/OWNER/task-platform-worker:v2.0.0-vibe`

Replace `OWNER` in the GitHub Actions secrets.

## License
GPL-3.0-only. See `LICENSE`.
