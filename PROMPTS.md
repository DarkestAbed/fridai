# PROMPTS.md (v2.0.0-vibe)

This file mirrors the specification provided by the user to generate the platform.

## Backend
- FastAPI, modular routers: tasks, categories, tags, relationships, attachments, views, notifications, config
- SQLite with SQLAlchemy 2.0 async
- Single user (no auth)
- Models: Task, Category, Tag (M2M), Attachment, TaskRelationship, NotificationLog, NotificationTemplate, AppSettings(id=1)
- Endpoints:
  - Tasks: add, remove, complete, set description, set due date, add tags, list/filter, list all/filter, search, next N days
  - Categories/Tags: create/list; fetch tasks by category/tag
  - Relationships: generic + dependency
  - Attachments: add/list per task
  - Views: categories summary, status summary, tags summary
  - Notifications: near-due trigger, overdue trigger, test, logs, template get/patch
  - Config: GET current; PATCH updates AppSettings and hot-reloads runtime (timezone, theme, notifications_enabled, near_due_hours, scheduler_interval_seconds, apprise_urls)
- Scheduler: checks near-due and overdue; sends via Apprise; Markdown templates for due_soon/overdue with placeholders
- Security: only SQLAlchemy expressions (parameterized)

## Frontend (FastHTML + Sakura)
- FastHTML, using SakuraCSS
- Shell at `/app` (HTMX SPA-like)
- Pages in modular routes, using a clean architecture and modular approach
- Pages: Home, Tasks, All tasks, Categories, Tags, Next (48h), Notifications, Settings
- Filters: Tasks/All (`q`, `tag`, `overdue_only`), Categories/Tags (name contains + show/hide completed)
- Settings page: timezone, theme, notifications toggle, near_due window, scheduler interval, Apprise URLs; edit Markdown templates; manual triggers
- PWA: manifest + service worker

## Worker
- Separate scheduler runner container

## Tests
- Unit (models/templates), Integration (endpoints, search, SQLi safety), Performance (200 tasks), Stress (1000 tasks)

## Packaging & CI/CD
- Dockerfiles (backend + frontend + worker), docker-compose (app + worker), GHCR workflow building all images, local workflow building all images
- Makefile with most relevant action shortcuts, including packaging and building

## Other requirements
- Bootstrap script that provides a full data sample to the platform
- Write `README.md` files for each component, indicating purpose, usage, installation and considerations
- GPL-type, copyleft license included
- LangChain placeholder component (minimal setup)

## Delivery
- Monorepo ZIP (ID: v2.0.0-vibe)
- Complete breakdown included in root README.md
