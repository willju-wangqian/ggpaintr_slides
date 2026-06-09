# ggpaintr defense talk

Slide deck (`slides.qmd`, Quarto isu-revealjs) for the ~1-hour ggpaintr portion of the PhD defense. Content is sourced from the manuscript at `~/Research/paintrPaper/manuscript/manuscript.Rnw`; live demos live in `demos/`.

## Language

**Interactive masking**:
The canonical name of the contribution — resolving a captured `ggplot2` expression against the live, changing state of a running Shiny session instead of a data frame handed over once.
_Avoid as headline term_: lazy-lazy evaluation (alias only — appears exactly twice: the title slide subtitle and once in Part 3 when "doubled laziness" is explained).

**Embellishment**:
Wrapping a value inside a `ggplot2` expression in a placeholder function (`ppVar(Sepal.Length)`); the identity in plain R, so the embellished formula still draws the original plot.

**Placeholder**:
A named slot in the formula that both declares a widget and names the position its value substitutes into; one of three roles — value, data consumer, data source.

**Formula**:
The single unquoted `ggplot2`/`dplyr`-style expression (string fallback allowed) that is the app's whole definition.

## Relationships

- A **formula** carries zero or more **placeholders**; each placeholder occurrence becomes exactly one widget.
- **Embellishment** is how a placeholder enters a formula; **interactive masking** is how its widget's value gets back in at draw time.

## Talk-design decisions (resolved 2026-06-09 grilling session)

1. **Audience/scope**: final defense; ~1 hour on ggpaintr alone; committee NOT assumed to have read the paper or to know ggplot2/Shiny beyond superficially.
2. **Concept-led**: the committee should leave believing the contribution is *interactive masking*; the package is the evidence.
3. **Concept entry point**: the former "Benefits of ggpaintr" slide (now "Why this works — one idea") states interactive masking in plain language right after the cost comparison; Part 3 restates it precisely after data masking is taught. The committee hears the claim three times at increasing depth (hook intuition → plain words → precise).
4. **Demos**: all four live (01 ggpcp, 02 iris ~1 min, 03 penguins workhorse, 05 multimodule/plotly), each short and scripted; all apps **pre-launched in browser tabs** before the talk — a demo is a tab switch, never a cold `runApp()`. Demos 01/02 intentionally run *before* ggpaintr is introduced (use-the-artifact-then-reveal-the-cost); deflect early code-panel questions with "I'll come back to that panel."
5. **Background calibration**: full lazy/tidy-eval vocabulary stays on the slides but demoted to `aside` reference blocks; the spoken explanation rides on one worked example (`aes(x = Sepal.Length)` — captured now, resolved later, inside the data frame).
6. **Opening**: hook slide pairs the `ptr_app()` code with the annotated iris-app screenshot ("this line becomes this app" in the first minute); no dissertation-framing slide needed here.
7. **Extensibility (Part 4)**: all four code slides kept; each presented as shape — one-sentence headline + `code-line-numbers` highlighting on the 2–3 lines that matter; never read code aloud.
8. **Ending**: LLM slide removed from Related Tools and folded into a new "Limitations & future work" slide (which also absorbed "What reproducibility does not cover"); the unevaluated-reliability point about the LLM helpers is stated upfront to pre-empt the question.
9. **Backup slides** (after References, uncounted): rlang internals deep-dive; `ppExpr` denylist mechanics.

## Flagged ambiguities

- "lazy-lazy evaluation" vs "interactive masking" were used interchangeably in early drafts — resolved: same concept, *interactive masking* is canonical in speech and on slides; *lazy-lazy* survives only as the title's alias.
