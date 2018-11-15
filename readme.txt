===============================  HDR.m  ==================================
 Description:
   Script to generate a High Dynamic Range images

   Input arguments:
      -Pictures stack files for Radiometric calibration located in a  
       folder on thesame directory as the script. The files must have 
       the following naming convention: 
               G<ISO Gain>_<Exposure time denominator>
      -Pictures Stack that will be used to generate the HDR image.

 Output:
   Low Dynamic Range Image usint two composition methods 
 -------------------------------------------------------------------------
   Version   : 1.1
   Authors   : Aaron Hunter and Carlos Espinosa
   Created   : 11.14.18
 -------------------------------------------------------------------------
 Requirements:
		The script has been tested on Windows 10 running Matlab 2017b 
		and mac OS 10.13.6 runnig Matlab 2016b, so it should work properly 
		on any version higher than 2016b running on either Windows 10 or 
		mac OS 10.13.6
		
 Instructions:
		1.- Unzip the Project1_Hunter_Espinosa.zip file and open the HDR.m 
			script with Matlab. Be sure of changing the working directory.
			
		2.- Run the HDR.m script from the Matalab environment.
		
		3.- The script will generate all the deliverables images/plots 
			of the project.
  Warning:
		Please be sure that the folders with the pictures are in the same 
		folder as the script and under any circunstance change the name of 
		any of the folders or the pictures files. 