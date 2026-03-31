Class {
	#name : 'FamixAbstractJavaCGContextualizerBuilderTestResource',
	#superclass : 'TestResource',
	#instVars : [
		'graph',
		'javaMainModel',
		'librariesModels',
		'traceModel'
	],
	#category : 'Famix-CallGraphs-Contextualizer-Tests-Resources',
	#package : 'Famix-CallGraphs-Contextualizer-Tests',
	#tag : 'Resources'
}

{ #category : 'accessing' }
FamixAbstractJavaCGContextualizerBuilderTestResource class >> autoClasspathFile [

	| file |
	file := FamixCallGraphContextualizerBridge sources
	        / ('libs' , self sourcePath asFileReference basename) .
	file exists ifFalse: [ self buildExternalDependencies ].

	^ file asFileLocatorOrReference
]

{ #category : 'accessing' }
FamixAbstractJavaCGContextualizerBuilderTestResource class >> buildExternalDependencies [
	"Compile external java files and package them into a jar automatically"

	| sourcesPath cmd libsDir |
	"Retrieve configuration"
	sourcesPath := FamixCallGraphContextualizerBridge sources fullName.
	libsDir := 'libs' , self sourcePath asFileLocatorOrReference basename.

	"Build the shell command using a stream for readability and performance"
	cmd := String streamContents: [ :stream | 
					"1. Navigate to the root sources folder safely using quotes"
			       stream << 'cd "' << sourcesPath << '" && '.

			       "2. Create the target library directory if it does not exist"
			       stream << 'mkdir -p ' << libsDir << ' && '.

			       "3. Create jar of each external dependencies"
			       self externalSourcesFolders do: [ :each | 
							"3.1. Compile java sources. No quotes around the path to allow *.java expansion"
					       stream << 'javac ' << each basename << '/*.java && '.

					       "3.2. Package compiled classes into a jar file inside the libs folder"
					       stream << 'jar cvf ' << libsDir << '/' << each basename << '.jar ' << each basename << '/*.class' ] ].

	"Execute the built command"
	LibC runCommand: cmd
]

{ #category : 'as yet unclassified' }
FamixAbstractJavaCGContextualizerBuilderTestResource class >> externalSourcesFolders [
	"Return the java folders containing the external sources to parse for those tests"

	| folders |
	folders := (FamixCallGraphContextualizerBridge sources children select: #isDirectory) select: [ :each |
		           each basename includesSubstring: self sourcePath asFileReference basename , 'External' ].
	^ folders
]

{ #category : 'accessing' }
FamixAbstractJavaCGContextualizerBuilderTestResource class >> javaExternalSourcesFolders [
	"Return the java folder containing the sources to parse for those tests"

	| folders |
	folders := self externalSourcesFolders.

	folders do: [ :each | each ifAbsent: [ self error: 'Folder does not exists ' , each pathString ] ].

	^ folders
]

{ #category : 'accessing' }
FamixAbstractJavaCGContextualizerBuilderTestResource class >> javaSourcesFolder [
	"Return the java folder containing the sources to parse for those tests"

	| folder |
	folder := self sourcesFolder.

	folder ifAbsent: [ self error: 'Folder does not exists ' , folder pathString ].

	^ folder
]

{ #category : 'accessing' }
FamixAbstractJavaCGContextualizerBuilderTestResource class >> sourcePath [

	^ (FamixCallGraphContextualizerBridge sources
	  / ((self name withoutPrefix: 'CGContextualizer') withoutSuffix: 'Resource') uncapitalized) pathString 
]

{ #category : 'accessing' }
FamixAbstractJavaCGContextualizerBuilderTestResource class >> sourcesFolder [
	"Return the java folder containing the sources to parse for those tests"

	| folder |
	folder := self sourcePath asFileReference.

	folder ifAbsent: [ self error: 'Folder does not exists ' , folder pathString ].

	^ folder
]

{ #category : 'accessing' }
FamixAbstractJavaCGContextualizerBuilderTestResource class >> traceFile [
	"Return the java file containing the sources to parse for those tests"

	| file |
	file := self sourcesFolder
	        / (((self name withoutPrefix: 'CGContextualizer') withoutSuffix: 'Resource') uncapitalized , '.tr').

	file ifAbsent: [ self error: 'File does not exists ' , file pathString ].

	^ file
]

{ #category : 'accessing' }
FamixAbstractJavaCGContextualizerBuilderTestResource >> entryPoints [

	^ javaMainModel allMethods select: [ :method | method name = 'main' ]
]

{ #category : 'accessing' }
FamixAbstractJavaCGContextualizerBuilderTestResource >> javaExternalSourcesFolders [

	^ self class javaExternalSourcesFolders
]

{ #category : 'accessing' }
FamixAbstractJavaCGContextualizerBuilderTestResource >> javaMainModel [

	^ javaMainModel
]

{ #category : 'accessing' }
FamixAbstractJavaCGContextualizerBuilderTestResource >> javaSourcesFolder [
	^ self class javaSourcesFolder
]

{ #category : 'accessing' }
FamixAbstractJavaCGContextualizerBuilderTestResource >> librariesModels [
	
	^ librariesModels
]

{ #category : 'accessing' }
FamixAbstractJavaCGContextualizerBuilderTestResource >> setUp [

	super setUp.
	javaMainModel := (FamixJavaFoldersImporter new
		                  autoClasspath: (self class autoClasspathFile ifAbsent: [ nil ]);
		                  folders: { self javaSourcesFolder };
		                  import) anyOne.

	traceModel := JavaTraceJsonReader import: self traceFile.

	librariesModels := FamixJavaFoldersImporter new
		                   folders: self javaExternalSourcesFolders;
		                   import
]

{ #category : 'accessing' }
FamixAbstractJavaCGContextualizerBuilderTestResource >> tearDown [

	javaMainModel := nil.
	graph := nil.
	traceModel := nil.
	librariesModels := nil.

	super tearDown
]

{ #category : 'accessing' }
FamixAbstractJavaCGContextualizerBuilderTestResource >> traceFile [

	^ self class traceFile
]

{ #category : 'accessing' }
FamixAbstractJavaCGContextualizerBuilderTestResource >> traceModel [

	^ traceModel
]
