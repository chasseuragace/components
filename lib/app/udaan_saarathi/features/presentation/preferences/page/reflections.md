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
- ✅ **COMPLETED**: Implement proper data provider pattern for preferences configuration
- ✅ **COMPLETED**: Add async state handling (loading/error/data) in UI
- Build the Workflow Manager (3 files: `manager_ui`, `manager_provider`, `manager_data`) with minimal boilerplate.
- Add optional `required` flags to sections and enforce in `_isStepValid()`.
- Prepare OpenAPI definitions and stubs for:
  - `GET/PUT /workflow/mobile-preferences`
  - `POST/GET /candidates/:id/preferences/raw`
- Unify option sources behind a single data access layer.


                
## Architecture Decision: Data Flow Pattern

### Problem Identified
- Direct coupling between UI (`set_preferences_screen.dart`) and fake repository data (`remoteItems`)
- No proper async state handling (loading/error states)
- Violation of separation of concerns

### Solution Implemented
Created a proper provider-based data flow:

```dart
// New provider layer
preferencesConfigProvider -> FutureProvider<PreferencesEntity?>
stepsConfigProvider -> Provider<AsyncValue<List<Map<String, dynamic>>>>
```

### Key Benefits
1. **Proper Separation**: UI no longer directly accesses repository data
2. **Async State Handling**: UI properly handles loading, error, and data states
3. **Retry Capability**: Users can retry on errors
4. **Testability**: Providers can be easily mocked for testing
5. **Future-Proof**: Easy to swap fake repository with real API calls

### Implementation Details
- UI uses `ref.watch(stepsConfigProvider)` with `.when()` pattern
- Loading state shows spinner with message
- Error state shows retry button
- Data state renders the normal UI flow
- All step navigation methods now handle async data properly

### Why This Approach?
You were right to question the direct `remoteItems` access. The provider pattern with UI-level async handling is the correct approach because:
- UI can provide immediate feedback (loading spinners, error messages)
- Users can take action (retry button)
- Clear separation between data layer and presentation layer
- Follows Flutter/Riverpod best practices
        