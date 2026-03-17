"
A CGContextualizerTest is a test class for testing the behavior of CGContextualizer
"
Class {
	#name : 'CGContextualizerExample1Test',
	#superclass : 'FamixAbstractJavaCGContextualizerBuilderTestCase',
	#category : 'Famix-CallGraphs-Contextualizer-Tests-Tests',
	#package : 'Famix-CallGraphs-Contextualizer-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
CGContextualizerExample1Test >> testCollectTraceMethodsFrom [

	| methods methodsName |
	methods := CGContextualizer new collectTraceMethodsFrom: self traceModel.

	self assert: methods size equals: 3.

	methodsName := methods collect: [ :each | each mooseName ].

	self assert: methodsName first equals: 'example1.A1.main(String[])'.
	self assert: methodsName second equals: 'example1.B1.method(String[])'.
	self assert: methodsName third equals: 'example1.B1.endPoint()'
]

{ #category : 'tests' }
CGContextualizerExample1Test >> testInferedBuildGraph [
	"This method is here to ensure the graph building works"

	| nodes methodsName |
	nodes := self inferedContextualizer buildGraph
		               findPathFromNodeNamed: 'example1.A1.main(String[])'
		               toNodeNamed: 'example1.B1.endPoint()'.

	methodsName := nodes collect: [ :each | each realMethod mooseName ].

	self assert: nodes size equals: 3.

	self assert: methodsName first equals: 'example1.A1.main(String[])'.
	self assert: methodsName second equals: 'example1.B1.method(String[])'.
	self assert: methodsName third equals: 'example1.B1.endPoint()'
]

{ #category : 'tests' }
CGContextualizerExample1Test >> testInferedRun [

	| tracedNodes methodsName |
	tracedNodes := self inferedContextualizer run at: self traceModel.

	methodsName := tracedNodes collect: [ :each | each realMethod mooseName ].

	self assert: tracedNodes size equals: 3.

	self assert: methodsName first equals: 'example1.A1.main(String[])'.
	self assert: methodsName second equals: 'example1.B1.method(String[])'.
	self assert: methodsName third equals: 'example1.B1.endPoint()'
]

{ #category : 'tests' }
CGContextualizerExample1Test >> testStrictBuildGraph [
	"This method is here to ensure the graph building works"

	| nodes methodsName |
	nodes := self strictContextualizer buildGraph
		               findPathFromNodeNamed: 'example1.A1.main(String[])'
		               toNodeNamed: 'example1.B1.endPoint()'.

	methodsName := nodes collect: [ :each | each realMethod mooseName ].

	self assert: nodes size equals: 3.

	self assert: methodsName first equals: 'example1.A1.main(String[])'.
	self assert: methodsName second equals: 'example1.B1.method(String[])'.
	self assert: methodsName third equals: 'example1.B1.endPoint()'
]

{ #category : 'tests' }
CGContextualizerExample1Test >> testStrictRun [

	| tracedNodes methodsName |
	tracedNodes := self strictContextualizer run at: self traceModel.

	methodsName := tracedNodes collect: [ :each | each realMethod mooseName ].

	self assert: tracedNodes size equals: 3.

	self assert: methodsName first equals: 'example1.A1.main(String[])'.
	self assert: methodsName second equals: 'example1.B1.method(String[])'.
	self assert: methodsName third equals: 'example1.B1.endPoint()'
]
