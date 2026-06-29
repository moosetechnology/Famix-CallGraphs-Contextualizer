"
I offer a simple API for the detection and chaining of attack patterns within a call graph

## Instantiation
Use **`newOn: aCallGraph`** to link the parser directly to the target

## Primary API

| Methodology | Action |
|---|----
| `findAllPatterns` | Identifies all the known patterns on the graph |
| `find<Name>Pattern` | Identifies a specific pattern (`<Name>`) |
| `findPatternChainIn:` | Find pattern chains in the graph (unlimited depth) |
| `findPatternChainIn:depth:` | Find pattern chains in the graph, with a strict depth restriction (`depth`) |
"
Class {
	#name : 'CGPatternFinder',
	#superclass : 'Object',
	#instVars : [
		'graph',
		'allNodes'
	],
	#category : 'Famix-CallGraphs-Pattern-Finder',
	#package : 'Famix-CallGraphs-Pattern-Finder'
}

{ #category : 'instance creation' }
CGPatternFinder class >> newOn: aGraph [

	^ self new
		  graph: aGraph;
		  yourself
]

{ #category : 'helper' }
CGPatternFinder >> extendPaths: currentPaths withCalleesMatching: aString [

	^ currentPaths flatCollect: [ :path |
			  (self findCalleesOf: path last IncludingInMethodName: aString) collect: [ :callee |
					  path copy
						  add: callee;
						  yourself ] ]
]

{ #category : 'patterns' }
CGPatternFinder >> findAllPatterns [

	| res |
	res := Dictionary new.

	res at: 'getter-transform-transform-invoke' put: (self findGetterTransformerPattern).
	res at: '$Proxy-invoke' put: (self findProxyInvokePattern).
	res at: 'readObject-put-hash-hashCode-get' put: (self findReadObjectHashMapPattern).
	res at: 'readObject-toString-get' put: (self findReadObjectToStringGetterPattern).
	^ res
]

{ #category : 'helper' }
CGPatternFinder >> findCalleesOf: aNode IncludingInClassName: aName [

	self halt
]

{ #category : 'helper' }
CGPatternFinder >> findCalleesOf: aNode IncludingInMethodName: aName [

	^ aNode callees select: [ :callee | callee realMethod name includesSubstring: aName ]
]

{ #category : 'patterns' }
CGPatternFinder >> findGetterTransformerPattern [
	"Finding pattern like: getter - transform - transform - invoke"

	| paths |
	paths := self findInitialNodesIncludingInMethodName: 'get'.
	paths := self extendPaths: paths withCalleesMatching: 'transform'.
	paths := self extendPaths: paths withCalleesMatching: 'transform'.
	^ self extendPaths: paths withCalleesMatching: 'invoke'
]

{ #category : 'helper' }
CGPatternFinder >> findInitialGetterPaths [

	^ (allNodes select: [ :node | node realMethod mooseName includesSubstring: 'get' ]) collect: [ :node |
		  OrderedCollection with: node ]
]

{ #category : 'helper' }
CGPatternFinder >> findInitialNodesIncludingInClassName: aString [

	^ (allNodes select: [ :node | node realMethod parentType name includesSubstring: aString ]) collect: [ :node |
		  OrderedCollection with: node ]
]

{ #category : 'helper' }
CGPatternFinder >> findInitialNodesIncludingInMethodName: aString [

	^ (allNodes select: [ :node | node realMethod name includesSubstring: aString ]) collect: [ :node |
		  OrderedCollection with: node ]
]

{ #category : 'pattern-chain' }
CGPatternFinder >> findPatternChainIn: aCollection [

	^ self findPatternChainIn: aCollection depth: nil
]

{ #category : 'pattern-chain' }
CGPatternFinder >> findPatternChainIn: aCollection depth: depth [

	| allPatterns result pathFinder |
	"Use a Set to reduce possible duplications"
	result := HashSet new.

	"Reduce duplication on patterns by converting collection to a set"
	allPatterns := (aCollection isDictionary
		               ifTrue: [ aCollection values ]
		               ifFalse: [ aCollection ]) asSet.
		

	pathFinder := (FamixCallGraphPathFinder newOn: graph withAllNodes: allNodes)
		              depth: depth;
		              yourself.

	allPatterns do: [ :startCollection |
			allPatterns do: [ :endCollection |
					startCollection == endCollection ifFalse: [
							startCollection do: [ :startPattern |
									endCollection do: [ :endPattern |
											(pathFinder findAllPathFrom: startPattern last to: endPattern first) do: [ :path |
												result add: startPattern allButLast , path , endPattern allButFirst ] ] ] ] ] ].

	^ result
]

{ #category : 'patterns' }
CGPatternFinder >> findProxyInvokePattern [
	"Finding pattern like: $Proxy - invoke"

	| paths |
	paths := self findInitialNodesIncludingInClassName: '$Proxy'.
	^ self extendPaths: paths withCalleesMatching: 'invoke'
]

{ #category : 'patterns' }
CGPatternFinder >> findReadObjectHashMapPattern [
	"Finding pattern like: readObject - put - hash - hashCode - get"

	| paths |
	paths := self findInitialNodesIncludingInMethodName: 'readObject'.
	paths := self extendPaths: paths withCalleesMatching: 'put'.
	paths := self extendPaths: paths withCalleesMatching: 'hash'.
	paths := self extendPaths: paths withCalleesMatching: 'hashCode'.
	^ self extendPaths: paths withCalleesMatching: 'get'
]

{ #category : 'patterns' }
CGPatternFinder >> findReadObjectToStringGetterPattern [
	"Finding pattern like: readObject - toString - get"

	| paths |
	paths := self findInitialNodesIncludingInMethodName: 'readObject'.
	paths := self extendPaths: paths withCalleesMatching: 'toString'.
	^ self extendPaths: paths withCalleesMatching: 'get'
]

{ #category : 'as yet unclassified' }
CGPatternFinder >> graph [

	^ graph
]

{ #category : 'as yet unclassified' }
CGPatternFinder >> graph: aGraph [

	graph := aGraph.
	"Collecting all nodes in a simple collection to optimise the validity check of nodes"
	allNodes := self graph allNodes
]
