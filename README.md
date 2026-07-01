# Famix-CallGraph-Contextualizer

**Inject dynamic execution context into static architectures.**

This project bridges the gap between static analysis and runtime reality. It maps execution traces (derived from [`Famix-JavaTrace`](https://github.com/moosetechnology/Famix-CallGraphs-Contextualizer)) onto static call graphs ([`Famix-CallGraphs`](https://github.com/moosetechnology/Famix-CallGraphs)), allowing you to visualize not just what *can* happen, but what *actually* happened during a specific scenario.

## Installation

Install the project in your Moose image via Metacello:

```smalltalk
Metacello new
    baseline: 'FamixCallGraphsContextualizer';
    githubUser: 'moosetechnology' project: 'Famix-CallGraphs-Contextualizer' commitish: 'master' path: 'src';
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

```smalltalk
"## Variables to define"
origin := '/Users/.../.../Models/' asFileReference. "path to the sources"
appPath := origin / 'App'. "sources of the target application"
libraryPath := origin / 'Library'. "sources of the libraries used by the application"
jdkPath := origin / 'sourcesJDK'. "sources of the Jdk used by the application"
tracePath := origin / 'JDIOutput.tr' "serialized trace file"

"## Import models"
appModel := FamixJavaFoldersImporter importFolder: appPath.
libraryModel := FamixJavaFoldersImporter importFolder: libraryPath.
traceModel := JavaTraceJsonReader import: tracePath.
jdkModel := (FamixJavaFoldersImporter new
                    folders: { jdkPath };
                    jdkVersion: '1.7'; "version of the jdk to parse"
                    import) first.
```

### 3. Contextualize the Graph

Once you have your models, you just need to build your graph and apply your trace on it.

**First choose which contextualizer you want to use, depending on your needs**
|**Class**|**Matching type**|**Behavior**|
|---|---|---|
|CGStrictContextualizer| Infered |Stop the contextualization when nodes used in trace does not exists in the call graph |
|CGInferedContextualizer|Infered|Creates missing nodes using `famix-bridge`|
|CGInferedContextualizerReflectiveHook| Strict| Creates missing nodes using a hook offered by the `call-graph` contruction algoritm|

```smalltalk
"0. Find the entry point of the application"
entryVictimMethod := (appModel allModelMethods detect: [ :method |
                                          method mooseName includesSubstring: 'App.main' ]).

"1. Choose a contextualizer and give it theses informations"
contextualizer := aContextualizerClass new
		  mainModel: appModel;
		  librariesModels: {libraryModel . jdkModel};
		  entryPoints: { entryVictimMethod }; "Entry point need to be a method of the appModel"
		  tracesModels: { traceModel }.

"2. Run the contextualization, and if needed collect the graph created"
contextualizer run.
graph := contextualizer graph.

"3. Check all nodes with additionnals properties"
contextualizer tracedNodesPerTraceModel 
```


## Pattern finding
The class `CGPatternFinder` provides the core API for pattern detection and chaining within the call graph.

| **Method** | **Description** |
|---|---|
| `findAllPatterns` | Identifies all known patterns in the graph. |
| `find<Name>Pattern` | Identifies instances of a specific pattern (`<Name>`). |
| `findPatternChainIn:` | Finds all pattern chains in the graph (unlimited depth). |
| `findPatternChainIn:depth:` | Finds pattern chains up to a strictly defined maximum `depth`. |

## More documentation

* [User Documentation](resources/documentation/UserDocumentation.md)
