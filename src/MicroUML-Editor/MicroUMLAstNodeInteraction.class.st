Class {
	#name : 'MicroUMLAstNodeInteraction',
	#superclass : 'RSInteraction',
	#instVars : [
		'box'
	],
	#category : 'MicroUML-Editor',
	#package : 'MicroUML-Editor'
}

{ #category : 'api' }
MicroUMLAstNodeInteraction >> contextMenuFor: aRSShape [

	aRSShape model ifNotNil: [ :model |
			(model isKindOf: MicroUMLClassNode) ifTrue: [
					^ model contextMenu addGroup: [ :group |
							  group
								  addItem: [ :item |
										  | attributeMenu |
										  attributeMenu := SpMenuPresenter new.
										  model attributesDo: [ :attributeNode |
													  attributeMenu addItem: [ :attributeNodeMenu |
																  attributeNodeMenu
																	  name: attributeNode name;
																	  subMenu: attributeNode contextMenu ] ].
										  item
											  name: 'attributes';
											  subMenu: attributeMenu ];
								  addItem: [ :item |
										  | methodMenu |
										  methodMenu := SpMenuPresenter new.
										  model methodsDo: [ :methodNode |
												  methodMenu addItem: [ :attributeNodeMenu |
														  attributeNodeMenu
															  name: methodNode name;
															  subMenu: methodNode contextMenu ] ].
										  item
											  name: 'methods';
											  subMenu: methodMenu ];
								  addItem: [ :item |
										  | associationMenu |
										  associationMenu := SpMenuPresenter new.
										  model diagram ifNotNil: [ :diagram |
												  diagram associationsDo: [ :associationNode |
														  associationNode leftClass = model name ifTrue: [
																  associationMenu addItem: [ :attributeNodeMenu |
																		  attributeNodeMenu
																			  name: 'with ' , associationNode rightClass;
																			  subMenu: associationNode contextMenu ] ].
														  associationNode rightClass = model name ifTrue: [
																  associationMenu addItem: [ :attributeNodeMenu |
																		  attributeNodeMenu
																			  name: 'with ' , associationNode leftClass;
																			  subMenu: associationNode contextMenu ] ] ] ].
										  item
											  name: 'associations';
											  subMenu: associationMenu ] ] ].
			(model isKindOf: MicroUMLMemberNode) ifTrue: [ ^ model contextMenu ].
			(model isKindOf: MicroUMLAssociationNode) ifTrue: [
				^ model contextMenu ] ].
	^ nil
]

{ #category : 'event handling' }
MicroUMLAstNodeInteraction >> mouseEnter: event [

	event shape encompassingRectangle ifNotNil: [ :rect |
			box ifNotNil: #remove.
			box := RSPolyline new
				       controlPoints: {
						       rect topLeft.
						       rect topRight.
						       rect bottomRight.
						       rect bottomLeft.
						       rect topLeft };
				       width: 5;
				       color: UITheme current selectionColor;
				       yourself.
			event shape parent add: box.
			event canvas signalUpdate ]
]

{ #category : 'event handling' }
MicroUMLAstNodeInteraction >> mouseLeave: event [

	box ifNotNil: #remove.
	box := nil.
	event canvas signalUpdate
]

{ #category : 'hooks' }
MicroUMLAstNodeInteraction >> onShape: aShape [
	"opens my context menu with a right click."

	aShape
		when: RSMouseRightClick do: [ :evt |
				(self contextMenuFor: evt shape) ifNotNil: [ :menu |
						menu openWithSpecAtPointer ] ]
		for: self;
		when: RSMouseLeave do: [ :evt | self mouseLeave: evt ] for: self;
		when: RSMouseEnter do: [ :evt | self mouseEnter: evt ] for: self
]
