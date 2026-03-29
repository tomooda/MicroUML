Class {
	#name : 'MicroUMLAstNode',
	#superclass : 'Object',
	#category : 'MicroUML-AST',
	#package : 'MicroUML-AST'
}

{ #category : 'icons' }
MicroUMLAstNode >> addIcon [

	^ self application iconNamed: #add
]

{ #category : 'dialog' }
MicroUMLAstNode >> alert: aString [

	self application alert: aString
]

{ #category : 'dialog' }
MicroUMLAstNode >> application [

	^ SpApplication defaultApplication
]

{ #category : 'accessing' }
MicroUMLAstNode >> children [

	^ OrderedCollection empty
]

{ #category : 'dialog' }
MicroUMLAstNode >> confirm: aString [

	^ self application confirm: aString
]

{ #category : 'dialog' }
MicroUMLAstNode >> confirm: aString title: anotherString [

	^ self application newConfirm
		  title: anotherString;
		  label: aString;
		  openModal
]

{ #category : 'icons' }
MicroUMLAstNode >> iconNamed: aSymbol [

	^ self application iconNamed: aSymbol
]

{ #category : 'as yet unclassified' }
MicroUMLAstNode >> inspectionAST: aBuilder [
	<inspectorPresentationOrder: 35 title: 'AST'>

	^ aBuilder newTree 
		addStyle: 'stTree';
		roots: { self };
		children: [ :aNode |
			aNode isMicroUMLAstNode
				ifTrue: [ aNode children ]
				ifFalse: [ #() ] ];
		yourself
]

{ #category : 'testing' }
MicroUMLAstNode >> isMicroUMLAstNode [

	^ true
]

{ #category : 'printing' }
MicroUMLAstNode >> microUML [

	^ String streamContents: [ :stream | self printMicroUMLOn: stream ]
]

{ #category : 'printing' }
MicroUMLAstNode >> printMicroUMLOn: aStream [

	^ self subclassResponsibility
]

{ #category : 'icons' }
MicroUMLAstNode >> removeIcon [

	^ self application iconNamed: #remove
]

{ #category : 'accessing' }
MicroUMLAstNode >> renameClass: aSymbol to: anotherSymbol [

	^ self subclassResponsibility
]

{ #category : 'dialog' }
MicroUMLAstNode >> request: aString initialAnswer: anotherString title: titleString [

	^ self application newRequest
		  title: titleString;
		  label: aString;
		  text: anotherString;
		  openModal
]

{ #category : 'enumerating' }
MicroUMLAstNode >> symbolsDo: aBlock [

	^ self subclassResponsibility
]
