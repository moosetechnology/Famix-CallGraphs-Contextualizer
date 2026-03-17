Class {
	#name : 'CGContextualizerExample3Test',
	#superclass : 'FamixAbstractJavaCGContextualizerBuilderTestCase',
	#category : 'Famix-CallGraphs-Contextualizer-Tests-Tests',
	#package : 'Famix-CallGraphs-Contextualizer-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
CGContextualizerExample3Test >> testCollectTraceMethodsFrom [

	| methods methodsName |
	methods := CGContextualizer new collectTraceMethodsFrom: self traceModel.

	self assert: methods size equals: 4.

	methodsName := methods collect: [ :each | each mooseName ].

	self assert: methodsName first equals: 'example3.A3.main(String[])'.
	self assert: methodsName second equals: 'example3External.B3.method(Object)'.
	self assert: methodsName third equals: 'example3.A3.toString()'.
	self assert: methodsName fourth equals: 'example3.A3.endPoint()'
]

{ #category : 'tests' }
CGContextualizerExample3Test >> testInferedBuildGraph [
	"This method is here to ensure the graph building works"

	| nodes methodsName |
	nodes := self inferedContextualizer buildGraph
		         findPathFromNodeNamed: 'example3.A3.main(String[])'
		         toNodeNamed: 'example3.A3.endPoint()'.

	methodsName := nodes collect: [ :each | each realMethod mooseName ].

	self assert: methodsName size equals: 4.

	self assert: methodsName first equals: 'example3.A3.main(String[])'.
	self assert: methodsName second equals: 'example3External.B3.method(Object)'.
	self assert: methodsName third equals: 'example3.A3.toString()'.
	self assert: methodsName fourth equals: 'example3.A3.endPoint()'
]

{ #category : 'tests' }
CGContextualizerExample3Test >> testInferedRun [

	| tracedNodes methodsName |
	tracedNodes := self inferedContextualizer run at: self traceModel.

	methodsName := tracedNodes collect: [ :each | each realMethod mooseName ].

	self assert: tracedNodes size equals: 4.

	self assert: methodsName first equals: 'example3.A3.main(String[])'.
	self assert: methodsName second equals: 'example3External.B3.method(Object)'.
	self assert: methodsName third equals: 'example3.A3.toString()'.
	self assert: methodsName fourth equals: 'example3.A3.endPoint()'
]

{ #category : 'tests' }
CGContextualizerExample3Test >> testStrictBuildGraph [
	"This method is here to ensure the graph building works"

	| nodes methodsName |
	nodes := self strictContextualizer buildGraph
		         findPathFromNodeNamed: 'example3.A3.main(String[])'
		         toNodeNamed: 'example3.A3.endPoint()'.

	methodsName := nodes collect: [ :each | each realMethod mooseName ].

	self assert: methodsName size equals: 4.

	self assert: methodsName first equals: 'example3.A3.main(String[])'.
	self assert: methodsName second equals: 'example3External.B3.method(Object)'.
	self assert: methodsName third equals: 'example3.A3.toString()'.
	self assert: methodsName fourth equals: 'example3.A3.endPoint()'
]

{ #category : 'tests' }
CGContextualizerExample3Test >> testStrictRun [

	| tracedNodes methodsName |
	tracedNodes := self strictContextualizer run at: self traceModel.
	methodsName := tracedNodes collect: [ :each | each realMethod mooseName ].

	self assert: tracedNodes size equals: 4.

	self assert: methodsName first equals: 'example3.A3.main(String[])'.
	self assert: methodsName second equals: 'example3External.B3.method(Object)'.
	self assert: methodsName third equals: 'example3.A3.toString()'.
	self assert: methodsName fourth equals: 'example3.A3.endPoint()'
]
