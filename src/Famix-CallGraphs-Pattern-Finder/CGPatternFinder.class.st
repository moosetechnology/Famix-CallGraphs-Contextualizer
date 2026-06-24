Class {
	#name : 'CGPatternFinder',
	#superclass : 'Object',
	#category : 'Famix-CallGraphs-Pattern-Finder',
	#package : 'Famix-CallGraphs-Pattern-Finder'
}

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
	res at: 'readObject-put-hash-hashCode' put: (self findReadObjectHashMapPatternOn: aGraph).
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

{ #category : 'patterns' }
CGPatternFinder >> findProxyInvokePatternOn: aGraph [
	"Finding pattern like: $Proxy - invoke"

	| paths |
	paths := self findInitialNodesIncludingInClassName: '$Proxy' PathsIn: aGraph.
	^ self extendPaths: paths withCalleesMatching: 'invoke'
]

{ #category : 'patterns' }
CGPatternFinder >> findReadObjectHashMapPatternOn: aGraph [
	"Finding pattern like: readObject - put - hash - hashCode"

	| paths |
	paths := self findInitialNodesIncludingInMethodName: 'readObject' PathsIn: aGraph.
	paths := self extendPaths: paths withCalleesMatching: 'put'.
		paths := self extendPaths: paths withCalleesMatching: 'hash'.
	^ self extendPaths: paths withCalleesMatching: 'hashCode'
]

{ #category : 'patterns' }
CGPatternFinder >> findReadObjectToStringGetterPatternOn: aGraph [
	"Finding pattern like: readObject - toString - get"

	| paths |
	paths := self findInitialNodesIncludingInMethodName: 'readObject' PathsIn: aGraph.
	paths := self extendPaths: paths withCalleesMatching: 'toString'.
	^ self extendPaths: paths withCalleesMatching: 'get'
]
