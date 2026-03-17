Class {
	#name : 'CGContextualizerExample5Test',
	#superclass : 'FamixAbstractJavaCGContextualizerBuilderTestCase',
	#category : 'Famix-CallGraphs-Contextualizer-Tests-Tests',
	#package : 'Famix-CallGraphs-Contextualizer-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
CGContextualizerExample5Test >> testCollectTraceMethodsFrom [

	| methods methodsName |
	methods := CGContextualizer new collectTraceMethodsFrom: self traceModel.

	self assert: methods size equals: 3.

	methodsName := methods collect: [ :each | each mooseName ].

	self assert: methodsName first equals: 'example5.A5.main(String[])'.
	self assert: methodsName second equals: 'example5.C5.method()'.
	self assert: methodsName third equals: 'example5.C5.endPoint()'
]

{ #category : 'tests' }
CGContextualizerExample5Test >> testInferedBuildGraph [
	"This method is here to ensure the graph building works"

	| nodes methodsName |
	nodes := self inferedContextualizer buildGraph
		         findPathFromNodeNamed: 'example5.A5.main(String[])'
		         toNodeNamed: 'example5.C5.endPoint()'.

	methodsName := nodes collect: [ :each | each realMethod mooseName ].

	self assert: methodsName first equals: 'example5.A5.main(String[])'.
	self assert: methodsName second equals: 'example5.C5.method()'.
	self assert: methodsName third equals: 'example5.C5.endPoint()'
]

{ #category : 'tests' }
CGContextualizerExample5Test >> testInferedRun [

	| tracedNodes methodsName |
	tracedNodes := self inferedContextualizer run at: self traceModel.

	methodsName := tracedNodes collect: [ :each | each realMethod mooseName ].

	self assert: methodsName size equals: 3.

	self assert: methodsName first equals: 'example5.A5.main(String[])'.
	self assert: methodsName second equals: 'example5.C5.method()'.
	self assert: methodsName third equals: 'example5.C5.endPoint()'
]

{ #category : 'tests' }
CGContextualizerExample5Test >> testStrictBuildGraph [
	"This method is here to ensure the graph building works"

	| nodes methodsName |
	nodes := self strictContextualizer buildGraph
		         findPathFromNodeNamed: 'example5.A5.main(String[])'
		         toNodeNamed: 'example5.C5.endPoint()'.

	methodsName := nodes collect: [ :each | each realMethod mooseName ].

	self assert: methodsName size equals: 3.

	self assert: methodsName first equals: 'example5.A5.main(String[])'.
	self assert: methodsName second equals: 'example5.C5.method()'.
	self assert: methodsName third equals: 'example5.C5.endPoint()'
]

{ #category : 'tests' }
CGContextualizerExample5Test >> testStrictRun [

	| tracedNodes methodsName |
	tracedNodes := self strictContextualizer run at: self traceModel.

	methodsName := tracedNodes collect: [ :each | each realMethod mooseName ].

	self assert: methodsName size equals: 3.

	self assert: methodsName first equals: 'example5.A5.main(String[])'.
	self assert: methodsName second equals: 'example5.C5.method()'.
	self assert: methodsName third equals: 'example5.C5.endPoint()'
]
