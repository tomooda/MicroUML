Class {
	#name : 'BaselineOfMicroUML',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfMicroUML',
	#package : 'BaselineOfMicroUML'
}

{ #category : 'baselines' }
BaselineOfMicroUML >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
			"Packages"
			spec
				package: 'MicroUML-AST';
				package: 'MicroUML-Builder';
				package: 'MicroUML-Tests'
				with: [ spec requires: #( 'MicroUML-AST' 'MicroUML-Builder' ) ] ]
]
