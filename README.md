# Running your matlab project via Singularity Containers

It is possible to run your matlab code in a container which does not have MATLAB. To do this, we first need to  build the standalone application of corresponding Matlab Code via Matlab Compiler locally and then run with this application with the container  which has Matlab Runtime 

## Getting Started

* Download ``matlabruntime.sif``, `` magicsquare.m ``   and `` magicsquare.zip ``  files placed in matlabruntime folder from [here](https://drive.google.com/drive/folders/1mfxZJ-7A-4lDlCkarUCxEf2hBIxQGO69?usp=sharing)
* Import these files  to your secure HPC environment (i.e. TSD, Bianca, Computerome, or similar).
* Extract the application file via ``unzip magifsquare.zip `` 



* The main aim is running magicsquare.m file within container. 


##  Running Matlab Runtime in Local

This can be done in two step:

1. Get the standalone application of your code via Matlab Compiler. A detailed instruction can be found here: (https://ch.mathworks.com/help/compiler/create-and-install-a-standalone-application-from-matlab-code.html). 

An example application called magicsquare provided via `` magifsquare.zip ``  Hence you can unzip and use this previously compiled application. If you do this, you can reach the corresponding application at /magicsquare/for_redistribution_files_only/magicsquare


Alternatively, you can build your own application via terminal as

  ```
 mcc -m magicsquare.m

 ```



2. Run the standalone application via Matlab Runtime.  You can this application by mounting the path of the application (in this example magicsqure application) to the container as;
 

  
  ```
  singularity exec --no-home  --bind  path/of/application:/execute         matlabruntime.sif         /execute/magicsquare 5

 ```
     





## How to run on HPC

* Download ``matlabruntime.sif ``  and `` magicsquare.zip ``  files placed in matlabruntime  folder from [here](https://drive.google.com/drive/folders/1mfxZJ-7A-4lDlCkarUCxEf2hBIxQGO69?usp=sharing)
* Import these files  to your secure HPC environment (i.e. TSD, Bianca, Computerome, or similar).
* Extract the application file via ``unzip magicsquare.zip `` 


* Run singularity container within SLURM job scheduler, by creating a ``matlab_slurm.sh`` file (by adjusting the example below), and running ``sbatch matlab_slurm.sh``:
  ```
  #!/bin/bash
  #SBATCH --job-name=matlab
  #SBATCH --account=p697
  #SBATCH --time=00:10:00
  #SBATCH --cpus-per-task=1
  #SBATCH --mem-per-cpu=8000M
  module load singularity/2.6.1
  singularity exec --cleanenv --no-home  --bind  magicsquare/for_redistribution_files_only:/execute         matlabruntime.sif         /execute/magicsquare 5
  ```

Please [let us know](https://github.com/comorment/demo/issues/new) if you face any problems.





    
    

 
 
    

    
    


 
    

