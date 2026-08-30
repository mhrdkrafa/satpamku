# Satpamku — DESIGN.md

## Design Workflow: Stitch First
The visual design must be explored in **Google Stitch first**. Stitch is used to establish visual direction, hierarchy, screens, spacing, color, typography, navigation, and component patterns. After approval, translate the result into Flutter Material 3 widgets and centralized design tokens.

## Stitch Master Prompt
> Design a modern Indonesian mobile job marketplace called “Satpamku”, specialized exclusively for security guards (satpam) and security recruitment.
>
> Create an original visual identity that feels professional, trustworthy, disciplined, modern, approachable, and employment-focused. Do not copy Jobstreet or any existing marketplace branding, layout, colors, or assets.
>
> Primary users: (1) security guards looking for jobs, (2) companies/recruiters hiring security guards.
>
> Design mobile-first for Flutter Material 3. Create screens: Splash, Onboarding, Login, Register Satpam, Register Employer, Home, Job Search, Filters, Search Results, Job Detail, Company Detail, Saved Jobs, Application Status, Application Detail, Candidate Profile, Edit Profile, Certifications, CV/Documents, Notifications, Candidate Dashboard, Employer Dashboard, Create Job, Job Management, Applicant List, Applicant Detail, Recruitment Pipeline, Messages, Settings.
>
> Home must include greeting, prominent job search, location selector, security job categories, recommended jobs, urgent hiring, verified employers, career resources, and CTA.
>
> Job cards must prioritize title, company, verification badge, location, salary, employment type, shift, experience, required certification, posting time, and save action.
>
> Job detail must prioritize employer verification, location, salary, shift, requirements, responsibilities, benefits, certifications, deadline, and a prominent Apply button.
>
> Candidate profile should resemble a professional security-guard CV, emphasizing experience, security roles, certifications, training, skills, availability, preferred location, and salary expectation.
>
> Employer dashboard should emphasize active vacancies, applications, shortlisted candidates, interviews, hires, and quick actions.
>
> Use a clean card-based interface, generous whitespace, strong hierarchy, accessible contrast, compact metadata chips, and clear primary CTAs. Use an original restrained professional palette with neutral surfaces and one accent. Light mode first. Avoid excessive gradients, glassmorphism, tiny text, and decorative noise.
>
> Include loading/skeleton, empty, error, verification, success, and validation states. Make components suitable for reusable Flutter widgets.

## Stitch Review Loop
First generate Home, Search Results, Job Detail, Candidate Profile, Application Tracking, and Employer Dashboard. Review hierarchy and consistency, then produce a second iteration before implementation.

## Flutter Tokens
Centralize `AppColors`, `AppTypography`, `AppSpacing`, `AppRadius`, `AppElevation`, and `AppMotion`. Never scatter hardcoded brand colors through widgets.

## Core Components
AppHeader, SearchBar, LocationSelector, JobCard, CompanyCard, CertificationBadge, VerificationBadge, SalaryText, FilterChip, JobFilterSheet, ApplicationStatusChip, ProfileCompletionCard, CertificationCard, ApplicantCard, RecruitmentStageCard, EmptyState, ErrorState, LoadingSkeleton, PrimaryButton, SecondaryButton, BottomNavigation.

## Candidate Navigation
Home / Jobs / Saved / Applications / Profile.

## Employer Navigation
Dashboard / Jobs / Applicants / Messages / Profile.

## UX Principles
Search is prominent; job cards are scannable; salary/location are easy to find; application status is obvious; certification status is understandable; verification is visually distinct; primary actions dominate secondary actions.

## Accessibility
Comfortable touch targets, readable text, sufficient contrast, screen-reader labels, status not communicated by color alone, reduced-motion support.

## CMS
Admin controls content, section visibility/order, banners, featured jobs, categories, and copy. Admin cannot control arbitrary Flutter layout/CSS.
