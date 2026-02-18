Extension { #name : 'MicroUMLClassNode' }

{ #category : '*MicroUML-Editor' }
MicroUMLClassNode >> contextMenu [

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
								  action: [ self remove ] ].
				  (Smalltalk classNamed: self name) ifNotNil: [ :class |
						  group addItem: [ :item |
								  item
									  name: 'Browse...';
									  iconName: #browse;
									  action: [ class browse ] ] ] ];
		  addGroup: [ :group |
				  group
					  addItem: [ :item |
							  self isAbstract
								  ifTrue: [
										  item
											  name: 'Be concrete';
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
							  self isClass
								  ifTrue: [
										  item
											  name: 'Be trait';
											  action: [
													  self beTrait.
													  self announceDiagramChange ] ]
								  ifFalse: [
										  item
											  name: 'Be class';
											  action: [
													  self beClass.
													  self announceDiagramChange ] ] ] ];
		  addGroup: [ :group |
				  group addItem: [ :item |
						  item
							  name: 'Superclass...';
							  action: [ self changeSuperclass ] ] ];
		  addGroup: [ :group |
				  group
					  addItem: [ :item |
							  | traitMenu |
							  traitMenu := SpMenuPresenter new.
							  traitMenu addItem: [ :addTraitItem |
										  addTraitItem
											  name: 'Add trait...';
											  icon: self addIcon;
											  action: [ self addTrait ] ].
							  traits do: [ :traitName |
									  traitMenu addItem: [ :removeTraitItem |
											  removeTraitItem
												  name: 'Remove ' , traitName;
												  icon: self removeIcon;
												  action: [ self removeTrait: traitName ] ] ].
							  item
								  name: 'Traits';
								  subMenu: traitMenu ];
					  addItem: [ :item |
							  | attributeMenu |
							  attributeMenu := SpMenuPresenter new.
							  attributeMenu addItem: [ :addAttributeItem |
									  addAttributeItem
										  name: 'Add attribute...';
										  icon: self addIcon;
										  action: [ self addAttribute ] ].
							  self attributesDo: [ :attributeNode |
									  attributeMenu addItem: [ :attributeNodeMenu |
											  attributeNodeMenu
												  name: attributeNode name;
												  subMenu: attributeNode contextMenu ] ].
							  item
								  name: 'Attributes';
								  subMenu: attributeMenu ];
					  addItem: [ :item |
							  | methodMenu |
							  methodMenu := SpMenuPresenter new.
							  methodMenu addItem: [ :addMethodItem |
									  addMethodItem
										  name: 'Add method...';
										  icon: self addIcon;
										  action: [ self addMethod ] ].

							  self methodsDo: [ :methodNode |
									  methodMenu addItem: [ :attributeNodeMenu |
											  attributeNodeMenu
												  name: methodNode name;
												  subMenu: methodNode contextMenu ] ].
							  item
								  name: 'Methods';
								  subMenu: methodMenu ];
					  addItem: [ :item |
							  | associationMenu |
							  associationMenu := SpMenuPresenter new.
							  diagram ifNotNil: [
									  associationMenu addItem: [ :addAssociationItem |
											  | addAssociationMenu |
											  addAssociationMenu := SpMenuPresenter new.
											  diagram classesDo: [ :classNode |
													  classNode ~~ self ifTrue: [
															  addAssociationMenu addItem: [
																	  :addAssociationClassItem |
																	  addAssociationClassItem
																		  name: classNode name;
																		  action: [
																				  self addAssociation: classNode name.
																				  self announceDiagramChange ] ] ] ].
											  addAssociationItem
												  name: 'Add association with';
												  icon: self addIcon;
												  subMenu: addAssociationMenu ].
									  diagram associationsDo: [ :associationNode |
											  associationNode leftClass = name ifTrue: [
													  associationMenu addItem: [ :associationNodeMenu |
															  associationNodeMenu
																  name: 'with ' , associationNode rightClass;
																  subMenu: associationNode contextMenu ] ].
											  associationNode rightClass = name ifTrue: [
													  associationMenu addItem: [ :attributeNodeMenu |
															  attributeNodeMenu
																  name: 'with ' , associationNode leftClass;
																  subMenu: associationNode contextMenu ] ] ] ].
							  item
								  name: 'Associations';
								  subMenu: associationMenu ] ];
		  yourself
]
