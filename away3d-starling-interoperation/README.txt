Read the following before using the files within this archive.

1. This archive contains files that belong to the "Away3D and Starling Interoperation" tutorial posted on the Adobe Flash Developer Center web site.
   http://www.adobe.com/devnet/...
   
* Use these files to build the Away3D and Starling Interoperation example application for Flash Player 11
   
2. Instructions on building the example application.

This package contains the following files:

.project
.actionScriptProperties
src/
	starling/
		rootsprites/
			StarlingStarsSprite.as
			StarlingCheckerboardSprite.as
	Away3D_Starling_Interoperation.as
README.txt
bin-debug
.settings/
	org.eclipse.core.resources.prefs
html-template/
	index.template.html
	history/
		history.css
		history.js
		historyFrame.html
	playerProductInstall.swf
	swfobject.js

embeds/
	stars.pex
	stars.png
	button.png


1. Install Flash Builder 4.6
2. Ensure you have at least Flash Player 11 installed
3. Unzip the archive to a location of your choice.
4. Download the additional sources required:
	- Away3D 4 sources or SWC
	- Starling Framework (latest) from Github
	- Starling Extesion Particle System (latest) from Github
5. Within Flash Builder, select File->Import Flash Builder Project...
6. Select the Project Folder and Browse to location where the files were unarchived to. 
   - Alternatively you could select File and browse to the archive itself.
7. Once the project has been imported, it is necessary to add the source references for your downloaded libraries.
   Open the Properties of the Away3D_Starling_Interoperation project.
   Select 'ActionScript Build Path' in the left column.
   Select the 'Source Path' tab in the right panel.
   Click on the 'Add folder' button to add each of the following source paths:
       <Away3D download location>/src
       <Starling Framework download location>/starling/src
       <Starling Extension Particle System download location>/src
8. Click the Run or Debug button to view the example application.
          
If you are configuring a new project using the above files, as the example uses Stage3D, 
ensure that you are using Flash Player 11 or greater and you have specified the correct 
swf-version. Also, if you are running the example through a browser, you will need to set 
the correct wmode within the html page. e.g -swf-version=13 & wmode="direct"

