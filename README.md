# Notes on stimulator code for visual stimulus generation

# Setup components
## Master:
- Windows or Ubuntu machine
- Matlab
- no specific requirements for graphics card or monitor
- can be running acquisition as well (depending on demands of acquisition)

## Slave:
- Ubuntu
- Matlab
- Psychtoolbox-compatible graphics card (most recently, we’ve used NVidia Geforce GTX 1050)  
  *Notes on configuration for NVidia graphics card for Psychtoolbox:*  
    - *make sure graphics card is set to optimal power setting (using power mizer interface for NVidia driver)*  
    - *disable dithering*
- 2 screens suitable for visual stimulus display, set up in mirroring mode (i.e. not extended desktop)
- Psychtoolbox  
  *need to ensure that Psychtoolbox can run without dropping frames by running Psychtoolbox test scripts (in particular, VBLSyncTest)*
- if stimulus triggers are required: USB-1208FS from Measurement Computing  
  *note that USB-1208FS-Plus is not compatible with Psychtoolbox*


# Initial setup
## General

- ensure that master and slave can communicate via TCP (use ping to test); may have to adjust firewall settings
- copy correct part of stimulator code onto each machine, execute steps described below
- measure LUT for gamma calibration for monitor (if required)
- set up trigger channels (if required):  
  - Channel 0: usually used to indicate trial start/stop; USB-1208FS port A0, channel 21
  - Channel 1: usually used to indicate stimulus start/stop; USB-1208FS port A1, channel 22 
  - check playstimulus code to check for particular module



## Master

- generate the following directories:  
  - analyzer root directory  
  - directory for history files  
  - params & looper file - on windows expected to be c:\params looper
- add and sync analyzer repository:
  - contains the config files for each module
  - a viewer for analyzer and config files
  - a set of general utility functions to be used with analyzer files  
- generate setupDefault file:
  - copy setupDefaultEx.txt to c:\params looper (windows) or \usr\local (ubuntu)  
  - rename to setupDefault.txt  
  - edit directory names to match new directories (analyzerRoot, MstateHistoryFile & ExperimentMasterFile)  
  - edit IP number to match IP number of slave  
  - edit setupID if required  
  - note: there can be multiple setupID entries if required (setupIDs matter for setting acquisition specific parameters/GUIs); there also can be multiple analyzerRoot entries if the analyzer file is to be saved in multiple locations; in both cases, each entry should be a separate line (as shown for the monitor entries)
  - update monitor list: defaultMonitor is the first monitor shown; alternativeMonitors cover the case of using the same system with different monitors (these are the monitors placed in front of the subject, not the control monitor)  
  - set useMCDaq: 1- use USB-1208FS to generate trigger events; 0- do not generate trigger events
  - if necessary, add variable acqDataRoot - this will preset the acquisition root field in the Main Window (only used if acquisition happens on the master)
- edit monitorList file:  
  - contains information (including location of gamma calibration file) for each monitor  
  - one entry per monitor  
  - the long name is used on the master, the 3 letter name on the slave  
  - calibration files containing LUT need to be saved on the slave; edit file names here  
  - linear LUT is set as the default and does not produce gamma calibration  


## Slave
- generate a directory for the log files
- add and sync analyzer repository
- generate setupDefault file:  
  - copy setupDefaultEx.txt to /usr/local/
  - rename to setupDefault.txt
  - edit logRoot to match new directory
  - edit all other parameters to match settings on master
- in more complicated setups, make sure that screenNum is set correctly in screenconfig


# Basic use


# Add a new module 


## General module
The following applies to modules that should be listed in the params window

