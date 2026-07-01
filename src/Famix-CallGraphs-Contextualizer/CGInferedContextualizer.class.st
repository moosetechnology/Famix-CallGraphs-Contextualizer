"
This class contextualizes a call graph using a infered matching algorithm. If the target call graph lacks any methods present in the execution trace, this algorithm will create the missing node, using famix-brigde.
"
Class {
	#name : 'CGInferedContextualizer',
	#superclass : 'CGContextualizer',
	#category : 'Famix-CallGraphs-Contextualizer',
	#package : 'Famix-CallGraphs-Contextualizer'
}

{ #category : 'as yet unclassified' }
CGInferedContextualizer >> ensureFamixBridgeCompatibility: aTraceModel [
	"Parameters obtained through JavaTraceExtractor often lack names.
	FamixBridge treats them as distinct parameters, doubling a method's parameter count.
	Consequently, call graph construction fails."

	aTraceModel allMethods do: [ :each | each parameters: {  } ].
	^ aTraceModel 
]

{ #category : 'as yet unclassified' }
CGInferedContextualizer >> handleInferenceOn: aGraphBuilder with: workspace [

	tracesModels do: [ :each | workspace addLibraryModel: (self ensureFamixBridgeCompatibility: each) ]
]
