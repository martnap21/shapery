# Mistakes and lessons

Record material mistakes factually. Include impact, correction, verification and prevention. Do not erase a failure merely because a later build passed.

## L001 — SpriteKit initializer missed an override

Date: 2026-10-31

- **Evidence:** The [initial CI run](https://github.com/martnap21/shapery/actions/runs/41227926414) passed eleven core tests but failed iOS compilation because `FactoryScene.init()` lacked `override`.
- **Impact:** The first bootstrap commit did not compile as an iOS application. No player release was made.
- **Cause:** The initializer declaration did not match its inherited API contract. Local structural checks could not detect that native compilation error.
- **Correction:** Added `override` in code commit `51ab65a87b879d969bae08dfe89cd38a2a5316fb`.
- **Verification:** [Follow-up CI](https://github.com/martnap21/shapery/actions/runs/41228098162) passed core tests, iOS Simulator compilation, project regeneration and property-list lint.
- **Prevention:** Require native compilation before declaring app code verified. Treat core tests and structural checks as distinct from app compilation. Where no local Xcode exists, inspect CI before reporting completion.
- **Remaining gap:** Successful compilation did not verify launch or interaction; these remain listed in [validation](VALIDATION.md).

## L002 — Acknowledged unseen project instructions too confidently

Date: 2026-10-31

- **Evidence:** In the project conversation, the assistant said it would follow updated instructions before their text was available.
- **Impact:** The response implied the update had been understood without verification.
- **Correction:** Clarified the limitation, requested the actual text, and then updated repository guidance after Martin supplied it.
- **Verification:** This documentation change explicitly incorporates prior planning, explanations and alternatives, safety review, testing, decision records and lessons.
- **Prevention:** State which instructions are visible. Do not claim to have read, understood or applied an unavailable update.
