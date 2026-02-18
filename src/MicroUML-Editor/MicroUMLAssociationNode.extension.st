Extension { #name : 'MicroUMLAssociationNode' }

{ #category : '*MicroUML-Editor' }
MicroUMLAssociationNode >> contextMenu [

	^ SpMenuPresenter new
		  title: leftClass , ' - ' , rightClass;
		  addGroup: [ :group |
				  group addItem: [ :item |
							  item
								  name: 'Remove';
								  icon: self removeIcon;
								  action: [ self remove ] ] ];
		  addGroup: [ :group |
				  self isAggregation ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be aggregation';
									  action: [
											  self
												  beAggregation;
												  announceDiagramChange ] ] ].
				  self isComposition ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be composition';
									  action: [
											  self
												  beComposition;
												  announceDiagramChange ] ] ].
				  self isNoAggregation ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be non-aggregation';
									  action: [
											  self
												  beNoAggregation;
												  announceDiagramChange ] ] ].
				  self isDependency ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be dependency';
									  action: [
											  self
												  beDependency;
												  announceDiagramChange ] ] ].
				  self isDirected
					  ifTrue: [
							  group addItem: [ :item |
									  item
										  name: 'Be not directed';
										  action: [
												  self
													  beNotDirected;
													  announceDiagramChange ] ] ]
					  ifFalse: [
							  group addItem: [ :item |
									  item
										  name: 'Be directed';
										  action: [
												  self
													  beDirected;
													  announceDiagramChange ] ] ].
				  self isSolid ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be solid line';
									  action: [
											  self
												  beSolid;
												  announceDiagramChange ] ] ].
				  self isDashed ifFalse: [
						  group addItem: [ :item |
								  item
									  name: 'Be dashed line';
									  action: [
											  self
												  beDashed;
												  announceDiagramChange ] ] ] ];
		  addGroup: [ :group |
				  group
					  addItem: [ :item |
							  item
								  name: leftClass;
								  subMenu: self contextMenuOnLeft ];
					  addItem: [ :item |
							  item
								  name: rightClass;
								  subMenu: self contextMenuOnRight ];
					  addItem: [ :item |
							  item
								  name: 'Change label...';
								  action: [ self changeLabel ] ] ];
		  yourself
]
