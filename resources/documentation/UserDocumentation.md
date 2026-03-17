# Famix CallGraphs Contextualizer

## Testing Strategy
Test organization follows approach described in testing Famix CallGraphs, a blog post about this is [availaible here](https://modularmoose.org/blog/2025-10-08-testing-your-algo-on-a-java-project/).

### Regenerate call stack trace for tests
To regenerate test artifacts (e.g., `exampleN.cs`), use the **[JavaTraceExtractor](https://github.com/moosetechnology/JavaTraceExtractor)**.

**Workflow:**
1.  Clone/Setup `JavaTraceExtractor`.
2.  Use the configuration `configExampleXX.json` present on the folder `resources/JTEConfigurations`.
3.  Run the extractor and overwrite the target file.
