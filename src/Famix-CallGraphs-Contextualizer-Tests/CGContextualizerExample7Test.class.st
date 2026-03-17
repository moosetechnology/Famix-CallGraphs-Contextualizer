Class {
	#name : 'CGContextualizerExample7Test',
	#superclass : 'FamixAbstractJavaCGContextualizerBuilderTestCase',
	#category : 'Famix-CallGraphs-Contextualizer-Tests-Tests',
	#package : 'Famix-CallGraphs-Contextualizer-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
CGContextualizerExample7Test >> testCollectTraceMethodsFrom [

	| methods methodsName |
	methods := CGContextualizer new collectTraceMethodsFrom: self traceModel.

	self assert: methods size equals: 3.

	methodsName := methods collect: [ :each | each mooseName ].

	self assert: methodsName first equals: 'example7.A7.main(String[])'.
	self assert: methodsName second equals: 'example7.B7.method(String, A7)'.
	self assert: methodsName third equals: 'example7.A7.endPoint()'
]

{ #category : 'tests' }
CGContextualizerExample7Test >> testInferedBuildGraph [
	"This method is here to ensure the graph building works"

	| nodes methodsName |
	nodes := self inferedContextualizer buildGraph
		         findPathFromNodeNamed: 'example6.A6.main(String[])'
		         toNodeNamed: 'example6.A6.endPoint()'.

	methodsName := nodes collect: [ :each | each realMethod mooseName ].

	self assert: methodsName first equals: 'example7.A7.main(String[])'.
	self assert: methodsName second equals: 'example7.B7.method(String, A7)'.
	self assert: methodsName third equals: 'example7.A7.endPoint()'
]

{ #category : 'tests' }
CGContextualizerExample7Test >> testInferedRun [

	| tracedNodes methodsName |
	tracedNodes := self inferedContextualizer run at: self traceModel.

	methodsName := tracedNodes collect: [ :each | each realMethod mooseName ].

	self assert: methodsName size equals: 3.

	self assert: methodsName first equals: 'example7.A7.main(String[])'.
	self assert: methodsName second equals: 'example7.B7.method(String, A7)'.
	self assert: methodsName third equals: 'example7.A7.endPoint()'
]

{ #category : 'tests' }
CGContextualizerExample7Test >> testStrictBuildGraph [
	"This method is here to ensure the graph building works"

	| nodes methodsName |
	nodes := self strictContextualizer buildGraph
		         findPathFromNodeNamed: 'example6.A6.main(String[])'
		         toNodeNamed: 'example6.A6.endPoint()'.

	methodsName := nodes collect: [ :each | each realMethod mooseName ].

	self assert: methodsName size equals: 3.
	
	self assert: methodsName first equals: 'example7.A7.main(String[])'.
	self assert: methodsName second equals: 'example7.B7.method(String, A7)'.
	self assert: methodsName third equals: 'example7.A7.endPoint()'
]

{ #category : 'tests' }
CGContextualizerExample7Test >> testStrictRun [

	| tracedNodes methodsName |
	tracedNodes := self strictContextualizer run at: self traceModel.

	methodsName := tracedNodes collect: [ :each | each realMethod mooseName ].

	self assert: methodsName size equals: 3.

	self assert: methodsName first equals: 'example7.A7.main(String[])'.
	self assert: methodsName second equals: 'example7.B7.method(String, A7)'.
	self assert: methodsName third equals: 'example7.A7.endPoint()'
]
