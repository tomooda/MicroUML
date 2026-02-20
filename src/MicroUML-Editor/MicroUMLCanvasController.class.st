Class {
	#name : 'MicroUMLCanvasController',
	#superclass : 'RSCanvasController',
	#category : 'MicroUML-Editor',
	#package : 'MicroUML-Editor'
}

{ #category : 'initialization' }
MicroUMLCanvasController >> defaultInteractions [
	"create a subclass of RSCanvasController and define your own custom interactions for your canvas"

	^ {
		  RSDraggableCanvasInteraction.
		  RSKeyNavigationCanvasInteraction.
		  RSScrollBarsCanvasInteraction.
		  RSSearchInCanvasInteraction.
		  RSZoomToFitCanvasInteraction }
]
