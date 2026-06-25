Class {
	#name : 'CGPatternFinder',
	#superclass : 'Object',
	#instVars : [
		'graph'
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
CGPatternFinder >> findAllOn: aGraph [

	| res |
	res := Dictionary new.

	res at: 'getter-transform-transform-invoke' put: (self findGetterTransformerPatternOn: aGraph).
	res at: '$Proxy-invoke' put: (self findProxyInvokePatternOn: aGraph).
	res at: 'readObject-put-hash-hashCode-get' put: (self findReadObjectHashMapPatternOn: aGraph).
	res at: 'readObject-toString-get' put: (self findReadObjectToStringGetterPatternOn: aGraph).
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
CGPatternFinder >> findGetterTransformerPatternOn: aGraph [
	"Finding pattern like: getter - transform - transform - invoke"

	| paths |
	paths := self findInitialNodesIncludingInMethodName: 'get' PathsIn: aGraph.
	paths := self extendPaths: paths withCalleesMatching: 'transform'.
	paths := self extendPaths: paths withCalleesMatching: 'transform'.
	^ self extendPaths: paths withCalleesMatching: 'invoke'
]

{ #category : 'helper' }
CGPatternFinder >> findInitialGetterPathsIn: aGraph [

	^ (aGraph allNodes select: [ :node | node realMethod mooseName includesSubstring: 'get' ]) collect: [ :node |
		  OrderedCollection with: node ]
]

{ #category : 'helper' }
CGPatternFinder >> findInitialNodesIncludingInClassName: aString PathsIn: aGraph [

	^ (aGraph allNodes select: [ :node | node realMethod parentType name includesSubstring: aString ]) collect: [ :node |
		  OrderedCollection with: node ]
]

{ #category : 'helper' }
CGPatternFinder >> findInitialNodesIncludingInMethodName: aString PathsIn: aGraph [

	^ (aGraph allNodes select: [ :node | node realMethod name includesSubstring: aString ]) collect: [ :node |
		  OrderedCollection with: node ]
]

{ #category : 'pattern-chain' }
CGPatternFinder >> findPatternChainIn: aCollection [

	^ self findPatternChainIn: aCollection depth: nil
]

{ #category : 'pattern-chain' }
CGPatternFinder >> findPatternChainIn: aCollection depth: depth [

	| allPatterns result pathFinder |
	result := OrderedCollection new.

	allPatterns := aCollection isDictionary
		               ifTrue: [ aCollection values ]
		               ifFalse: [ aCollection ].

	pathFinder := (FamixCallGraphPathFinder newOn: graph)
		              depth: depth;
		              yourself.

	allPatterns do: [ :startCollection |
			allPatterns do: [ :endCollection |
					startCollection == endCollection ifTrue: [
							startCollection do: [ :startPattern |
									endCollection do: [ :endPattern |
											(pathFinder findAllPathFrom: startPattern last to: endPattern first) do: [ :path |
												result add: startPattern allButLast , path , endPattern allButFirst ] ] ] ] ] ].

	^ result
]

{ #category : 'patterns' }
CGPatternFinder >> findProxyInvokePatternOn: aGraph [
	"Finding pattern like: $Proxy - invoke"

	| paths |
	paths := self findInitialNodesIncludingInClassName: '$Proxy' PathsIn: aGraph.
	^ self extendPaths: paths withCalleesMatching: 'invoke'
]

{ #category : 'patterns' }
CGPatternFinder >> findReadObjectHashMapPatternOn: aGraph [
	"Finding pattern like: readObject - put - hash - hashCode - get"

	| paths |
	paths := self findInitialNodesIncludingInMethodName: 'readObject' PathsIn: aGraph.
	paths := self extendPaths: paths withCalleesMatching: 'put'.
	paths := self extendPaths: paths withCalleesMatching: 'hash'.
	paths := self extendPaths: paths withCalleesMatching: 'hashCode'.
	^ self extendPaths: paths withCalleesMatching: 'get'
]

{ #category : 'patterns' }
CGPatternFinder >> findReadObjectToStringGetterPatternOn: aGraph [
	"Finding pattern like: readObject - toString - get"

	| paths |
	paths := self findInitialNodesIncludingInMethodName: 'readObject' PathsIn: aGraph.
	paths := self extendPaths: paths withCalleesMatching: 'toString'.
	^ self extendPaths: paths withCalleesMatching: 'get'
]

{ #category : 'as yet unclassified' }
CGPatternFinder >> graph [

	^ graph
]

{ #category : 'as yet unclassified' }
CGPatternFinder >> graph: aGraph [

	graph := aGraph
]
