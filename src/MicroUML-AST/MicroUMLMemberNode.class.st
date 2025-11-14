"
I represent an AST node for UML class operation.
I have name(symbol), argument types (array of symbol, or nil if omitted), and return type (symbol or nil if omitted).
My visibility is either #public or #private.
"
Class {
	#name : 'MicroUMLMemberNode',
	#superclass : 'MicroUMLAstNode',
	#instVars : [
		'name',
		'classNode',
		'visibility',
		'type',
		'isClassSide',
		'isAbstract'
	],
	#category : 'MicroUML-AST',
	#package : 'MicroUML-AST'
}

{ #category : 'testing' }
MicroUMLMemberNode class >> isAbstract [

	^ self = MicroUMLMemberNode
]

{ #category : 'adding' }
MicroUMLMemberNode >> addModifier: aSymbol [

	aSymbol = #abstract ifTrue: [
			isAbstract := true.
			^ aSymbol ].
	aSymbol = #static ifTrue: [
			isClassSide := true.
			^ aSymbol ].
	(#( public protected private ) includes: aSymbol) ifTrue: [
			visibility := aSymbol.
			^ aSymbol ].
	^ nil
]

{ #category : 'announcing' }
MicroUMLMemberNode >> announceDiagramChange [
	(classNode ifNotNil: #diagram) ifNotNil: #announceChange
]

{ #category : 'accessing' }
MicroUMLMemberNode >> beAbstract [

	isAbstract := true
]

{ #category : 'accessing' }
MicroUMLMemberNode >> beClassSide [

	isClassSide := true
]

{ #category : 'accessing' }
MicroUMLMemberNode >> beConcrete [

	isAbstract := false
]

{ #category : 'accessing' }
MicroUMLMemberNode >> beInstanceSide [

	isClassSide := false
]

{ #category : 'accessing' }
MicroUMLMemberNode >> bePrivate [

	visibility := #private
]

{ #category : 'accessing' }
MicroUMLMemberNode >> beProtected [

	visibility := #protected
]

{ #category : 'accessing' }
MicroUMLMemberNode >> bePublic [

	visibility := #public
]

{ #category : 'accessing' }
MicroUMLMemberNode >> classNode [

	^ classNode
]

{ #category : 'accessing' }
MicroUMLMemberNode >> classNode: aMicroUMLClassNode [

	classNode := aMicroUMLClassNode
]

{ #category : 'accessing' }
MicroUMLMemberNode >> defaultVisibility [

	^ self isMethod
		  ifTrue: [ #public ]
		  ifFalse: [ #protected ]
]

{ #category : 'initialization' }
MicroUMLMemberNode >> initialize [

	super initialize.
	isClassSide := false.
	isAbstract := false
]

{ #category : 'testing' }
MicroUMLMemberNode >> isAbstract [

	^ isAbstract = true
]

{ #category : 'testing' }
MicroUMLMemberNode >> isAttribute [

	^ self isMethod not
]

{ #category : 'testing' }
MicroUMLMemberNode >> isClassSide [

	^ isClassSide = true
]

{ #category : 'testing' }
MicroUMLMemberNode >> isConcrete [

	^ self isAbstract not
]

{ #category : 'testing' }
MicroUMLMemberNode >> isInstanceSide [

	^ self isClassSide not
]

{ #category : 'testing' }
MicroUMLMemberNode >> isMethod [

	^ self subclassResponsibility
]

{ #category : 'testing' }
MicroUMLMemberNode >> isMicroUMLMemberNode [

	^ true
]

{ #category : 'testing' }
MicroUMLMemberNode >> isPrivate [

	^ self visibility = #private
]

{ #category : 'testing' }
MicroUMLMemberNode >> isProtected [

	^ self visibility = #protected
]

{ #category : 'testing' }
MicroUMLMemberNode >> isPublic [

	^ self visibility = #public
]

{ #category : 'printing' }
MicroUMLMemberNode >> microUMLSource [

	^ String streamContents: [ :stream | self printMicroUMLOn: stream ]
]

{ #category : 'accessing' }
MicroUMLMemberNode >> modifiers [

	^ Array streamContents: [ :stream |
			  self isAbstract ifTrue: [ stream nextPut: #abstract ].
			  self isClassSide ifTrue: [ stream nextPut: #static ].
			  self visibility ~= self defaultVisibility ifTrue: [
				  stream nextPut: self visibility ] ]
]

{ #category : 'accessing' }
MicroUMLMemberNode >> modifiers: anArrayOfSymbol [

	isAbstract := anArrayOfSymbol includes: #abstract.
	isClassSide := anArrayOfSymbol includes: #static.
	(anArrayOfSymbol includes: #public) ifTrue: [ visibility := #public ].
	(anArrayOfSymbol includes: #protected) ifTrue: [
		visibility := #protected ].
	(anArrayOfSymbol includes: #private) ifTrue: [
		visibility := #private ]
]

{ #category : 'accessing' }
MicroUMLMemberNode >> name [

	^ name
]

{ #category : 'accessing' }
MicroUMLMemberNode >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
MicroUMLMemberNode >> renameClass: aSymbol to: anotherSymbol [

	type = aSymbol ifTrue: [ type := anotherSymbol ]
]

{ #category : 'enumerating' }
MicroUMLMemberNode >> symbolsDo: aBlock [

	type ifNotNil: aBlock
]

{ #category : 'accessing' }
MicroUMLMemberNode >> type [

	^ type
]

{ #category : 'accessing' }
MicroUMLMemberNode >> type: aSymbol [

	type := aSymbol
]

{ #category : 'accessing' }
MicroUMLMemberNode >> visibility [

	^ visibility ifNil: [ self defaultVisibility ]
]

{ #category : 'accessing' }
MicroUMLMemberNode >> visibility: aSymbol [

	visibility := aSymbol
]
