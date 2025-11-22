Class {
	#name : 'MicroUMLClassDiagramChangedAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'diagram'
	],
	#category : 'MicroUML-AST',
	#package : 'MicroUML-AST'
}

{ #category : 'accessing' }
MicroUMLClassDiagramChangedAnnouncement >> diagram [

	^ diagram
]

{ #category : 'accessing' }
MicroUMLClassDiagramChangedAnnouncement >> diagram: aMicroUMLDiagramNode [

	diagram := aMicroUMLDiagramNode
]
