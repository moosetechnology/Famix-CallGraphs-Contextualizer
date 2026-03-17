Class {
	#name : 'CGContextualizerExample6Test',
	#superclass : 'FamixAbstractJavaCGContextualizerBuilderTestCase',
	#category : 'Famix-CallGraphs-Contextualizer-Tests-Tests',
	#package : 'Famix-CallGraphs-Contextualizer-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
CGContextualizerExample6Test >> testCollectTraceMethodsFrom [

	| methods methodsName |
	methods := CGContextualizer new collectTraceMethodsFrom: self traceModel.

	self assert: methods size equals: 3.

	methodsName := methods collect: [ :each | each mooseName ].

	self assert: methodsName first equals: 'example6.A6.main(String[])'.
	self assert: methodsName second equals: 'example6.B6.method(A6)'.
	self assert: methodsName third equals: 'example6.A6.endPoint()'
]

{ #category : 'tests' }
CGContextualizerExample6Test >> testInferedBuildGraph [
	"This method is here to ensure the graph building works"

	| nodes methodsName |
	nodes := self inferedContextualizer buildGraph
		         findPathFromNodeNamed: 'example6.A6.main(String[])'
		         toNodeNamed: 'example6.A6.endPoint()'.

	methodsName := nodes collect: [ :each | each realMethod mooseName ].

	self assert: methodsName first equals: 'example6.A6.main(String[])'.
	self assert: methodsName second equals: 'example6.B6.method(A6)'.
	self assert: methodsName third equals: 'example6.A6.endPoint()'
]

{ #category : 'tests' }
CGContextualizerExample6Test >> testInferedRun [

	| tracedNodes methodsName |
	tracedNodes := self inferedContextualizer run at: self traceModel.

	methodsName := tracedNodes collect: [ :each | each realMethod mooseName ].

	self assert: methodsName size equals: 3.

	self assert: methodsName first equals: 'example6.A6.main(String[])'.
	self assert: methodsName second equals: 'example6.B6.method(A6)'.
	self assert: methodsName third equals: 'example6.A6.endPoint()'
]

{ #category : 'tests' }
CGContextualizerExample6Test >> testStrictBuildGraph [
	"This method is here to ensure the graph building works"

	| nodes methodsName |
	nodes := self strictContextualizer buildGraph
		         findPathFromNodeNamed: 'example6.A6.main(String[])'
		         toNodeNamed: 'example6.A6.endPoint()'.

	methodsName := nodes collect: [ :each | each realMethod mooseName ].

	self assert: methodsName size equals: 3.

	self assert: methodsName first equals: 'example6.A6.main(String[])'.
	self assert: methodsName second equals: 'example6.B6.method(A6)'.
	self assert: methodsName third equals: 'example6.A6.endPoint()'
]

{ #category : 'tests' }
CGContextualizerExample6Test >> testStrictRun [

	| tracedNodes methodsName |
	tracedNodes := self strictContextualizer run at: self traceModel.

	methodsName := tracedNodes collect: [ :each | each realMethod mooseName ].

	self assert: methodsName size equals: 3.

	self assert: methodsName first equals: 'example6.A6.main(String[])'.
	self assert: methodsName second equals: 'example6.B6.method(A6)'.
	self assert: methodsName third equals: 'example6.A6.endPoint()'
]
