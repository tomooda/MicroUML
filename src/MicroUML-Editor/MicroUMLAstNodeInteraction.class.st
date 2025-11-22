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
			(model isKindOf: MicroUMLClassNode) ifTrue: [ ^ model contextMenu ].
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
