# Reflections

## What changed in me (the Preferences flow DNA)
- I am now driven by a JSON configuration (`rawJson.steps`) instead of hardcoded steps.
- My UI renders dynamic steps/sections using existing composable widgets (`MultiSelectSection`, `SingleSelectSection`, `StepHeader`).
- I still keep key built-ins (`job_titles`, `review`) so core UX remains strong while everything else is configurable.

## Why this matters
- It aligns with the persona constraint: “no external API to control me unless via code/config,” yet still enables flexibility via JSON.
- It sets the foundation for a Workflow Manager that edits this JSON and, later, persists it on the server via OpenAPI.

## Learnings
- Separating “renderers” (section types) from “data” (config) makes the flow evolvable.
- Validation can also be configured (e.g., `required: true`) and enforced generically.
- Keeping a small set of built-ins preserves usability while enabling configuration elsewhere.

## Gaps and risks
- Duplicate option sources (local vs repository constants) can drift; these should be unified.
- Validation is permissive for now; we should gradually introduce schema and runtime checks.
- Backend contracts are not finalized; we will iterate OpenAPI as server endpoints mature.

## Next commitments
- Build the Workflow Manager (3 files: `manager_ui`, `manager_provider`, `manager_data`) with minimal boilerplate.
- Add optional `required` flags to sections and enforce in `_isStepValid()`.
- Prepare OpenAPI definitions and stubs for:
  - `GET/PUT /workflow/mobile-preferences`
  - `POST/GET /candidates/:id/preferences/raw`
- Unify option sources behind a single data access layer.
