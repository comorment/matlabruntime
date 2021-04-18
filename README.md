# Running your matlab project via Singularity Containers

It is possible to run your matlab code in a container which does not have MATLAB. To do this, we first need to  build the standalone application of corresponding Matlab Code via Matlab Compiler locally and then run this application with the container  which has Matlab Runtime (https://ch.mathworks.com/products/compiler/matlab-runtime.html).

## Getting Started

* All examples presented here are done via Matlab Compiler 2018b and Matlab Runtime 2018b. Note that our container (matlabruntime.sif) presented here includes Matlab Runtime 2018b, and it may not support the applications created by  Matlab Compiler versions other than Matlab Compiler 2018b. Hence if you want to use this container without any issue, make sure that you have Matlab Compiler 2018b.

* Some Matlab functions/toolboxes are not supported or partially supported by Matlab Compiler. You may want to check  [here](https://ch.mathworks.com/products/compiler/compiler_support.html ) first

* Download ``matlabruntime.sif``, `` magicsquare.m ``   and `` magicsquare.zip ``  files placed in matlabruntime folder from [here](https://drive.google.com/drive/folders/1mfxZJ-7A-4lDlCkarUCxEf2hBIxQGO69?usp=sharing)
* Import these files  to your secure HPC environment (i.e. TSD, Bianca, Computerome, or similar).
* Extract the application file via ``unzip magifsquare.zip `` 



* The main aim is running your Matlab code  (magicsquare.m in this example) file within container. 


##  Running Matlab Runtime in Local

This can be done in two step:

1. Get the standalone application of your code via Matlab Compiler. A detailed instruction can be found here: (https://ch.mathworks.com/help/compiler/create-and-install-a-standalone-application-from-matlab-code.html). 

An example application called magicsquare provided via `` magifsquare.zip ``  Hence you can unzip and use this previously compiled application. If you do this, you can reach the corresponding application at /magicsquare/for_redistribution_files_only/magicsquare


Alternatively, you can build your own application from the actual mfile via terminal as

  ```
 mcc -m magicsquare.m

 ```



2. Then we can run the standalone application via Matlab Runtime.  You can this application by mounting the path of the application (in this example magicsqure application) to the container as;
 

  
  ```
  singularity exec --no-home  --bind  path/of/application:/execute         matlabruntime.sif         /execute/magicsquare 5

 ```
     
     
 
 
 
 
##  A comprehensive Example: How to run pleioFDR via Singularity container

Pleiotropy-informed conditional and conjunctional false discovery rate (pleioFDR) allows to boost loci discovery in low-powered GWAS by levereging pleiotropic enrichment with a larger GWAS on related phenotype, and to identify genetic loci joinly associated with two phenotypes.  The software is available here: https://github.com/precimed/pleiofdr

If you use pleioFDR software for your research publication, please cite the following paper(s):

-Andreassen, O.A. et al. Improved detection of common variants associated with schizophrenia and bipolar disorder using pleiotropy-informed conditional false discovery rate. PLoS Genet 9, e1003455 (2013).

The pleioFDR software may not be used for commercial purpose or in medical applications. We encourage all users to familiarize themselves with US patent https://www.google.no/patents/US20150356243 "Systems and methods for identifying polymorphisms".


In this part, we will show how to run pleioFDR via matlabruntime,sif singularity container. Here are the step by step roadmap. 

NOTE: If you do not have Matlab Compiler with the correct version or if you do not want to spend time with compiling, you can also go with already compiled application from [here](https://drive.google.com/file/d/1RjMNqstXtAfUq0LUKdIj4TApcaYC931r/view?usp=sharing). In this case you can download and unzip the application and directly jump to Step 4. 

1- Download the required code and data

 ```
git clone https://github.com/precimed/pleiofdr && cd pleiofdr
wget https://precimed.s3-eu-west-1.amazonaws.com/pleiofdr/pleioFDR_demo_data.tar.gz
tar -xzvf pleioFDR_demo_data.tar.gz
```

2-  We would like to run ``runme.m`` file. In order to run it via MatlabRuntime, we need to do a slight modification. We need to change  ``addpath( mlibrary ) ``  in runme.m  with:

 ```
if(isdeployed==false)
addpath( mlibrary );
end 
```

or alternatively you may change the whole ``runme.m``  code with the one provided in this repo.

3- We then need to compile and package  ``runme.m`` . Note that, we should also need other mfiles and data in the project to run this code. Hence we need to add them via  `` -a ``  option as

 ```
mcc -m runme.m -a ./

```

Here  ``-a ./ ``  adds all subdirectories of the current working directory.  You may want  tolook here: (https://ch.mathworks.com/help/compiler/mcc.html) if you want to know more options.

 Once the Matlab compiler created packaged application of runtime.m, you may find it as ``runme``  in  ``/pleiofdr``

4- Now we need to run this runme application via matlabruntime.sif container. All you need to do is, downloading this container as stated before and move it to the ``/pleiofdr`` 

5- Then we are ready to run pleioFDR. Make sure that you are at ``/pleiofdr``  and then run your container

 ```
singularity exec -B $PWD:/execute  matlabruntime.sif /execute/runme

```

6- If everyhing goes on well, you should observe the outputs (figures and data) in  ``/pleiofdr/results`` folder 


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





    
    

 
 
    

    
    


 
    

