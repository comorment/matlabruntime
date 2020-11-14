Running your matlab project via Singularity Containers

To run your matlab code with this container there are 2 alternatives: 1) Build the standalone application of your code via Matlab Compiler and  run it with Matlab Runtime 2) Run it with GNU octave (https://www.gnu.org/software/octave/index)

## Getting Started

* Download ``octave-matlab.sif`` and ``magicsquare.tar.gz`` files placed in octave-matlab_v1.0 folder from [here](https://drive.google.com/drive/folders/1mfxZJ-7A-4lDlCkarUCxEf2hBIxQGO69?usp=sharing)
* Import both files to your secure HPC environment (i.e. TSD, Bianca, Computerome, or similar).
* Run ``tar -xzvf magicsquare.tar.gz`` to extract demo data.


##  With Matlab Runtime

This can be done in two step:

1. Get the standalone application of your code via Matlab Compiler (https://ch.mathworks.com/help/compiler/create-and-install-a-standalone-application-from-matlab-code.html) (which is ``magicsquare.tar.gz``  )

2. Run the standalone application via Matlab Runtime. For example
magigsquare.m is the default example which is given by Mathworks. We have  built and added it inside to container.  You can this application within container as;
 
  ```
 singularity exec --no-home octave-matlab.sif /magicsquare/for_redistribution_files_only/magicsquare 5
  ``` 
  
     
 ##  With GNU Octave
    
    It is also possible to run your code via GNU Octave. For this aim
    
 1. Run the container in shell mode
    
 ```
    sudo singularity shell --no-home octave-matlab.sif
```

2- Type octave and add the path where your code is. For instance, in our case the code (magicsquare.m)  is placed to  /magicsquare/for_redistribution_files_only . Hence all you need to do is adding this directory to octave as

 ```
 addpath('/magicsquare/for_redistribution_files_only')  
 
 ```

Then you can readily run your matlab command to call your function such as:   ``magicsquare 5``

And you can observe the same output as above.



## How to run on HPC

* Download ``octave-matlab.sif`` and ``magicsquare.tar.gz`` files placed in octave-matlab_v1.0 folder from [here](https://drive.google.com/drive/folders/1mfxZJ-7A-4lDlCkarUCxEf2hBIxQGO69?usp=sharing)
* Import both files to your secure HPC environment (i.e. TSD, Bianca, Computerome, or similar).
* Run ``tar -xzvf magicsquare.tar.gz`` to extract demo data.
* Run ``singularity exec --no-home octave-matlab.sif octave``, to validate that you can run singularity. This command is expected to produce the standard GNU OCTAVE help message, starting like this:
  
```
  GNU Octave, version 4.0.0
Copyright (C) 2015 John W. Eaton and others.
This is free software; see the source code for copying conditions.
There is ABSOLUTELY NO WARRANTY; not even for MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  For details, type 'warranty'.
   ```

* Run   ``singularity exec --no-home octave-matlab.sif /magicsquare/for_redistribution_files_only/magicsquare 5 `` to run the Matlab application already placed inside the container.

* Run ``singularity shell --no-home -B $(pwd):/data octave-matlab.sif `` to use singularity in an interactive mode. In this mode you can interactively run MATLAB commands via GNU OCTAVE (as explained above). Note that it will consume resources of the machine where  you currently run the singulairty  command (i.e., most likely, the login node of your HPC cluster).

* Run singularity container within SLURM job scheduler, by creating a ``octave-matlab_slurm.sh`` file (by adjusting the example below), and running ``sbatch octave-matlab_slurm.sh``:
  ```
  #!/bin/bash
  #SBATCH --job-name=octave-matlab
  #SBATCH --account=p697
  #SBATCH --time=00:10:00
  #SBATCH --cpus-per-task=1
  #SBATCH --mem-per-cpu=8000M
  module load singularity/2.6.1
  singularity exec --no-home octave-matlab.sif /magicsquare/for_redistribution_files_only/magicsquare 5 
  ```

Please [let us know](https://github.com/comorment/demo/issues/new) if you face any problems.





    
    

 
 
    

    
    


 
    

