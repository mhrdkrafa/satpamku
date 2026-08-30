# Satpamku — DATABASE.md

## Strategy
MySQL 8+, InnoDB, utf8mb4; Redis for cache/queues; Laravel migrations are the source of truth.

## Identity
users: id, name, email, phone, password, role, status, email_verified_at, timestamps, deleted_at.
user_profiles: id, user_id, avatar_path, bio, city, address nullable, date_of_birth nullable, profile_visibility, timestamps.
candidate_profiles: id, user_id, headline, summary, preferred_city_id, preferred_shift, preferred_employment_type, salary_min, salary_max, available_from, years_experience, verification_status, profile_completion, timestamps.
employer_profiles: id, user_id, company_name, slug, logo_path, description, industry, website, address, city_id, verification_status, timestamps, deleted_at.

## Taxonomy
locations: id, parent_id, name, slug, type, latitude nullable, longitude nullable, is_active, timestamps.
job_categories: id, name, slug, description, is_active, timestamps.
job_positions: id, category_id, name, slug, is_active, timestamps.
facilities: id, name, slug, type, is_active, timestamps.
skills: id, name, slug, timestamps.
certifications: id, name, slug, issuing_body, description, is_active, timestamps.

## Jobs
jobs: id, employer_id, category_id, position_id, title, slug, description, responsibilities, requirements, benefits, employment_type, shift_type, salary_min, salary_max, salary_period, city_id, address, latitude, longitude, vacancies, required_experience_years, education_requirement, status, verification_status, is_urgent, published_at, closes_at, timestamps, deleted_at.
job_certification: job_id, certification_id, is_required.
job_facility: job_id, facility_id.

## Candidate
experiences: id, candidate_id, employer_name, position, start_date, end_date nullable, description, is_current, timestamps.
candidate_skill: candidate_id, skill_id, level nullable.
candidate_certifications: id, candidate_id, certification_id, certificate_number nullable, issued_at nullable, expires_at nullable, document_path, verification_status, verified_by nullable, verified_at nullable, timestamps.
candidate_documents: id, candidate_id, type, title, path, verification_status, verified_by nullable, verified_at nullable, expires_at nullable, timestamps.

## Applications
applications: id, job_id, candidate_id, current_stage, cover_letter nullable, cv_document_id nullable, applied_at, withdrawn_at nullable, timestamps. Unique(job_id,candidate_id).
application_status_histories: id, application_id, from_stage nullable, to_stage, note nullable, changed_by, created_at.
saved_jobs: id, candidate_id, job_id, timestamps. Unique(candidate_id,job_id).

## CMS
homepage_sections: id, key, type, title nullable, subtitle nullable, config JSON nullable, is_enabled, sort_order, timestamps.
banners: id, title, subtitle, image_path, button_label, button_url, target_type, target_id, is_active, starts_at, ends_at, sort_order, timestamps.
articles: id, author_id, category_id nullable, title, slug, excerpt, body, featured_image_path, status, published_at, seo_title, seo_description, timestamps, deleted_at.
article_categories: id, name, slug, timestamps.
menus/menu_items: hierarchical CMS navigation.
website_settings: key, value, type, group, timestamps.

## Notifications
 device_tokens: id, user_id, token, platform, last_seen_at, timestamps.
notifications: Laravel notification storage or equivalent.

## Audit
reports: id, reporter_id nullable, target_type, target_id, reason, description, status, resolved_by nullable, resolved_at, timestamps.
audit_logs: id, user_id nullable, action, subject_type, subject_id, old_values JSON nullable, new_values JSON nullable, ip_address nullable, user_agent nullable, timestamps.

## Indexes
users(email); jobs(slug); jobs(status,published_at); jobs(city_id,status); jobs(category_id,status); applications(job_id,candidate_id) unique; applications(candidate_id,current_stage); saved_jobs(candidate_id,job_id) unique; candidate_certifications(candidate_id,verification_status); candidate_certifications(expires_at); locations(parent_id,name); articles(status,published_at).

## Privacy
Candidate CV/certificates are private files. Serve them through authorization-controlled endpoints or temporary signed URLs. Minimize sensitive personal data.
