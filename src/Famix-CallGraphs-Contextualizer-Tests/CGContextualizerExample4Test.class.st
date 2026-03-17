Class {
	#name : 'CGContextualizerExample4Test',
	#superclass : 'FamixAbstractJavaCGContextualizerBuilderTestCase',
	#category : 'Famix-CallGraphs-Contextualizer-Tests-Tests',
	#package : 'Famix-CallGraphs-Contextualizer-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
CGContextualizerExample4Test >> testCollectTraceMethodsFrom [

	| methods methodsName |
	methods := CGContextualizer new collectTraceMethodsFrom: self traceModel.

	self assert: methods size equals: 4.

	methodsName := methods collect: [ :each | each mooseName ].

	self assert: methodsName first equals: 'example4.A4.main(String[])'.
	self assert: methodsName second equals: 'example4External.B4.toString()'.
	self assert: methodsName third equals: 'example4.A4.toString()'.
	self assert: methodsName fourth equals: 'example4.A4.endPoint()'
]

{ #category : 'tests' }
CGContextualizerExample4Test >> testInferedBuildGraph [
	"This method is here to ensure the graph building works"

	| nodes methodsName |
	nodes := self inferedContextualizer buildGraph
		         findPathFromNodeNamed: 'example4.A4.main(String[])'
		         toNodeNamed: 'example4.A4.endPoint()'.

	methodsName := nodes collect: [ :each | each realMethod mooseName ].

	self assert: methodsName size equals: 4.

	self assert: methodsName first equals: 'example4.A4.main(String[])'.
	self assert: methodsName second equals: 'example4External.B4.toString()'.
	self assert: methodsName third equals: 'example4.A4.toString()'.
	self assert: methodsName fourth equals: 'example4.A4.endPoint()'
]

{ #category : 'tests' }
CGContextualizerExample4Test >> testInferedRun [

	| tracedNodes methodsName |
	tracedNodes := self inferedContextualizer run at: self traceModel.

	methodsName := tracedNodes collect: [ :each | each realMethod mooseName ].

	self assert: methodsName size equals: 4.

	self assert: methodsName first equals: 'example4.A4.main(String[])'.
	self assert: methodsName second equals: 'example4External.B4.toString()'.
	self assert: methodsName third equals: 'example4.A4.toString()'.
	self assert: methodsName fourth equals: 'example4.A4.endPoint()'
]

{ #category : 'tests' }
CGContextualizerExample4Test >> testStrictBuildGraph [
	"This method is here to ensure the graph building works"

	| nodes methodsName |
	nodes := self strictContextualizer buildGraph
		          findPathFromNodeNamed: 'example4.A4.main(String[])'
		         toNodeNamed: 'example4.A4.endPoint()'.

	methodsName := nodes collect: [ :each | each realMethod mooseName ].

	self assert: methodsName size equals: 4.

	self assert: methodsName first equals: 'example4.A4.main(String[])'.
	self assert: methodsName second equals: 'example4External.B4.toString()'.
	self assert: methodsName third equals: 'example4.A4.toString()'.
	self assert: methodsName fourth equals: 'example4.A4.endPoint()'
]

{ #category : 'tests' }
CGContextualizerExample4Test >> testStrictRun [

	| tracedNodes methodsName |
	"Here the result is not the same as the stack because we do not have access to the external dependencies on the graph"
	tracedNodes := self strictContextualizer run at: self traceModel.

	methodsName := tracedNodes collect: [ :each | each realMethod mooseName ].

	self assert: methodsName size equals: 4.

	self assert: methodsName first equals: 'example4.A4.main(String[])'.
	self assert: methodsName second equals: 'example4External.B4.toString()'.
	self assert: methodsName third equals: 'example4.A4.toString()'.
	self assert: methodsName fourth equals: 'example4.A4.endPoint()'
]
