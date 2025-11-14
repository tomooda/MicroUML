Class {
	#name : 'MicroUMLMethodNodeTest',
	#superclass : 'MicroUMLMemberNodeTest',
	#category : 'MicroUML-Tests',
	#package : 'MicroUML-Tests'
}

{ #category : 'running' }
MicroUMLMethodNodeTest >> setUp [

	member := MicroUMLMethodNode new
]

{ #category : 'tests' }
MicroUMLMethodNodeTest >> testArgumentTypes [

	member argumentTypes: #( Type1 Type2 ).
	self assert: member argumentTypes equals: { #Type1. #Type2 }
]

{ #category : 'tests' }
MicroUMLMethodNodeTest >> testIsAttribute [

	self deny: member isAttribute
]

{ #category : 'tests' }
MicroUMLMethodNodeTest >> testIsMethod [

	self assert: member isMethod
]
