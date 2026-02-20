Class {
	#name : 'MicroUMLEditor',
	#superclass : 'SpPresenter',
	#instVars : [
		'packageList',
		'packageFilter',
		'code',
		'preview',
		'toolbar',
		'liveDrawingButton',
		'builder',
		'packageName',
		'showsPackageList',
		'showsCode',
		'showsPreview'
	],
	#category : 'MicroUML-Editor',
	#package : 'MicroUML-Editor'
}

{ #category : 'examples' }
MicroUMLEditor class >> example [
	<example>
	self new open
]

{ #category : 'examples' }
MicroUMLEditor class >> exampleArrayHierarchy [

	<example>
	| uml |
	uml := MicroUMLClassDiagramGenerator new
		       generateClass: ArrayedCollection;
		       generateClass: Array;
		       generateClass: Float64Array;
		       generateClass: IntegerArray;
		       generateClass: PointArray;
		       diagram.
	(self withDiagram: uml) open
]

{ #category : 'examples' }
MicroUMLEditor class >> examplePackage [

	<example>
	self new
		packageFilter: 'MicroUML';
		packageName: 'MicroUML-AST';
		disableCode;
		open
]

{ #category : 'examples' }
MicroUMLEditor class >> exampleWithDiagram [
	<example>
	| uml |
	uml := MicroUMLAstBuilder exampleSerie2.
	(self withDiagram: uml diagram) open
]

{ #category : 'instance creation' }
MicroUMLEditor class >> withDiagram: aDiagram [

	^ self new
		showDiagram: aDiagram;
		yourself
]

{ #category : 'menu operations' }
MicroUMLEditor >> addPackage [

	(self
		 request: 'Name of the new package:'
		 initialAnswer: (packageName ifNil: [ '' ])
		 title: 'Create a new package') ifNotNil: [ :string |
			string trim ifNotEmpty: [ :newPackageName |
					self packageOrganizer packageNamed: newPackageName ifAbsent: [
							self packageOrganizer addPackage: newPackageName.
							self updatePackageList ].
					self packageName: newPackageName ] ]
]

{ #category : 'accessing' }
MicroUMLEditor >> colorFor: aMicroUMLAstNode [

	self packageDo: [ :package |
			aMicroUMLAstNode isMicroUMLClassNode ifTrue: [
					aMicroUMLAstNode pharoClass ifNotNil: [ :class |
						class package name ~= package name ifTrue: [
							^ self outOfPackageColor ] ].
					^ self defaultColor ].
			aMicroUMLAstNode isMicroUMLMemberNode ifTrue: [
					aMicroUMLAstNode isAttribute
						ifTrue: [ ^ self colorFor: aMicroUMLAstNode classNode ]
						ifFalse: [
								aMicroUMLAstNode pharoMethod ifNotNil: [ :method |
										method package name ~= package name ifTrue: [
											^ self outOfPackageColor ] ].
								^ self defaultColor ] ] ].
	^ self defaultColor
]

{ #category : 'compiling' }
MicroUMLEditor >> compileUml [

	^ Smalltalk compiler evaluate: code text
]

{ #category : 'ui requests' }
MicroUMLEditor >> confirm: queryString label: titleString [

	^ self application newConfirm
		  title: titleString;
		  label: queryString;
		  openModal
]

{ #category : 'initialization' }
MicroUMLEditor >> connectPresenters [

	code whenSubmitDo: [ :text | self drawDiagram ].

	code whenTextChangedDo: [ :text |
			liveDrawingButton isSelected ifTrue: [
				[ self drawDiagram ] onErrorDo: [ "do nothing" ] ] ].
	packageList whenSelectionChangedDo: [ :selection |
		self packageListSelectionChanged ].
	packageFilter whenSubmitDo: [ :txt | self packageFilterChanged ]
]

{ #category : 'accessing' }
MicroUMLEditor >> defaultColor [

	^ Color black
]

{ #category : 'layout' }
MicroUMLEditor >> defaultLayout [

	| pane |
	pane := showsCode
		        ifTrue: [
				        showsPreview
					        ifTrue: [
							        SpPanedLayout newHorizontal
								        add: code;
								        add: preview ]
					        ifFalse: [ code ] ]
		        ifFalse: [
				        showsPreview
					        ifTrue: [ preview ]
					        ifFalse: [ nil ] ].
	showsPackageList ifTrue: [
			| packagePane |
			packagePane := SpBoxLayout newVertical
				               add: packageList;
				               add: packageFilter expand: false;
				               yourself.
			pane := pane
				        ifNotNil: [
						        SpPanedLayout newHorizontal
							        positionOfSlider: 0.25;
							        add: packagePane;
							        add: pane;
							        yourself ]
				        ifNil: [ packagePane ] ].
	^ pane
		  ifNotNil: [
				  SpBoxLayout newTopToBottom
					  spacing: 4;
					  add: toolbar expand: false;
					  add: pane;
					  yourself ]
		  ifNil: [ toolbar ]
]

{ #category : 'accessing' }
MicroUMLEditor >> defaultPackageName [

	^ '__MicroUML-Generated__'
]

{ #category : 'updating' }
MicroUMLEditor >> diagramChanged: aMicroUMLClassDiagramChangedAnnouncement [

	self showDiagram: aMicroUMLClassDiagramChangedAnnouncement diagram
]

{ #category : 'enabling/disabling' }
MicroUMLEditor >> disableCode [

	showsCode := false
]

{ #category : 'enabling/disabling' }
MicroUMLEditor >> disableLiveDrawing [

	code whenTextChangedDo: [ :text | "do nothing" ]
]

{ #category : 'enabling/disabling' }
MicroUMLEditor >> disablePackageList [

	showsPackageList := false
]

{ #category : 'enabling/disabling' }
MicroUMLEditor >> disablePreview [

	showsPreview := false
]

{ #category : 'drawing' }
MicroUMLEditor >> drawDiagram [

	| diagram astNodeInteraction |
	diagram := (code text trimmed
		            ifEmpty: [ MicroUMLAstBuilder new ]
		            ifNotEmpty: [ self compileUml ]) diagram.
	diagram announcer
		when: MicroUMLClassDiagramChangedAnnouncement
		send: #diagramChanged:
		to: self.
	builder classDiagramNode: diagram.
	builder canvas shapes copy do: [ :shape | shape remove ].
	builder build.
	astNodeInteraction := MicroUMLAstNodeInteraction new.
	builder canvas allChildren do: [ :shape |
		shape model isMicroUMLAstNode ifTrue: [ shape @ astNodeInteraction ] ].
	builder canvas @ MicroUMLCanvasController.
	builder canvas @ (MicroUMLClassDiagramNodeInteraction new
		 diagram: diagram;
		 yourself).
	builder container signalUpdate
]

{ #category : 'enabling/disabling' }
MicroUMLEditor >> enableCode [

	showsCode := true
]

{ #category : 'enabling/disabling' }
MicroUMLEditor >> enableLiveDrawing [

	code whenTextChangedDo: [ :text |
		[ self drawDiagram ] onErrorDo: [ "do nothing" ] ]
]

{ #category : 'enabling/disabling' }
MicroUMLEditor >> enablePackageList [

	showsPackageList := true
]

{ #category : 'enabling/disabling' }
MicroUMLEditor >> enablePreview [

	showsPreview := true
]

{ #category : 'examples' }
MicroUMLEditor >> example [
	<script: 'self example'>
]

{ #category : 'generating' }
MicroUMLEditor >> generateClasses [

	| generator |
	generator := MicroUMLCodeGenerator forDiagram:
		             self compileUml diagram.
	generator generateClassesInPackageNamed: self packageName
]

{ #category : 'generating' }
MicroUMLEditor >> generateFromPharoPackage [

	self packageDo: [ :package |
			(MicroUMLClassDiagramGenerator classDiagramFromPackage: package)
				ifNotNil: [ :uml | self showDiagram: uml ] ]
]

{ #category : 'initialization' }
MicroUMLEditor >> initialize [

	super initialize.
	packageName := self defaultPackageName.
	showsPackageList := true.
	showsCode := true.
	showsPreview := true
]

{ #category : 'initialization' }
MicroUMLEditor >> initializePresenters [

	packageList := self newList
		               contextMenu: [ self packageListContextMenu ];
		               yourself.
	packageFilter := self newTextInput
		                 placeholder: 'Filter...';
		                 yourself.
	self updatePackageList.
	code := self newCode.
	builder := MicroUMLRoassalBuilder new
		           colorBlock: [ :node | self colorFor: node ];
		           yourself.
	self drawDiagram.
	preview := builder asPresenter.
	toolbar := self newToolbar.
	self initializeToolbar
]

{ #category : 'initialization' }
MicroUMLEditor >> initializeToolbar [

	| drawButton |
	drawButton := self newToolbarButton
		              label: 'Draw';
		              icon: (self iconNamed: #go);
		              action: [ self drawDiagram ];
		              yourself.

	liveDrawingButton := self newToolbarToggleButton
		                     label: 'Live';
		                     icon: (self iconNamed: #autoReload);
		                     whenActivatedDo: [
				                     self drawDiagram.
				                     drawButton disable ];
		                     whenDeactivatedDo: [ drawButton enable ];
		                     yourself.

	toolbar add: drawButton.
	toolbar add: liveDrawingButton.

	toolbar add: (self newToolbarButton
			 label: 'Generate';
			 icon: (self iconNamed: #smallNew);
			 action: [ self generateClasses ];
			 yourself).

	toolbar add: (self newToolbarButton
			 label: 'Save PNG';
			 icon: (self iconNamed: #smallScreenshot);
			 action: [ self saveAsPng ];
			 yourself).

	toolbar add: (self newToolbarButton
			 label: 'Inspect';
			 icon: (self iconNamed: #inspect);
			 action: [ self compileUml inspect ])
]

{ #category : 'initialization' }
MicroUMLEditor >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.

	aWindowPresenter initialExtent: 1300 @ 800
]

{ #category : 'accessing' }
MicroUMLEditor >> outOfPackageColor [

	^ Color lightGray
]

{ #category : 'accessing' }
MicroUMLEditor >> packageDo: aBlock [

	^ self packageOrganizer
		  packageNamed: self packageName
		  ifPresent: aBlock
]

{ #category : 'accessing' }
MicroUMLEditor >> packageFilter: aString [

	packageFilter text: aString.
	self packageFilterChanged
]

{ #category : 'updating' }
MicroUMLEditor >> packageFilterChanged [

	self updatePackageList
]

{ #category : 'menus' }
MicroUMLEditor >> packageListContextMenu [

	^ self newMenu
		  addGroup: [ :group |
				  group addItem: [ :item |
							  item
								  name: 'New package';
								  iconName: #add;
								  action: [ self addPackage ] ].
				  packageList selectedItem ifNotNil: [
						  group addItem: [ :item |
								  item
									  name: 'Remove';
									  iconName: #remove;
									  action: [ self removePackage ] ] ] ];
		  yourself
]

{ #category : 'updating' }
MicroUMLEditor >> packageListSelectionChanged [

	packageList selectedItem ifNotNil: [ :selectedPackageName |
		self packageName: selectedPackageName ]
]

{ #category : 'accessing' }
MicroUMLEditor >> packageName [

	^ packageName
]

{ #category : 'accessing' }
MicroUMLEditor >> packageName: aString [

	| newPackageName |
	newPackageName := aString asString trim.
	newPackageName = packageName ifFalse: [
			packageName := aString asString trim.
			self packageNameChanged ]
]

{ #category : 'updating' }
MicroUMLEditor >> packageNameChanged [

	self updateWindowTitle.
	self updatePackageListSelection.
	self generateFromPharoPackage
]

{ #category : 'testing' }
MicroUMLEditor >> pharoPackageIncludesClassNamed: aString [

	self packageDo: [ :package |
		^ package classes contains: [ :class |
			  class name asString = aString ] ].
	^ false
]

{ #category : 'menu operations' }
MicroUMLEditor >> removePackage [

	self packageDo: [ :package |
			(self
				 confirm: 'Are you sure you want to delete the ' , package name
					 , ' package with its contents?'
				 label: 'Remove package: ' , package name) ifTrue: [
					package removeFromSystem.
					self updatePackageList.
					^ self ] ].
	^ nil
]

{ #category : 'file IO' }
MicroUMLEditor >> saveAsPng [

	(StSaveFilePresenter extensions: {'png'})
		okAction: [ :fileReference | 
			RSPNGExporter new
				canvas: preview canvas;
				exportToFile: fileReference ]

	
]

{ #category : 'drawing' }
MicroUMLEditor >> showDiagram: aDiagram [

	code text: aDiagram microUML.
	self drawDiagram
]

{ #category : 'updating' }
MicroUMLEditor >> updatePackageList [

	packageList items: (((packageFilter text asString substrings: '|')
			  collect: #trim
			  thenSelect: #notEmpty)
			 ifNotEmpty: [ :keywords |
					 self packageOrganizer packageNames select: [ :name |
						 keywords anySatisfy: [ :keyword |
							 (name findString: keyword) > 0 ] ] ]
			 ifEmpty: [ self packageOrganizer packageNames ]) sorted.
	self updatePackageListSelection
]

{ #category : 'updating' }
MicroUMLEditor >> updatePackageListSelection [

	packageList selectItem: packageName
]

{ #category : 'updating' }
MicroUMLEditor >> updateWindowTitle [

	self window ifNotNil: [ :window |
		window title: 'MicroUML : ' , packageName ]
]

{ #category : 'updating' }
MicroUMLEditor >> windowTitle [

	^ packageName
		  ifNotNil: [ :name | 'MicroUML : ' , name ]
		  ifNil: [ 'MicroUML' ]
]
