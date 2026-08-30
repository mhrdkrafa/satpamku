# Satpamku — SCHEMA.md

## Relationship Map
```text
User
├── CandidateProfile
│   ├── Experiences
│   ├── Skills
│   ├── Certifications
│   └── Documents
└── EmployerProfile
    └── Jobs
        ├── Category / Position
        ├── Facilities
        ├── Required Certifications
        └── Applications
            ├── Candidate
            └── Status History

Homepage
└── Sections
    ├── Hero
    ├── Search
    ├── Featured Jobs
    ├── Categories
    ├── Employers
    └── Career Resources
```

## Statuses
User: candidate, employer, admin, super_admin.
Job: draft, pending_review, published, paused, closed, rejected, expired.
Verification: unverified, pending, verified, rejected.
Application: submitted, reviewed, shortlisted, interview, assessment, offer, hired, rejected, withdrawn.
Profile visibility: private, employers_only, public.
Certification: pending, verified, rejected, expired.

## Invariants
1. Candidate cannot apply to the same job twice.
2. Closed/expired jobs cannot accept applications.
3. Only authorized employers manage their jobs/applicants.
4. Private candidate documents require authorization.
5. Certification validity is server-controlled and expiry is respected.
6. Important application status changes are audited.
7. Published jobs must satisfy moderation rules.
8. Candidate visibility settings must be respected.

## Search Dimensions
Keyword, location, position, category, salary, employment type, shift, experience, education, certification, employer verification, urgent flag, published date.

## CMS Contract
`homepage_sections.type` is an allowlisted Flutter component key, e.g. `hero`, `job_search`, `featured_jobs`, `categories`, `verified_employers`, `career_articles`, `cta`. The backend supplies content/configuration; Flutter chooses the approved widget. Never execute UI code received from the API.
