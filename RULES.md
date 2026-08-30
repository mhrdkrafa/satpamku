# Satpamku — RULES.md

## Product
1. Satpamku is specialized for security-guard recruitment.
2. Reference job platforms are feature inspiration only.
3. Never copy Jobstreet branding, UI, content, or assets.
4. Published jobs require an authorized employer and moderation rules.
5. Closed/expired jobs cannot receive applications.
6. Candidate cannot apply to the same job twice.
7. Application status changes are auditable.
8. Employers only access applicants for their own jobs.
9. Private candidate documents require authorization.
10. Candidate visibility settings must be respected.
11. Certification verification is server-controlled.

## Security
12. Flutter never connects directly to MySQL.
13. Production API uses HTTPS.
14. Use Sanctum for authentication.
15. Store tokens securely.
16. Validate uploads server-side.
17. Private documents never use permanent public URLs.
18. Rate-limit authentication/sensitive endpoints.
19. Never expose secrets in logs.
20. Sanitize rich text and escape output.
21. Use Policies and audit logs.

## API
22. Version APIs.
23. Use consistent JSON responses.
24. Paginate collections.
25. Validate requests.
26. Never trust client salary/job/application state.
27. Use API Resources to shape responses.
28. Do not return private fields by default.

## Flutter
29. No API calls directly in widgets.
30. No business logic in UI widgets.
31. Use Riverpod for app/shared state.
32. Use repositories for data access.
33. Use typed models.
34. Handle loading/error/empty/success states.
35. Keep feature code modular.
36. Centralize design tokens.
37. Reuse widgets.
38. Do not hardcode CMS content.

## CMS
39. Homepage section types are allowlisted.
40. Admin can reorder/enable/disable sections.
41. Admin can edit content/media.
42. Admin cannot inject Dart/Flutter code.
43. Admin cannot arbitrarily edit CSS-like values.

## Testing
44. Test job publishing.
45. Test application uniqueness.
46. Test application authorization.
47. Test private document authorization.
48. Test certification verification.
49. Test API validation.
50. Test critical Flutter states.
