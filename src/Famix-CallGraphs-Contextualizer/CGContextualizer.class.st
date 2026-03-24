"
I contextualize a static call graph (`FamixCallGraph`) using dynamic execution traces (`FamixCallStack`).

## Example
```
""returns all path of enriched nodes""
aContextualizerClass new
		  mainModel: mainModel;
		  librariesModels: librariesModels;
		  entryPoints: { aFamixMethod };
		  callStackModels: { callStackModel };
		  run
```
"
Class {
	#name : 'CGContextualizer',
	#superclass : 'Object',
	#instVars : [
		'mainModel',
		'librariesModels',
		'graph',
		'entryPoints',
		'graphBuilder',
		'tracesModels',
		'tracedNodesPerTraceModel'
	],
	#category : 'Famix-CallGraphs-Contextualizer',
	#package : 'Famix-CallGraphs-Contextualizer'
}

{ #category : 'as yet unclassified' }
CGContextualizer class >> apply: aCSModel on: aGraph [

	^ self new apply: aCSModel on: aGraph
]

{ #category : 'as yet unclassified' }
CGContextualizer >> apply: aTraceModel on: aGraph [

	| traceSequence tracedNodes |
	"Collecting all methods on the trace in order of the stack"
	traceSequence := self collectTraceMethodsFrom: aTraceModel.

	"Add additionnals properties on the graph"
	tracedNodes := self tracePath: traceSequence in: aGraph.

	tracedNodesPerTraceModel at: aTraceModel put: tracedNodes.
]

{ #category : 'as yet unclassified' }
CGContextualizer >> buildGraph [

	| workspace |
	graph ifNotNil: [ ^ graph ].
	workspace := MooseWorkspace new mainModel: mainModel.
	librariesModels do: [ :each | workspace addLibraryModel: each ].

	self createReflectivesHookOn: graphBuilder withWorkspace: workspace.

	^ graph := workspace interModelModeDuring: [
			           graphBuilder
				           entryPoints: entryPoints asArray;
				           build ]
]

{ #category : 'as yet unclassified' }
CGContextualizer >> collectTraceMethodsFrom: aTraceModel [
	"elements should be ordered by default"

	^ (aTraceModel allWithType: FamixJTTrace) anyOne traceElements collect: [ :each | each method ]
]

{ #category : 'as yet unclassified' }
CGContextualizer >> createReflectivesHookOn: aGraphBuilder withWorkspace: workspace [ 

	self subclassResponsibility
]

{ #category : 'settings' }
CGContextualizer >> entryPoints: aCollection [
	"Reset graph when entrypoints change"
	graph := nil.
	entryPoints := aCollection
]

{ #category : 'as yet unclassified' }
CGContextualizer >> findNodeFor: targetMethod from: currentNode in: aGraph [
	"When extracting a parametric method, if compiled with -g, then we get the signature with parametric types like K or V, if compiled without -g, then we always get Object for parameters
	In either case, we here accept a parametric method if it has the same name, and number of parameters"

	^ currentNode callees
		  detect: [ :each |
				  each realMethod mooseName = targetMethod mooseName or: [
						  targetMethod isParametricEntity and: [
							  targetMethod name = each realMethod name and: [ targetMethod parameters size = each realMethod parameters size ] ] ] ]
		  ifNone: [ nil ]
]

{ #category : 'formatting' }
CGContextualizer >> formatTracedNodes: tracedNodes [
	
	^ tracedNodes collect: [ :each |
			  each -> {
				  ('receiver' -> each additionalProperties values first traceMethods first receiver).
				  ('arguments' -> each additionalProperties values first traceMethods first arguments) } ]
]

{ #category : 'settings' }
CGContextualizer >> graph [
	
	^ graph
]

{ #category : 'as yet unclassified' }
CGContextualizer >> graphBuilder: aGraphBuilder [

	graphBuilder := aGraphBuilder
]

{ #category : 'as yet unclassified' }
CGContextualizer >> initialNodeFor: aGraph [

	^ FamixCallGraphNode new
		addCallee: aGraph entryPoint;
		yourself
]

{ #category : 'as yet unclassified' }
CGContextualizer >> initialize [

	graphBuilder := FamixJavaCHABuilder new.
	tracedNodesPerTraceModel := Dictionary new
]

{ #category : 'settings' }
CGContextualizer >> librariesModels: aCollection [
	"Reset graph when librariesModels change"

	graph := nil.

	librariesModels := aCollection asMooseGroup
]

{ #category : 'settings' }
CGContextualizer >> mainModel: aFamixModel [
	"Reset graph when main model change"

	graph := nil.

	mainModel := aFamixModel
]

{ #category : 'as yet unclassified' }
CGContextualizer >> propertyName [

	^ #property
]

{ #category : 'as yet unclassified' }
CGContextualizer >> run [

	self buildGraph.

	tracesModels do: [ :each | self apply: each on: graph ].

	^ tracedNodesPerTraceModel
]

{ #category : 'as yet unclassified' }
CGContextualizer >> tracePath: traceSequence in: aGraph [

	| currentNode tracedNodes |
	"Stores all traced nodes"
	tracedNodes := OrderedCollection new.

	"Use this as an artificial first node to initialize algorithm"
	currentNode := self initialNodeFor: aGraph. 

	"Iterate on all stacks"
	traceSequence do: [ :targetMethod |
			currentNode := self findNodeFor: targetMethod from: currentNode in: aGraph.

			"If nil then its not possible to continue"
			currentNode ifNil: [ ^ tracedNodes ].

			"If not nil then enrich the graph and continue"
			currentNode additionalPropertyNamed: self propertyName put: targetMethod.
			tracedNodes add: currentNode ].

	^ tracedNodes
]

{ #category : 'as yet unclassified' }
CGContextualizer >> tracedNodesPerTraceModel [

	^ tracedNodesPerTraceModel
]

{ #category : 'as yet unclassified' }
CGContextualizer >> tracedNodesPerTraceModel: aCSModel [

	^ tracedNodesPerTraceModel at: aCSModel ifPresent: [ :nodes | self formatTracedNodes: nodes ] ifAbsent: [ nil ]
]

{ #category : 'settings' }
CGContextualizer >> tracesModels: aCollection [
	"Reset graph when trace models changes"

	graph := nil.

	tracesModels := aCollection
]
