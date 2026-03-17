Class {
	#name : 'FamixAbstractJavaCGContextualizerBuilderTestCase',
	#superclass : 'TestCase',
	#category : 'Famix-CallGraphs-Contextualizer-Tests-Tests',
	#package : 'Famix-CallGraphs-Contextualizer-Tests',
	#tag : 'Tests'
}

{ #category : 'helpers' }
FamixAbstractJavaCGContextualizerBuilderTestCase class >> browseSources [

	<script>
	self sourceResource javaSourcesFolder openInOSFileBrowser
]

{ #category : 'testing' }
FamixAbstractJavaCGContextualizerBuilderTestCase class >> isAbstract [

	^ self = FamixAbstractJavaCGContextualizerBuilderTestCase
]

{ #category : 'accessing' }
FamixAbstractJavaCGContextualizerBuilderTestCase class >> resources [

	^ self environment
		  at: ((self name withoutSuffix: 'Test') , 'Resource') asSymbol
		  ifPresent: [ :class | { class } ]
		  ifAbsent: [ {  } ]
]

{ #category : 'helpers' }
FamixAbstractJavaCGContextualizerBuilderTestCase class >> sourceResource [

	^ self resources anyOne current
]

{ #category : 'running' }
FamixAbstractJavaCGContextualizerBuilderTestCase >> createContextualizer: aContextualizerClass [

	^ aContextualizerClass new
		  mainModel: self sourceResource javaMainModel;
		  librariesModels: self sourceResource librariesModels;
		  entryPoints: self sourceResource entryPoints;
		  callStackModels: { self traceModel };
		  yourself
]

{ #category : 'running' }
FamixAbstractJavaCGContextualizerBuilderTestCase >> inferedContextualizer [

	^ self createContextualizer: CGInferedContextualizer
]

{ #category : 'open sources' }
FamixAbstractJavaCGContextualizerBuilderTestCase >> openSources [

	<script: 'self new openSources'>
	self resources anyOne javaSourcesFolder openInOSFileBrowser
]

{ #category : 'running' }
FamixAbstractJavaCGContextualizerBuilderTestCase >> performTest [

	FamixCallGraphAdditionalProperties newInstanceDuring: [ super performTest ]
]

{ #category : 'helpers' }
FamixAbstractJavaCGContextualizerBuilderTestCase >> sourceResource [
	"I return the instance of the test resource I'm using to build the sources of a java project"

	^ self class sourceResource
]

{ #category : 'running' }
FamixAbstractJavaCGContextualizerBuilderTestCase >> strictContextualizer [

	^ self createContextualizer: CGStrictContextualizer
]

{ #category : 'helpers' }
FamixAbstractJavaCGContextualizerBuilderTestCase >> traceModel [

	^ self sourceResource traceModel
]
