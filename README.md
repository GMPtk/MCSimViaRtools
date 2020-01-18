# MCSimViaRtools
Build [GNU MCSim](https://www.gnu.org/software/mcsim/) models on Windows. Based on code provided by R. Woodrow Setzer.

Warning: written and tested on 64-bit Windows 7 and 10, and using Rtools v3.5 installed in its default location the system drive; this tool is not guaranteed to work with a different system configuration.

## Prerequisites

* [Rtools](https://cran.r-project.org/bin/windows/Rtools/)

## Installation

* Download this repo and unzip to ```Documents``` (```My Documents``` on older Windows systems).

* Rename the directory (remove the ```-master``` suffix).

## Test

Follow these steps to test the build environment using the [butadiene](http://cvs.savannah.gnu.org/viewvc/mcsim/mcsim/examples/butadiene/) example model provided:

* Start a command prompt and change directory to ```Documents\MCSimViaRtools```.

* Execute the build batch file:

  ``` 
  C:\Users\...\Documents\MCSimViaRtools>model2exe.bat
  ```

* Test the resulting executable:

  ```
  C:\Users\...\Documents\MCSimViaRtools>.\out\butadiene.exe .\target\butadiene.in .\out\butadiene.out
  ```

## Build A Model

Either use the target directory:

* Drop a ```.model``` file into the ```target``` directory.

* Run ```model2exe.bat```.

or specify your ```.model``` file as an argument to ```model2exe.bat```:

    model2exe.bat <path to .model file>

In the former case, the resulting executable will be created in the ```out``` folder. In the latter case, the resulting executable will be created in the same directory as the ```.model``` file.
