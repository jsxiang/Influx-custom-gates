# Influx-custom-gates
The scripts contained are used to draw the custom binning gates using .xml configuration files from the BD Influx cell sorter. This script is not compatible with the FACSAria sorters.

Download from sorter the configuration file as a .xml file. 
Run modifyVertices.m on the input configuration file, e.g. configuration.xml, to create a .xml file with the updated vertices, e.g. newgate.xml. 
Upload newgate.xml back into the BD software to check gates. 
To adjust scale, go into the script modifyVertices.m, and play around with the x and y coordinates in gatetostart.x and gatetostart.y before running the lines that call drawgates.m, which generates the new vertices based on the old vertices.  
