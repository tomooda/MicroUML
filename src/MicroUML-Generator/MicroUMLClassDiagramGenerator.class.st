Class {
	#name : 'MicroUMLClassDiagramGenerator',
	#superclass : 'Object',
	#instVars : [
		'diagram',
		'classNames'
	],
	#category : 'MicroUML-Generator',
	#package : 'MicroUML-Generator'
}

{ #category : 'utilities' }
MicroUMLClassDiagramGenerator class >> classDiagramFromClasses: aCollectionOfClass [

	| diagramGenerator |
	diagramGenerator := self new.
	diagramGenerator generateClasses: aCollectionOfClass.
	^ diagramGenerator diagram
]

{ #category : 'utilities' }
MicroUMLClassDiagramGenerator class >> classDiagramFromPackage: aPackage [

	| diagramGenerator |
	diagramGenerator := self new.
	diagramGenerator generateClasses: aPackage definedClasses.
	aPackage extensionMethods do: [ :method |
			diagramGenerator
				generateMethod: method selector
				in: method methodClass ].
	^ diagramGenerator diagram
]

{ #category : 'utilities' }
MicroUMLClassDiagramGenerator class >> classDiagramFromPackageNamed: aString [

	^ (self packageOrganizer packageNamed: aString ifAbsent: [ nil ])
		  ifNotNil: [ :package | self classDiagramFromPackage: package ]
]

{ #category : 'examples' }
MicroUMLClassDiagramGenerator class >> example [

	(MicroUMLRoassalBuilder new classDiagramNode: (self new
				  generateClass: self;
				  ensureClassNamed: self superclass name;
				  diagram)) build
		zoomToFit;
		@ RSCanvasController;
		openWithTitle: self name
]

{ #category : 'examples' }
MicroUMLClassDiagramGenerator class >> exampleArrayHierarchy [

	(MicroUMLRoassalBuilder new classDiagramNode: (self new
				  generateClass: ArrayedCollection;
				  generateClass: Array;
				  generateClass: Float64Array;
				  generateClass: IntegerArray;
				  generateClass: PointArray;
				  diagram)) build
		zoomToFit;
		@ RSCanvasController;
		openWithTitle: self name
]

{ #category : 'examples' }
MicroUMLClassDiagramGenerator class >> exampleClassHierarchy [

	(MicroUMLRoassalBuilder new classDiagramNode: (self new
				  generateClass: ReadStream;
				  generateClass: WriteStream;
				  generateClass: ReadWriteStream;
				  generateClass: PositionableStream;				
				  diagram)) build
		zoomToFit;
		@ RSCanvasController;
		openWithTitle: self name
]

{ #category : 'examples' }
MicroUMLClassDiagramGenerator class >> exampleOrderedCollection [

	| diagram |
	diagram := self new
		           generateClasses: {
				           SequenceableCollection.
				           ArrayedCollection.
				           Array.
				           OrderedCollection };
		           diagram.
	diagram classesDo: [ :class | class removeAllMembers ].
	(MicroUMLRoassalBuilder new classDiagramNode: diagram) build
		zoomToFit;
		@ RSCanvasController;
		openWithTitle: self name
]

{ #category : 'class access' }
MicroUMLClassDiagramGenerator >> associationNodeClass [

	^ MicroUMLAssociationNode
]

{ #category : 'class access' }
MicroUMLClassDiagramGenerator >> classDiagramClass [

	^ MicroUMLClassDiagramNode
]

{ #category : 'accessing' }
MicroUMLClassDiagramGenerator >> classNames: aCollectionOfSymbols [

	classNames := aCollectionOfSymbols asSet
]

{ #category : 'class access' }
MicroUMLClassDiagramGenerator >> classNodeClass [

	^ MicroUMLClassNode
]

{ #category : 'accessing' }
MicroUMLClassDiagramGenerator >> diagram [

	^ diagram
]

{ #category : 'accessing' }
MicroUMLClassDiagramGenerator >> ensureClass: aClass [

	^ self ensureClassNamed: aClass name
]

{ #category : 'accessing' }
MicroUMLClassDiagramGenerator >> ensureClassNamed: aSymbol [

	^ diagram ensureClassNamed: aSymbol
]

{ #category : 'generating' }
MicroUMLClassDiagramGenerator >> generateAttribute: aSymbol in: aClass [

	| type attributeNode |
	(self guessAssociation: aSymbol) ifNotNil: [ :association |
			association
				leftClass: aClass instanceSide name;
				rightLabel: aSymbol;
				rightHead: #arrowhead.
			diagram addAssociation: association.
			^ association ].
	type := nil.
	aClass
		compiledMethodAt: (aSymbol , ':') asSymbol
		ifPresent: [ :compiledMethod |
				| parameter |
				parameter := compiledMethod ast arguments first name asString.
				(self guessAssociation: parameter) ifNotNil: [ :association |
						association
							leftClass: aClass instanceSide name;
							rightLabel: aSymbol.
						diagram addAssociation: association.
						^ association ].
				type := self guessParameterType: parameter ].
	attributeNode := (diagram ensureClassNamed:
		                  aClass instanceSide name asSymbol) addAttribute:
		                 aSymbol asSymbol.
	type ifNotNil: [ attributeNode type: type ].
	aClass isMeta
		ifTrue: [ attributeNode beClassSide ]
		ifFalse: [ attributeNode beInstanceSide ].
	^ attributeNode
]

{ #category : 'generating' }
MicroUMLClassDiagramGenerator >> generateClass: aClass [

	| class classNode |
	class := aClass instanceSide.
	classNode := diagram ensureClassNamed: class name asSymbol.
	class superclass ifNotNil: [ :s |
		classNode superclass: s name asSymbol ].
	class traits do: [ :trait | classNode addTrait: trait name ].
	class instVarNames do: [ :var |
		self generateAttribute: var asSymbol in: class ].
	class class instVarNames do: [ :var |
		self generateAttribute: var asSymbol in: class class ].
	class selectors do: [ :selector |
		self generateMethod: selector asSymbol in: class ].
	class class selectors do: [ :selector |
		self generateMethod: selector asSymbol in: class class ].
	^ classNode
]

{ #category : 'generating' }
MicroUMLClassDiagramGenerator >> generateClasses: aCollectionOfClass [

	classNames addAll: (aCollectionOfClass collect: #name).
	aCollectionOfClass do: [ :class | self generateClass: class ]
]

{ #category : 'generating' }
MicroUMLClassDiagramGenerator >> generateMethod: aSymbol in: aClass [

	| methodNode |
	methodNode := (diagram ensureClassNamed:
		               aClass instanceSide name asSymbol) addMethod:
		              aSymbol asSymbol.
	aClass
		compiledMethodAt: aSymbol asSymbol
		ifPresent: [ :compiledMethod |
				methodNode argumentTypes:
					(compiledMethod ast arguments collect: [ :arg |
						 self guessParameterType: arg name ]) asArray.
				compiledMethod isAbstract ifTrue: [
					methodNode addModifier: #abstract ] ].
	aClass isMeta
		ifTrue: [ methodNode beClassSide ]
		ifFalse: [ methodNode beInstanceSide ].
	^ methodNode
]

{ #category : 'private' }
MicroUMLClassDiagramGenerator >> guessAssociation: aString [

	| name multiplicity |
	multiplicity := nil.
	name := aString withoutPrefixFollowedByUppercase: 'a'.
	name := name withoutPrefixFollowedByUppercase: 'an'.
	name withoutPrefix: 'CollectionOf' ifFollowedByUppercase: [ :n |
			name := n.
			multiplicity := '*' ].
	name
		withoutPrefix: 'OrderedCollectionOf'
		ifFollowedByUppercase: [ :n |
				name := n.
				multiplicity := '*' ].
	name withoutPrefix: 'ArrayOf' ifFollowedByUppercase: [ :n |
			name := n.
			multiplicity := '*' ].
	name withoutPrefix: 'SetOf' ifFollowedByUppercase: [ :n |
			name := n.
			multiplicity := '*' ].
	name := name capitalized.
	^ (classNames includes: name)
		  ifTrue: [
				  self associationNodeClass new
					  rightClass: name;
					  rightMultiplicity: multiplicity;
					  beAggregation;
					  yourself ]
		  ifFalse: [ nil ]
]

{ #category : 'private' }
MicroUMLClassDiagramGenerator >> guessParameterType: aString [

	aString
		withoutPrefix: 'a'
		ifFollowedByUppercase: [ :name | ^ name asSymbol ].
	aString
		withoutPrefix: 'an'
		ifFollowedByUppercase: [ :name | ^ name asSymbol ].
	^ aString asSymbol
]

{ #category : 'initialization' }
MicroUMLClassDiagramGenerator >> initialize [

	super initialize.
	classNames := Set new.
	diagram := self classDiagramClass new
]