- on Slave:  
  - write new makeTexture file  
    - this contains all stimulus generation code that can be performed in the intertrial period  
    - should be saved in maxeTextures folder
  - write new playTexgture file
    - this contains all of the stimulus presentation & timing code, as well as any stimulus generation that cannot be handled in the intertrial period  
    - should be saved in playTextures folder
  - write configPstate file  
    - should contain all parameters that can be changed by the user
    - saved in modules in the analyzer repository
    - function should include global Pstate
    - structure of config file:  
      - one cell per parameter gets added to Pstate
      - for every parameter, cell contains 5 entries:  
        - parameter name (string)  
        - parameter type (string; can be float, int, string)  
        - default value (number or string)  
        - legacy field (unused; can be set to 0)  
        - unit (string, used for display in params window only)  
    - to call parameters defined in the config file in the makeTexture/playTexture files for the module, include 'P=getParamStruct'. Parameters can then be refered to as P.*parameterName*, with *parameterName* corresponding to the first string in a parameter's cell in the configFile
  - add module to moduleListSlave:  
    - one cell per module in Mlist  
    - for every module, there are 4 entries:  
      - module code: 2 letters (used for communication between master & slave)  
      - name of config file  
      - name of makeTexture file  
      - name of playTexture file  
- on Master:  
  - update analyzer repository
  - add module to moduleListMaster:  
    - one cell per module in Plist  
    - for every module, there are 4 entries  
      - module code: 2 letters (used for communication between master & slave)  
      - name of module (to be displayed in dropdown list in params window)  
      - name of config file
      - 4th field allows to add a module-specific initialization file
- *Note: delete history files if parameters for an existing/previously used module have changed*

## Module for manual mapper

# Module parameters

The first section lists parameters found in most modules; the following section then list additional module-specific parameters. Note that the screen distance needs to be set correctly in the main window for any of the visual deg values to be correct.

## General parameters
Parameter | Description
--- | ---
predelay |
postdelay |
stim_time |
x_pos |
y_pos |
x_size |
y_size | 
background | 
contrast | 
mask_type | 
mask_radius |
redgun | 
greengun | 
bluegun | 

## Bar
Parameter | Description 
--- | ---
max_posdelta
offset
ori
speed


## Checkerboard
Parameter | Description 
--- | ---
block_size
t_period
max_posdelta
offset
speed
ori

## Image
Parameter | Description 
--- | ---
usenativesize
keepaspectratio
croptoscale
imgpath
imgbase
imgnr
filetype
color
scramble
nrblocks

## Kalatsky
Parameter | Description 
--- | ---
width
axis
dir
speed

## Optic flow
Parameter | Description 
--- | ---
stimRadius
stimType
stimDir
dotDensity
sizeDots
speedDots
dotLifetime
dotCoherence
dotType

## Periodic grating
Parameter | Description 
--- | ---
ori
phase
s_freq
s_profile
s_duty
t_period
plaid_bit
surround_bit
x_size2
y_size2
mask_type2
mask_radius2
contrast2
ori2
phase2
s_freq2
s_profile2
s_duty2
t_period2
tmod_bit
tmod_max
tmod_min
tmod_tperiod
tmod_tprofile

## Periodic grating (color)
Parameter | Description 
--- | ---
ori
phase
s_freq
s_profile
s_duty
t_period
c1_red
c1_green
c1_blue
c2_red
c2_green
c2_blue

## RC Grating (flashed sequence of gratings)
Parameter | Description 
--- | ---
min_ori
orirange
n_ori
min_sf
max_sf
n_sfreq
sf_domain
n_phase
h_per
blankProb
s_profile
s_duty
drift
t_period
rseed

## RDK
Parameter | Units | Description 
--- | ---
sizeDot
dotType
ori
dotDensity
speedDots
dotLifetime
dotCoherence
noNetNoise
motionopp_bit
surround_bit
x_size2
y_size2
mask_radius2
mask_type2
ori2
dotDensity2 | dots/(deg^2 s)
speedDots2 | deg/s
dotLifetime2 | frames
dotCoherence2 | %

## Warped checkerboard
Parameter | Units | Description 
width | deg
altazimuth
tilt_alt | deg
tilt_az | deg
dx_perpbis | cm
dy_perpbis | cm 
rotated
ori | deg
speed | deg/s
phase | deg
noise_lifetime | frames
noise_width | deg
x_zoom 
y_zoom 

## Warped grating
Parameter | Units | Description 
altazimuth
tilt_alt | deg
tilt_az | deg
dx_perpbis | cm
dy_perpbis | cm 
ori | deg
s_freq | cyc/deg
s_profile
s_duty
t_period | frames
phase | deg