# Satpamku — Product Requirements Document

## Product
Satpamku is a specialized employment marketplace connecting security guards (satpam) with companies, security-service providers, property managers, and recruiters.

It adapts common job-marketplace patterns such as job search, candidate profiles, saved jobs, applications, employer profiles, notifications, recommendations, and career resources, but focuses only on security recruitment.

## Goals
- Make satpam vacancies easy to discover.
- Make candidate profiles relevant to security recruitment.
- Let employers publish/manage vacancies.
- Let candidates apply and track applications.
- Support certification/document verification.
- Give admins full control through a web dashboard.
- Allow homepage/content/design composition changes without a Flutter release.

## Roles
Guest; Satpam/Job Seeker; Employer/Recruiter; Security Company; Admin; Super Admin.

## Candidate Features
- Profile, experience, skills, certifications, training, preferred location/shift, salary expectation, availability.
- CV and certificate uploads.
- Profile visibility.
- Search/filter jobs.
- Save jobs.
- Apply and track application status.
- Notifications.
- Career resources.

## Employer Features
- Company profile and verification.
- Create/edit/publish/pause/close vacancies.
- Define salary, location, shift, experience, education, certification, benefits, vacancies, deadline.
- Applicant list and detail.
- Recruitment pipeline.
- Candidate status changes.
- Statistics.

## Job Search
Keyword, city/province/area, position, salary, employment type, experience, education, certification, shift, facilities/benefits, verified employer, urgent hiring, date. Sort by relevance, newest, salary, and distance where available.

## Application Stages
submitted → reviewed → shortlisted → interview → assessment → offer → hired, with rejected and withdrawn terminal states.

## Security-Specific Credentials
Support credentials such as Gada Pratama, Gada Madya, Gada Utama and other approved training/certifications. Store issuer, number where appropriate, issue/expiry dates, document, and verification status.

## Notifications
Application submitted/status changed, matching jobs, interview reminder, certification expiry, employer verification, and other admin-configured events. Firebase Cloud Messaging is the recommended push layer.

## CMS
Admin controls homepage sections: hero, search, featured jobs, categories, verified employers, career resources, CTA. Admin can enable/disable/reorder/edit content/media. Admin cannot inject arbitrary Dart or CSS.

## MVP Acceptance
Registration/login, candidate profile, uploads, employer profile, job publishing/moderation, search/filter/sort, saved jobs, applications, employer applicant management, status history, push notifications, CMS homepage, responsive/error/empty states, privacy and authorization tests.

## Non-goals for MVP
Payroll, HRIS, attendance/patrol management, native video interviews, complex recruitment billing, guaranteed employment.
