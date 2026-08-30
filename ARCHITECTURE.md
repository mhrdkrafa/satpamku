# Satpamku — ARCHITECTURE.md

## Recommended Stack
Flutter + Laravel REST API + MySQL + Filament. Flutter must never connect directly to MySQL.

```text
Flutter Mobile
     │ HTTPS/JSON
     ▼
Laravel 13 API
 ┌───┼───────────┐
Auth Domain     CMS
 │    │           │
 │  MySQL      Filament 5
 │    │
 └ Redis / Queue / Scheduler
      │
 FCM / Email / Object Storage
```

## Flutter Architecture
Follow a feature-first layered architecture:
```text
lib/
├── app/ (router, theme, config)
├── core/ (network, storage, errors, widgets, utils)
├── features/
│   ├── auth/
│   ├── jobs/
│   ├── candidate/
│   ├── employer/
│   ├── applications/
│   ├── notifications/
│   ├── saved_jobs/
│   └── cms/
└── main.dart
```

Recommended flow: Screen → Riverpod ViewModel/Notifier → Repository → Dio API client → Laravel API. Flutter's official architecture guidance recommends separation of UI and data layers and repositories/ViewModels for application data/state.

## State Management
Use Riverpod consistently. Widgets render state and send user intents; repositories perform data access; domain/business rules remain outside widgets.

## API
Version REST APIs under `/api/v1`: auth, jobs, candidates, employers, applications, notifications, cms. Use Sanctum, Form Requests, Policies, API Resources, pagination, and consistent JSON responses.

## Authentication
Flutter → Laravel auth → Sanctum token → flutter_secure_storage. Never store credentials or tokens in plain preferences.

## Admin
Filament `/admin`: dashboard, users, candidates, employers, jobs, applications, certifications, documents, locations, categories, CMS, notifications, reports, settings.

## CMS-driven UI
API can return `{type,title,is_enabled,sort_order,config}`. Flutter maps `type` only to approved widgets. Backend never sends executable UI code.

## Files
Public images can use optimized object storage/CDN. Candidate documents are private and authorization-controlled.

## Background Jobs
Email, FCM notifications, certificate-expiry reminders, image/document processing, recommendation refresh, analytics aggregation.

## Security
HTTPS, Sanctum, Policies, rate limiting, validation, private file authorization, audit logs, secret management, and no direct DB access from Flutter.

## Testing
Laravel: feature/unit/API authorization/workflow/document tests. Flutter: unit/widget/integration/repository tests.
