Class {
	#name : 'MicroUMLAttributeNode',
	#superclass : 'MicroUMLMemberNode',
	#category : 'MicroUML-AST',
	#package : 'MicroUML-AST'
}

{ #category : 'menu operations' }
MicroUMLAttributeNode >> changeType [

	| oldType |
	oldType := self type ifNil: [ '' ].
	(self
		 request: 'Type'
		 initialAnswer: oldType
		 title: 'Change type of ' , self name) ifNotNil: [ :answer |
			self type:
				(answer trim capitalized ifNotEmpty: #asSymbol ifEmpty: [ nil ]).
			self announceDiagramChange ]
]

{ #category : 'menus' }
MicroUMLAttributeNode >> contextMenu [

	^ SpMenuPresenter new
		  title: self name;
		  addGroup: [ :group |
				  group addItem: [ :item |
							  item
								  name: 'Rename...';
								  action: [ self rename ] ] ];
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
				  group addItem: [ :item |
						  item
							  name: 'Change type...';
							  action: [ self changeType ] ] ];
		  yourself
]

{ #category : 'testing' }
MicroUMLAttributeNode >> isMethod [

	^ false
]

{ #category : 'printing' }
MicroUMLAttributeNode >> printMicroUMLOn: aStream [
	" #argumentTypes  . #type   "

	aStream nextPutAll: (self isMethod
			 ifTrue: [ '> ' ] ifFalse: [ '- ' ]).
	self name storeOn: aStream.
	self type ifNotNil: [ :symbol |
			aStream nextPutAll: ' @ '.
			symbol storeOn: aStream ].
	self modifiers ifNotNil: [ :symbols |
			symbols do: [ :symbol |
					aStream nextPutAll: ' % '.
					symbol storeOn: aStream ] ]
]

{ #category : 'menu operations' }
MicroUMLAttributeNode >> rename [

	| oldName |
	oldName := self name.
	(self
		 request: 'New name for the attribute'
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
