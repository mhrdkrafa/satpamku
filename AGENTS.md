# Satpamku — AGENTS.md

## Identity
Satpamku is an original Indonesian security-guard employment marketplace. Job marketplaces are feature references only; never copy branding, text, assets, source code, proprietary terminology, or exact UI.

## Stack
- Flutter + Dart
- Riverpod
- GoRouter
- Dio
- Freezed/json_serializable
- flutter_secure_storage
- Firebase Cloud Messaging
- Laravel 13 / PHP 8.2+
- Laravel Sanctum, Eloquent, API Resources, Form Requests
- Filament 5
- MySQL 8+
- Redis, queues, scheduler
- S3-compatible storage
- Pest + Flutter tests

## Agent Rules
1. Read PRD, ARCHITECTURE, SCHEMA, DESIGN, RULES before major work.
2. Follow TASK order unless explicitly changed.
3. Flutter never connects directly to MySQL.
4. Authorization is enforced by Laravel, not only Flutter.
5. Never trust client salary, job, eligibility, or application state.
6. Use Policies for protected resources.
7. Every schema change requires a migration.
8. Critical application workflows require tests.
9. Keep API/business logic out of Flutter widgets.
10. Use repositories and ViewModels/Notifiers for data/state.
11. Store tokens securely.
12. Validate CV/certificate uploads server-side.
13. Private candidate documents require authorization.
14. Use queues for notifications, document processing, and heavy jobs.
15. Paginate jobs, applications, candidates, notifications, and admin tables.
16. CMS controls content and controlled section composition; code controls component design.
17. Never create an arbitrary Flutter/CSS page builder for admins.
18. Update documentation when architecture, schema, API, or workflow changes.

## CMS Boundary
Admin controls branding, homepage content, banners, featured jobs, categories, locations, articles, employer content, notification templates, legal content, feature visibility, and section ordering. Code controls Flutter components, typography, spacing, navigation, accessibility, and animations.

## Definition of Done
Feature works, is authorized and validated, has API contract, handles loading/error/empty states, is responsive, tested, migrated/seeded, and documented when necessary.
