"
This class contextualizes a call graph using a infered matching algorithm. If the target call graph lacks any methods present in the execution trace, this algorithm will create the missing node, using a hook offered by the call graph algorithm.
"
Class {
	#name : 'CGInferedContextualizerReflectiveHook',
	#superclass : 'CGContextualizer',
	#category : 'Famix-CallGraphs-Contextualizer',
	#package : 'Famix-CallGraphs-Contextualizer'
}

{ #category : 'as yet unclassified' }
CGInferedContextualizerReflectiveHook >> handleInferenceOn: aGraphBuilder with: workspace [

	| elements |
	elements := tracesModels flatCollect: [ :each | each allWithType: FamixJTTraceMethod ].


	aGraphBuilder reflectiveHook: [ :node :builder |
			workspace interModelModeDuring: [
					| currentMooseName nextDynamicMethods |
					currentMooseName := node realMethod mooseName.

					"Extract the methods from the execution trace"
					nextDynamicMethods := (elements
						                       select: [ :element | element method mooseName = currentMooseName ]
						                       thenCollect: [ :element | element next ifNotNil: #method ]) reject: #isNil.

					"Construct graph edges for the identified dynamic callees."
					nextDynamicMethods do: [ :eachMethod | "Stub is forced to false to guarantee continuous graph expansion"
						node addCallee: (builder nodeForMethodSignature: eachMethod signature kind: eachMethod parentType stub: false) ] ] ]
]
