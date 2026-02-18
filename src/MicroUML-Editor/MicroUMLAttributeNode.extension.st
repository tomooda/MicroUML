Extension { #name : 'MicroUMLAttributeNode' }

{ #category : '*MicroUML-Editor' }
MicroUMLAttributeNode >> contextMenu [

	^ SpMenuPresenter new
		  title: self name;
		  addGroup: [ :group |
				  group
					  addItem: [ :item |
							  item
								  name: 'Rename...';
								  action: [ self rename ] ];
					  addItem: [ :item |
							  item
								  name: 'Remove';
								  icon: self removeIcon;
								  action: [ self remove ] ] ];
		  addGroup: [ :group |
				  self isPublic ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be public';
									  action: [
											  self bePublic.
											  self announceDiagramChange ] ] ].
				  self isProtected ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be protected';
									  action: [
											  self beProtected.
											  self announceDiagramChange ] ] ].
				  self isPrivate ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be private';
									  action: [
											  self bePrivate.
											  self announceDiagramChange ] ] ].
				  group
					  addItem: [ :item |
							  self isAbstract
								  ifTrue: [
										  item
											  name: 'Be implementation';
											  action: [
													  self beConcrete.
													  self announceDiagramChange ] ]
								  ifFalse: [
										  item
											  name: 'Be abstract';
											  action: [
													  self beAbstract.
													  self announceDiagramChange ] ] ];
					  addItem: [ :item |
							  self isClassSide
								  ifTrue: [
										  item
											  name: 'Be instance side';
											  action: [
													  self beInstanceSide.
													  self announceDiagramChange ] ]
								  ifFalse: [
										  item
											  name: 'Be class side';
											  action: [
													  self beClassSide.
													  self announceDiagramChange ] ] ] ];
		  addGroup: [ :group |
				  group addItem: [ :item |
						  item
							  name: 'Change type...';
							  action: [ self changeType ] ] ];
		  yourself
]
