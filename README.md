# MCSimViaRtools
Build [GNU MCSim](https://www.gnu.org/software/mcsim/) models on Windows.

## Prerequisites

* [Rtools](https://cran.r-project.org/bin/windows/Rtools/) (version 3.5, 4.0, or 4.2; installed in default location) 

## Installation

1. Download this repo and unzip to ```Documents``` (```My Documents``` on older Windows systems).

2. Rename the directory (remove the ```-master``` suffix).

## Test

Follow these steps to test the build environment using the [butadiene](http://cvs.savannah.gnu.org/viewvc/mcsim/mcsim/examples/butadiene/) example model provided:

1. Start a command prompt and change directory to ```Documents\MCSimViaRtools```.

2. Execute the build batch file:

  ``` 
  C:\Users\...\Documents\MCSimViaRtools>model2exe.bat
  ```

3. Test the resulting executable:

  ```
  C:\Users\...\Documents\MCSimViaRtools>.\out\butadiene.exe .\target\butadiene.in .\out\butadiene.out
  ```

## Build A Model

Either use the target directory:

1. Drop a ```.model``` file into the ```target``` directory.

2. Run ```model2exe.bat```.

or specify your ```.model``` file as an argument to ```model2exe.bat```:

    model2exe.bat <path to .model file>

In the former case, the resulting executable will be created in the ```out``` folder. In the latter case, the resulting executable will be created in the same directory as the ```.model``` file.
