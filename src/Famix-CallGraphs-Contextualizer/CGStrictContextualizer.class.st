"
This class contextualizes a call graph using a strict matching algorithm. If the target call graph lacks any methods present in the execution trace, the application process is terminated.
"
Class {
	#name : 'CGStrictContextualizer',
	#superclass : 'CGContextualizer',
	#category : 'Famix-CallGraphs-Contextualizer',
	#package : 'Famix-CallGraphs-Contextualizer'
}

{ #category : 'as yet unclassified' }
CGStrictContextualizer >> handleInferenceOn: aGraphBuilder with: workspace [ 
	"Nothing"

	
]
