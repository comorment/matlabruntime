# Running your matlab project via Singularity Containers

It is possible to run your matlab code in a container with MATLAB Runtime. To do this, we first need to  build the standalone application of corresponding Matlab Code via Matlab Compiler locally and then run this application with the container  which has Matlab Runtime (https://ch.mathworks.com/products/compiler/matlab-runtime.html).

## Getting Started

* All examples presented here are done via Matlab Compiler 2021a and Matlab Runtime 2021a. Note that our container (matlabruntime2021a.sif) presented here includes Matlab Runtime 2018b, and it may not support the applications created by  Matlab Compiler versions other than Matlab Compiler 2021a. Hence if you want to use this container without any issue, make sure that you have Matlab Compiler 2021a.

* Some Matlab functions/toolboxes are not supported or partially supported by Matlab Compiler. You may want to check  [here](https://ch.mathworks.com/products/compiler/compiler_support.html ) first

* Download ``matlabruntime2021a.sif``, `` magicsquare.m ``   and `` magicsquare.zip ``  files placed in matlabruntime folder from [here](https://drive.google.com/drive/folders/1mfxZJ-7A-4lDlCkarUCxEf2hBIxQGO69?usp=sharing)
* Import these files  to your secure HPC environment (i.e. TSD, Bianca, Computerome, or similar).
* Extract the application file via ``unzip magifsquare.zip `` 



* The main aim is running your Matlab code/project within container. 


##  Running Matlab Runtime on Local machine

This can be done in two step:

1. Get the standalone application of your code via Matlab Compiler. A detailed instruction can be found here: (https://ch.mathworks.com/help/compiler/create-and-install-a-standalone-application-from-matlab-code.html). 

An example application called magicsquare provided via `` magifsquare.zip ``  Hence you can unzip and use this previously compiled application. If you do this, you can reach the corresponding application at /magicsquare/for_redistribution_files_only/magicsquare


Alternatively, you can build your own application from the actual mfile via terminal as

  ```
 mcc -m magicsquare.m

 ```



2. Then we can run the standalone application via Matlab Runtime.  You can this application by mounting the path of the application (in this example magicsqure application) to the container as;
 

  
  ```
  singularity exec --no-home  --bind  path/of/application:/execute         matlabruntime2021a.sif         /execute/magicsquare 5

 ```
     
     
 
 
 
 
##  A comprehensive Example: How to run pleioFDR via Singularity container

Pleiotropy-informed conditional and conjunctional false discovery rate (pleioFDR) allows to boost loci discovery in low-powered GWAS by levereging pleiotropic enrichment with a larger GWAS on related phenotype, and to identify genetic loci joinly associated with two phenotypes.  The software is available here: https://github.com/precimed/pleiofdr

If you use pleioFDR software for your research publication, please cite the following paper(s):

-Andreassen, O.A. et al. Improved detection of common variants associated with schizophrenia and bipolar disorder using pleiotropy-informed conditional false discovery rate. PLoS Genet 9, e1003455 (2013).

The pleioFDR software may not be used for commercial purpose or in medical applications. We encourage all users to familiarize themselves with US patent https://www.google.no/patents/US20150356243 "Systems and methods for identifying polymorphisms".


In this part, we will show how to run pleioFDR via matlabruntime,sif singularity container. Here are the step by step roadmap. 


1- Download the required code and data

 ```
git clone https://github.com/precimed/pleiofdr && cd pleiofdr
wget https://precimed.s3-eu-west-1.amazonaws.com/pleiofdr/pleioFDR_demo_data.tar.gz
tar -xzvf pleioFDR_demo_data.tar.gz
```

2-  Copy runPleiofdr.m file to  /pleiofdr  (runPleiofdr.m is a function that can accapt custom configfile as input)



3- We then need to compile and package  ``runPleiofdr.m`` . Note that, we should also need other mfiles and data in the project to run this code. Hence we need to add them via  `` -a ``  option as

 ```
mcc -m runPleiofdr.m -a ./

```

Here  ``-a ./ ``  adds all subdirectories of the current working directory.  You may want  tolook here: (https://ch.mathworks.com/help/compiler/mcc.html) if you want to know more options.

 Once the Matlab compiler created packaged application of runPleiofdr.m, you may find it as ``runPleiofdr``  in  ``/pleiofdr``

` 

4- If we have matlabruntime2021a.sif container, then we are ready to run pleioFDR. Make sure that you are at ``/pleiofdr``  and then run your container

 ```
sudo singularity shell --bind  $PWD:/execute   /nrec/projects/matlabruntime2021a.sif

cd /execute

./runPleiofdr '/execute/config.txt'


```

5- If everyhing goes on well, you should observe the outputs (figures and data) in  ``/pleiofdr/results`` folder 


 ```

Saving .csv... Warning: Directory already exists.
> In save_to_csv (line 9)
  In pleiotropy_analysis (line 265)
  In runme (line 176)
Warning: Directory already exists.
> In save_to_csv (line 9)
  In pleiotropy_analysis (line 266)
  In runme (line 176)
done
Creating Manhattan plots... writing results/COGchr21_EDUchr21_conjfdr_0.01_manhattan.fig
writing results/COGchr21_EDUchr21_conjfdr_0.01_manhattan.svg
done


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





    
    

 
 
    

    
    


 
    

