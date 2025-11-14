"
I represent an association between two classes.
One class is called *left* while the other is *right*.
I store and answer the multiplicity of each class.
Multiplicity is nil iff no multiplicity is set to the class.
"
Class {
	#name : 'MicroUMLAssociationNode',
	#superclass : 'MicroUMLAstNode',
	#instVars : [
		'diagram',
		'leftClass',
		'leftHead',
		'leftLabel',
		'rightClass',
		'rightHead',
		'rightLabel',
		'label',
		'leftMultiplicity',
		'rightMultiplicity',
		'associationClass',
		'line'
	],
	#category : 'MicroUML-AST',
	#package : 'MicroUML-AST'
}

{ #category : 'accessing' }
MicroUMLAssociationNode >> addLabel: aStringOrAssociation [

	aStringOrAssociation isString ifTrue: [
			self label: aStringOrAssociation.
			^ aStringOrAssociation ].
	aStringOrAssociation isAssociation ifTrue: [
			self leftLabel: aStringOrAssociation key.
			self rightLabel: aStringOrAssociation value.
			^ aStringOrAssociation ].
	^ nil
]

{ #category : 'announcing' }
MicroUMLAssociationNode >> announceDiagramChange [

	^ diagram ifNotNil: #announceChange
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> associationClass [

	^ associationClass
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> associationClass: aSymbol [

	associationClass := aSymbol
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> beAggregation [

	leftHead := #aggregation
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> beComposition [

	leftHead := #composition
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> beDashed [

	line := #dashed
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> beDependency [

	leftHead := nil.
	rightHead := #wedge.
	line := #dashed
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> beDirected [

	rightHead := #wedge
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> beNoAggregation [

	leftHead := nil
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> beNotDirected [

	rightHead := nil
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> beSolid [

	line := #solid
]

{ #category : 'menu operations' }
MicroUMLAssociationNode >> changeLabel [

	(self
		 request: 'New label'
		 initialAnswer: (self label ifNil: [ '' ])
		 title: 'Change label') ifNotNil: [ :answer |
			self label: (answer trim ifEmpty: [ nil ]).
			self announceDiagramChange ]
]

{ #category : 'menu operations' }
MicroUMLAssociationNode >> changeLeftLabel [

	(self
		 request: 'New role of ' , leftClass
		 initialAnswer: (self leftLabel ifNil: [ '' ])
		 title: 'Change role') ifNotNil: [ :answer |
			answer trim ifNotEmpty: [ :newLabel |
					self leftLabel: newLabel.
					self announceDiagramChange ] ]
]

{ #category : 'menu operations' }
MicroUMLAssociationNode >> changeLeftMultiplicity [

	(self
		 request: 'New multiplicity on ' , leftClass
		 initialAnswer: (self leftMultiplicity ifNil: [ '' ])
		 title: 'Change multiplicity') ifNotNil: [ :answer |
			answer trim ifNotEmpty: [ :newMultiplicity |
					self leftMultiplicity: newMultiplicity.
					self announceDiagramChange ] ]
]

{ #category : 'menu operations' }
MicroUMLAssociationNode >> changeRightLabel [

	(self
		 request: 'New role of ' , rightClass
		 initialAnswer: (self rightLabel ifNil: [ '' ])
		 title: 'Change role') ifNotNil: [ :answer |
			answer trim ifNotEmpty: [ :newLabel |
					self rightLabel: newLabel.
					self announceDiagramChange ] ]
]

{ #category : 'menu operations' }
MicroUMLAssociationNode >> changeRightMultiplicity [

	(self
		 request: 'New multiplicity on ' , rightClass
		 initialAnswer: (self rightMultiplicity ifNil: [ '' ])
		 title: 'Change multiplicity') ifNotNil: [ :answer |
			answer trim ifNotEmpty: [ :newMultiplicity |
					self rightMultiplicity: newMultiplicity.
					self announceDiagramChange ] ]
]

{ #category : 'menus' }
MicroUMLAssociationNode >> contextMenu [

	^ SpMenuPresenter new
		  title: leftClass , ' - ' , rightClass;
		  addGroup: [ :group |
				  self isAggregation ifFalse: [
							  group addItem: [ :item |
										  item
											  name: 'Be aggregation';
											  action: [
													  self
														  beAggregation;
														  announceDiagramChange ] ] ].
				  self isComposition ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be composition';
									  action: [
											  self
												  beComposition;
												  announceDiagramChange ] ] ].
				  self isNoAggregation ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be non-aggregation';
									  action: [
											  self
												  beNoAggregation;
												  announceDiagramChange ] ] ].
				  self isDependency ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be dependency';
									  action: [
											  self
												  beDependency;
												  announceDiagramChange ] ] ].
				  self isDirected
					  ifTrue: [
							  group addItem: [ :item |
									  item
										  name: 'Be not directed';
										  action: [
												  self
													  beNotDirected;
													  announceDiagramChange ] ] ]
					  ifFalse: [
							  group addItem: [ :item |
									  item
										  name: 'Be directed';
										  action: [
												  self
													  beDirected;
													  announceDiagramChange ] ] ].
				  self isSolid ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be solid line';
									  action: [
											  self
												  beSolid;
												  announceDiagramChange ] ] ].
				  self isDashed ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be dashed line';
									  action: [
											  self
												  beDashed;
												  announceDiagramChange ] ] ] ];
		  addGroup: [ :group |
				  group
					  addItem: [ :item |
							  item
								  name: leftClass;
								  subMenu: self contextMenuOnLeft ];
					  addItem: [ :item |
							  item
								  name: rightClass;
								  subMenu: self contextMenuOnRight ];
					  addItem: [ :item |
							  item
								  name: 'Change label...';
								  action: [ self changeLabel ] ] ];
		  yourself
]

{ #category : 'menus' }
MicroUMLAssociationNode >> contextMenuOnLeft [

	^ SpMenuPresenter new
		  addGroup: [ :group |
				  group
					  addItem: [ :item |
							  | menu |
							  menu := SpMenuPresenter new.
							  diagram ifNotNil: [
										  diagram classesDo: [ :classNode |
													  classNode name ~= leftClass ifTrue: [
																  menu addItem: [ :classItem |
																			  classItem
																				  name: classNode name;
																				  action: [
																						  diagram ifNotNil: [
																								  diagram removeAssociation: self ].
																						  self leftClass: classNode name.
																						  diagram ifNotNil: [
																								  diagram addAssociation: self ].
																						  self announceDiagramChange ] ] ] ] ].
							  item
								  name: 'Reconnect to';
								  subMenu: menu ];
					  addItem: [ :item |
							  item
								  name: 'Change role';
								  action: [ self changeLeftLabel ] ];
					  addItem: [ :item |
							  item
								  name: 'Change multiplicity';
								  action: [ self changeLeftMultiplicity ] ] ];
		  yourself
]

{ #category : 'menus' }
MicroUMLAssociationNode >> contextMenuOnRight [

	^ SpMenuPresenter new
		  addGroup: [ :group |
				  group
					  addItem: [ :item |
							  | menu |
							  menu := SpMenuPresenter new.
							  diagram ifNotNil: [
										  diagram classesDo: [ :classNode |
													  classNode name ~= rightClass ifTrue: [
																  menu addItem: [ :classItem |
																			  classItem
																				  name: classNode name;
																				  action: [
																						  self rightClass: classNode name.
																						  self announceDiagramChange ] ] ] ] ].
							  item
								  name: 'Reconnect to';
								  subMenu: menu ];
					  addItem: [ :item |
							  item
								  name: 'Change role';
								  action: [ self changeRightLabel ] ];
					  addItem: [ :item |
							  item
								  name: 'Change multiplicity';
								  action: [ self changeRightMultiplicity ] ] ];
		  yourself
]

{ #category : 'defaults' }
MicroUMLAssociationNode >> defaultLine [

	^ #solid
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> diagram [

	^ diagram
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> diagram: aMicroUMLDiagramNode [

	diagram := aMicroUMLDiagramNode
]

{ #category : 'testing' }
MicroUMLAssociationNode >> isAggregation [

	^ leftHead = #aggregation
]

{ #category : 'testing' }
MicroUMLAssociationNode >> isComposition [

	^ leftHead = #composition
]

{ #category : 'testing' }
MicroUMLAssociationNode >> isDashed [

	^ line = #dashed
]

{ #category : 'testing' }
MicroUMLAssociationNode >> isDependency [

	^ leftHead isNil and: [ rightHead = #wedge and: [ line = #dashed ] ]
]

{ #category : 'testing' }
MicroUMLAssociationNode >> isDirected [

	^ rightHead = #wedge
]

{ #category : 'testing' }
MicroUMLAssociationNode >> isNoAggregation [

	^ leftHead isNil
]

{ #category : 'testing' }
MicroUMLAssociationNode >> isSolid [

	^ line = #solid or: [ line isNil ]
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> label [

	^ label
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> label: aString [

	label := aString
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> leftClass [

	^ leftClass
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> leftClass: aSymbol [

	leftClass := aSymbol
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> leftHead [

	^ leftHead
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> leftHead: aSymbolOrNil [

	leftHead := aSymbolOrNil
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> leftLabel [

	^ leftLabel
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> leftLabel: aStringOrNil [

	leftLabel := aStringOrNil
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> leftMultiplicity [

	^ leftMultiplicity
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> leftMultiplicity: aString [

	leftMultiplicity := aString
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> line [

	^ line ifNil: [ self defaultLine ]
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> line: aSymbol [

	line := aSymbol
]

{ #category : 'printing' }
MicroUMLAssociationNode >> microUMLSource [

	^ String streamContents: [ :stream | self printMicroUMLOn: stream ]
]

{ #category : 'printing' }
MicroUMLAssociationNode >> printMicroUMLAssociationClassOn: aStream [

	self associationClass ifNotNil: [
			aStream nextPutAll: '  @= '.
			self associationClass storeOn: aStream.
			aStream cr ]
]

{ #category : 'printing' }
MicroUMLAssociationNode >> printMicroUMLInLeftClassOn: aStream [

	self printMicroUMLLinkOn: aStream.
	rightClass storeOn: aStream.
	self
		printMicroUMLLabelsOn: aStream;
		printMicroUMLMultiplicityOn: aStream;
		printMicroUMLAssociationClassOn: aStream
]

{ #category : 'printing' }
MicroUMLAssociationNode >> printMicroUMLLabelsOn: aStream [

	self label ifNotNil: [
			aStream
				cr;
				nextPutAll: '  @ '.
			self label storeOn: aStream ].
	(self leftLabel notNil or: [ self rightLabel notNil ]) ifTrue: [
			aStream
				cr;
				nextPutAll: '  @ '.
			self leftLabel -> self rightLabel storeOn: aStream ]
]

{ #category : 'printing' }
MicroUMLAssociationNode >> printMicroUMLLinkOn: aStream [

	self leftHead = #aggregation ifTrue: [ aStream nextPutAll: '<>' ].
	self leftHead = #composition ifTrue: [ aStream nextPutAll: '*' ].
	self rightHead ifNil: [ aStream nextPutAll: '-- ' ].
	self rightHead = #wedge ifTrue: [
			self line = #solid ifTrue: [ aStream nextPutAll: '=> ' ].
			self line = #dashed ifTrue: [ aStream nextPutAll: '--> ' ] ]
]

{ #category : 'printing' }
MicroUMLAssociationNode >> printMicroUMLMultiplicityOn: aStream [

	self leftMultiplicity ifNotNil: [
			aStream
				cr;
				nextPutAll: '  %< '.
			self leftMultiplicity storeOn: aStream ].
	self rightMultiplicity ifNotNil: [
			aStream
				cr;
				nextPutAll: '  %> '.
			self rightMultiplicity storeOn: aStream ]
]

{ #category : 'printing' }
MicroUMLAssociationNode >> printMicroUMLOn: aStream [

	leftClass storeOn: aStream.
	aStream space.
	self printMicroUMLInLeftClassOn: aStream
]

{ #category : 'testing' }
MicroUMLAssociationNode >> refersToName: aSymbol [

	^ leftClass = aSymbol or: [
		  rightClass = aSymbol or: [ associationClass = aSymbol ] ]
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> renameClass: aSymbol to: anotherSymbol [

	leftClass = aSymbol ifTrue: [ leftClass := anotherSymbol ].
	rightClass = aSymbol ifTrue: [ rightClass := anotherSymbol ].
	associationClass = aSymbol ifTrue: [
		associationClass := anotherSymbol ]
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> rightClass [

	^ rightClass
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> rightClass: aSymbol [

	rightClass := aSymbol
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> rightHead [

	^ rightHead
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> rightHead: aSymbolOrNil [

	rightHead := aSymbolOrNil
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> rightLabel [

	^ rightLabel
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> rightLabel: aStringOrNil [

	rightLabel := aStringOrNil
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> rightMultiplicity [

	^ rightMultiplicity
]

{ #category : 'accessing' }
MicroUMLAssociationNode >> rightMultiplicity: aString [

	rightMultiplicity := aString
]

{ #category : 'enumerating' }
MicroUMLAssociationNode >> symbolsDo: aBlock [

	aBlock
		value: leftClass;
		value: rightClass;
		value: associationClass
]
