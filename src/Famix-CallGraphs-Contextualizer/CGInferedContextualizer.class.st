Class {
	#name : 'CGInferedContextualizer',
	#superclass : 'CGContextualizer',
	#category : 'Famix-CallGraphs-Contextualizer',
	#package : 'Famix-CallGraphs-Contextualizer'
}

{ #category : 'as yet unclassified' }
CGInferedContextualizer >> handleInferenceOn: aGraphBuilder with: workspace [

	tracesModels do: [ :each | workspace addLibraryModel: each ]
]
