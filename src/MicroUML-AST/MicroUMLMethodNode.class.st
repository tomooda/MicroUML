Class {
	#name : 'MicroUMLMethodNode',
	#superclass : 'MicroUMLMemberNode',
	#instVars : [
		'argumentTypes'
	],
	#category : 'MicroUML-AST',
	#package : 'MicroUML-AST'
}

{ #category : 'accessing' }
MicroUMLMethodNode >> argumentTypes [

	^ argumentTypes
]

{ #category : 'accessing' }
MicroUMLMethodNode >> argumentTypes: anArrayOfSymbol [

	argumentTypes := anArrayOfSymbol
]

{ #category : 'menu operations' }
MicroUMLMethodNode >> changeArgumentTypes [

	| oldTypes |
	oldTypes := self argumentTypes
		            ifNil: [ '' ]
		            ifNotNil: [ :types | ', ' join: types ].
	(self
		 request: 'Argument types (separate by commas)'
		 initialAnswer: oldTypes
		 title: 'Change argument types of ' , self name) ifNotNil: [ :answer |
			answer trim ifNotEmpty: [ :newTypes |
					self argumentTypes:
						((newTypes substrings: ',') collect: [ :typeName |
							 typeName capitalized asSymbol ]).
					self announceDiagramChange ] ]
]

{ #category : 'menu operations' }
MicroUMLMethodNode >> changeType [

	| oldType |
	oldType := self type ifNil: [ '' ].
	(self
		 request: 'Return type'
		 initialAnswer: oldType
		 title: 'Change return type of ' , self name) ifNotNil: [ :answer |
			self type:
				(answer trim capitalized ifNotEmpty: #asSymbol ifEmpty: [ nil ]).
			self announceDiagramChange ]
]

{ #category : 'menus' }
MicroUMLMethodNode >> contextMenu [

	^ SpMenuPresenter new
		  title: self name;
		  addGroup: [ :group |
				  group
					  addItem: [ :item |
							  item
								  name: 'Rename...';
								  action: [ self rename ] ];
					  addItem: [ :item |
							  item
								  name: 'Remove';
								  icon: self removeIcon;
								  action: [ self remove ] ] ];
		  addGroup: [ :group |
				  self isPublic ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be public';
									  action: [
											  self bePublic.
											  self announceDiagramChange ] ] ].
				  self isProtected ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be protected';
									  action: [
											  self beProtected.
											  self announceDiagramChange ] ] ].
				  self isPrivate ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be private';
									  action: [
											  self bePrivate.
											  self announceDiagramChange ] ] ].
				  group
					  addItem: [ :item |
							  self isAbstract
								  ifTrue: [
										  item
											  name: 'Be implementation';
											  action: [
													  self beConcrete.
													  self announceDiagramChange ] ]
								  ifFalse: [
										  item
											  name: 'Be abstract';
											  action: [
													  self beAbstract.
													  self announceDiagramChange ] ] ];
					  addItem: [ :item |
							  self isClassSide
								  ifTrue: [
										  item
											  name: 'Be instance side';
											  action: [
													  self beInstanceSide.
													  self announceDiagramChange ] ]
								  ifFalse: [
										  item
											  name: 'Be class side';
											  action: [
													  self beClassSide.
													  self announceDiagramChange ] ] ] ];
		  addGroup: [ :group |
				  group
					  addItem: [ :item |
							  item
								  name: 'Change argument type...';
								  action: [ self changeArgumentTypes ] ];
					  addItem: [ :item |
							  item
								  name: 'Change return type...';
								  action: [ self changeType ] ] ];
		  yourself
]

{ #category : 'testing' }
MicroUMLMethodNode >> isMethod [

	^ true
]

{ #category : 'printing' }
MicroUMLMethodNode >> printMicroUMLOn: aStream [
	" #argumentTypes  . #type   "

	aStream nextPutAll: (self isMethod
			 ifTrue: [ '> ' ] ifFalse: [ '- ' ]).
	self name storeOn: aStream.
	self argumentTypes ifNotNil: [ :symbols |
			aStream nextPutAll: ' ~#('.
			symbols
				do: [ :symbol | aStream nextPutAll: symbol ]
				separatedBy: [ aStream space ].
			aStream nextPutAll: ')' ].
	self type ifNotNil: [ :symbol |
			aStream nextPutAll: ' @ '.
			symbol storeOn: aStream ].
	self modifiers ifNotNil: [ :symbols |
			symbols do: [ :symbol |
					aStream nextPutAll: ' % '.
					symbol storeOn: aStream ] ]
]

{ #category : 'menu operations' }
MicroUMLMethodNode >> rename [

	| oldName |
	oldName := self name.
	(self
		 request: 'New name for the method'
		 initialAnswer: oldName
		 title: 'Rename ' , oldName) ifNotNil: [ :answer |
			answer trim ifNotEmpty: [ :newName |
					(classNode ifNil: [ self ]) symbolsDo: [ :symbol |
							symbol = newName ifTrue: [
									^ self alert:
										  'The name ' , newName
										  , ' is already used. Try another one.' ] ].
					self name: newName asSymbol.
					self announceDiagramChange ] ]
]

{ #category : 'accessing' }
MicroUMLMethodNode >> renameClass: aSymbol to: anotherSymbol [

	super renameClass: aSymbol to: anotherSymbol.
	(argumentTypes notNil and: [ argumentTypes includes: aSymbol ])
		ifTrue: [
				argumentTypes := argumentTypes
					                 copyReplaceAll: aSymbol
					                 with: anotherSymbol ]
]

{ #category : 'enumerating' }
MicroUMLMethodNode >> symbolsDo: aBlock [

	super symbolsDo: aBlock.
	argumentTypes ifNotNil: [ argumentTypes do: aBlock ]
]
