# Famix-CallGraph-Contextualizer

**Inject dynamic execution context into static architectures.**

This project bridges the gap between static analysis and runtime reality. It maps execution traces (derived from [`Famix-JavaTrace`](https://github.com/moosetechnology/Famix-CallGraphs-Contextualizer)) onto static call graphs ([`Famix-CallGraphs`](https://github.com/moosetechnology/Famix-CallGraphs)), allowing you to visualize not just what *can* happen, but what *actually* happened during a specific scenario.

## Installation

Install the project in your Moose image via Metacello:

```smalltalk
Metacello new
    baseline: 'FamixCallGraphsContextualizer';
    githubUser: 'LeoDefossez' project: 'Famix-CallGraphs-Contextualizer' commitish: 'master' path: 'src';
    load
```

## Workflow & Usage

Contextualization is a three-step process: **Extract, Load, Apply.**

### 1. Extract the Call Stack
You must first generate a trace from the target application. Use the external extractor:
* [JavaTraceExtractor](https://github.com/moosetechnology/JavaTraceExtractor) 

### 2. Prepare the Models
You need to load your models and build the static call graph before applying the context.

Here an exemple as how you can do import theses informations :

```
"## Variables to define"
origin := '/Users/.../.../Models/' asFileReference. 
appPath := origin / 'App'.
libraryPath := origin / 'Library'.
stackPath := origin / 'JDIOutput.cs'

"## Import models"
appModel := (FamixJavaFoldersImporter importFolder: appPath) first.
libraryModel := (FamixJavaFoldersImporter importFolder: libraryPath) first.
stackModel := CallStackJsonReader import: stackPath.
```

### 3. Contextualize the Graph

Once you have your models, you just need to build your graph and apply your call stack on it

```

"1. Choose a contextualizer and give it theses informations"
contextualizer := aContextualizerClass new
		  mainModel: appModel;
		  librariesModels: {libraryModel};
		  entryPoints: { aFamixMethod }; "Entry point need to be a method of the appModel"
		  callStackModels: { stackModel }.

"2. Run the contextualization, and if needed collect the graph created"
contextualizer run.
graph := contextualizer graph.

"3. Check all nodes with additionnals properties"
graph allNodesWithAdditionalProperties
```

## Documentation

* [User Documentation](resources/documentation/UserDocumentation.md)
