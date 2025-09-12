# Frontend Mobile Preference Workflow: Plan

## Objectives
- Enable fully configurable preferences flow driven by JSON (steps/sections).
- Provide a lightweight Workflow Manager UI to edit and persist the flow.
- Prepare backend API surface to store/read workflow configs and user preferences as-is, plus parsed projection later.

## Scope (Phase 1)
- Use current config source in `PreferencesModel.rawJson['steps']` as single source of truth.
- Implement a Workflow Manager (3 files, minimal boilerplate):
  - `manager_ui.dart`: UI to list, add, remove, reorder steps/sections; basic form editors for section types/labels/sources/colors.
  - `manager_provider.dart`: in-memory state with load/save, validates minimal schema; plugs into `remoteItems.first.rawJson` for now.
  - `manager_data.dart`: abstraction for persistence; phase-1 uses fake repo/local storage; phase-2 switches to backend APIs.
- Refactor consumer screen (already done): `set_preferences_screen.dart` renders from config.

## Scope (Phase 2)
- Backend endpoints via OpenAPI package.
- Persist workflow config and user preferences to server.
- Introduce validation rules in config (e.g., required sections) and enforce in UI.

## Data Contracts (draft)
- Workflow Config (JSON)
  - `steps: Step[]`
  - `Step`: `{ type?: 'builtin', key?: 'job_titles'|'review', title: string, subtitle?: string, icon?: string, color?: number, sections?: Section[] }`
  - `Section`: one of
    - `multi_select`: `{ id: string, type: 'multi_select', title: string, source: string, color?: number }`
    - `single_select`: `{ id: string, type: 'single_select', title: string, source: string, color?: number }`
    - `salary_range`: `{ id: 'salary', type: 'salary_range', title: string, color?: number }`
    - `toggle`: `{ id: string, type: 'toggle', title: string, color?: number }`
- User Preferences (as-is payload, example)
  - `{ jobTitles: {id:number,title:string,priority:number}[], countries: string[], industries: string[], workLocations: string[], salaryRange: {min:number,max:number}, workCulture: string[], agencies: string[], companySize: string, shiftPreferences: string[], experienceLevel: string, trainingSupport: boolean, contractDuration: string, benefits: string[] }`

## Backend (Phase 2) – Draft Endpoints
- `GET /workflow/mobile-preferences` → Workflow Config JSON
- `PUT /workflow/mobile-preferences` → Save Workflow Config JSON
- `POST /candidates/:id/preferences/raw` → Save raw user preferences payload (as-is)
- `GET /candidates/:id/preferences/raw` → Fetch raw payload
- `GET /candidates/:id/preferences/parsed` → Fetch parsed/normalized projection (Phase 3)

## OpenAPI Integration
- Source: `dev_tools/package_form_open_api/input.yaml`
- Build: `dev_tools/package_form_open_api/build.sh`
- Artifact path used by Flutter: `dev_tools/package_form_open_api/openapi`
- Add above endpoints to OpenAPI to generate clients for Flutter and server typing.

## UI/UX for Workflow Manager (Phase 1)
- Steps list with drag-and-drop reorder, add built-in/config steps.
- Step editor: title, subtitle, icon dropdown, color picker.
- Sections list per step: add/remove/reorder; section editor for type, title, source, id, color.
- Save button writes to `remoteItems.first.rawJson['steps']` (temporary).

## Validation Rules (extendable)
- Unique `section.id` per step.
- `source` must resolve for select types.
- Built-in steps must keep keys: `job_titles`, `review`.

## Tasks
- Implement manager files (UI/provider/data) in a new folder: `features/presentation/preferences/workflow_manager/`.
- Wire temporary persistence to `remoteItems` until backend is ready.
- Add config validation and friendly error toasts.
- Add optional `required: true` in sections and enforce in `_isStepValid()` later.

## Milestones
- M1: Local manager edits config and updates live Preferences screen.
- M2: Backend APIs wired; config persisted to server.
- M3: Validation + parsed projection endpoint and UI consumption.
