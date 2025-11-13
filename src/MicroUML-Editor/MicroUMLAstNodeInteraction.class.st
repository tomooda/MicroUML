Class {
	#name : 'MicroUMLAstNodeInteraction',
	#superclass : 'RSInteraction',
	#category : 'MicroUML-Editor',
	#package : 'MicroUML-Editor'
}

{ #category : 'api' }
MicroUMLAstNodeInteraction >> contextMenuFor: aRSShape [

	aRSShape model ifNotNil: [ :model |
		(model isKindOf: MicroUMLClassNode) ifTrue: [ ^ model contextMenu ] ].
	^ nil
]

{ #category : 'hooks' }
MicroUMLAstNodeInteraction >> onShape: aShape [
	"opens my context menu with a right click."

	aShape
		when: RSMouseRightClick
		do: [ :evt |
				(self contextMenuFor: evt shape) ifNotNil: [ :menu |
					menu openWithSpecAtPointer ] ]
		for: self
]
