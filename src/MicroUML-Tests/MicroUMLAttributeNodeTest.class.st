Class {
	#name : 'MicroUMLAttributeNodeTest',
	#superclass : 'MicroUMLMemberNodeTest',
	#category : 'MicroUML-Tests',
	#package : 'MicroUML-Tests'
}

{ #category : 'running' }
MicroUMLAttributeNodeTest >> setUp [

	member := MicroUMLAttributeNode new
]

{ #category : 'tests' }
MicroUMLAttributeNodeTest >> testIsAttribute [

	self assert: member isAttribute
]

{ #category : 'tests' }
MicroUMLAttributeNodeTest >> testIsMethod [

	self deny: member isMethod
]
