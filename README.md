# PlasmaChem_GlobalModelling
MATLAB code for simplifying development of global (volume-averaged) plasma chemistry models
 
Requires MATLAB R2015B or later.
 
##To use source code
1. Copy 'GlobalModel.m' and the folders 'Classes', 'Core' and 'External methods for GUI_control' into a single directory.
2. Modify 'GlobalModel.m' by replacing the %%comment%% with the path to the directory where you saved the code.
3. Open a MATLAB terminal
4. Use 'pathtool' to add the directory to your MATLAB path. Ensure that the current directory is the same as the directory of the MATLAB code. Make a folder titled 'Results' in the current directory.
5. Initiate GUI with the command 'Controller = GlobalModel'. This calls the constructor function for the GUI_Control class, and saves the resulting object to the MATLAB workspace as 'Controller'. Methods of the Controller object (some of which are saved as external files) act as a pipe between the GUI and the MATLAB worker.
6. Use the GUI to build, evaluate and export the results of your system of chemical kinetic balance equations.
 
###Supplying reaction codes
Reaction codes may be supplied individually (A1, A2, A3, ...) or as a range (A[1-3],...)
 
Once reactions are defined, their characteristics will be saved to a DATABASE_C object ReactionDB_MAIN.
 
Reaction characteristics may be retrieved from ReactionDB_MAIN via the above calling methods, or via a '\*' token. As such A\* will call all reactions A1, A2, A3, ... that are already saved in the database
 
Species involved in each reaction should be supplied as a comma-separated list. Multiples may be entered either as 2\*X or X,X
 
### Interpreter - for Reaction>Rate Coefficient and Reaction>Energy
For implicit reference use \<ControllerProperty.Property\> or \<ControllerProperty:DB_Key.Property\>
 
Controller properties should be abbreviated according to the following
 
G->Global, R->Reactor, E->Experiment,RR->ReactionDB, S->SpeciesDB, C->CrosssectionDB
 
As such \<S:H+.u_Bohm\> will be interpreted as Controller.SpeciesDB.Key('H+').u_Bohm (i.e. the Bohm velocity for the H+/free proton species).
 
N.b. Te (electron temperature) and Tg (gas temperature) dependancies do not require implicit references
 
 
commit:b93945
Update README.md