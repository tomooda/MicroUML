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
MicroUMLMethodNodeTest >> testIsAttribute [

	self deny: member isAttribute
]

{ #category : 'tests' }
MicroUMLMethodNodeTest >> testIsMethod [

	self assert: member isMethod
]
