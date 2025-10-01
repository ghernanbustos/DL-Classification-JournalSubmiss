# Paper_machineLearning_project
This project contains Deep Learning trained models files used in the research work "Extended method for Statistical Signal Characterization using moments
and cumulants: Application to recognition of pattern alterations in pulse-like waveforms employing Artificial Neural Networks". 
- DataSets.
- Deep Learning training scripts.

## Google drive link
There are two folder
- 1_DeepLearning_256pt
- 2_DeepLearning_1024pt

For 1024 signal samples, the project size exceeds the allowed by GitHub, so download from [DeepLearning_1024pt]()
and include in the respective folder.

## Datasets for training process:
Folders `<signal-type>_<snr-level>dB` contains raw data generated with [App Name](link to project). 
This files are formatted with `DataBaseGen_RawSignal_<train or test>.m` script and save as .mat file
incluided in same folder. There are a single .mat dataset file for each signal type and SNR level. 
The end dataset size is 5000x256 or 1024, 1000 signals per filter deformation leading into 5 labels.


## Deep Learning Training script File:

Once train and test datasets are formated into 5000x256 or 5000x1024 are able to be imported into respective DL folder.  

### How to Reproduce the Workflow

1. **Run `<signal-type>_1D_CNN_HPO.m`**  
   The script will load the imported datasets
   ```
   	load ('Sinc_25dB_Train.mat'); % 5000x1024

	load ('Sinc_25dB_Test.mat');  % 5000x1024
	load ('Sinc_20dB_Test.mat');  % 5000x1024
	load ('Sinc_15dB_Test.mat');  % 5000x1024
	load ('Sinc_10dB_Test.mat');  % 5000x1024
	load ('Target_LabelNumbered.mat');
   ```
   and executes bayes optimization training
   
   ```
	%------------------- HPO 1D-CNN -------------------------------------------

	optimVars = [
	    optimizableVariable('SectionDepth',[1 3],'Type','integer')
	    optimizableVariable('InitialLearnRate',[1e-2 1],'Transform','log')
	    optimizableVariable('Momentum',[0.8 0.98])
	    optimizableVariable('L2Regularization',[1e-10 1e-2],'Transform','log')];

	ObjFcn = makeObjFcn(XTrain,TTrain,XValidation,TValidation);

	% Calls bayesopt function
	BayesObject = bayesopt(ObjFcn,optimVars, ...
	    'MaxTime',14*60*60, ...
	    'IsObjectiveDeterministic',false, ...
	    'UseParallel',false);   
   ```

<figure>
  <p align="center">
  <img src="./Images/training_progress" width="500">
  </p>
</figure>
<p align="center">
	Bayes Optimization Training process.
</p>

At the end trained model parameters will be saved in `<signal-type>Workspace.mat` file.

## Measuring Algorithm Execution Time

To measure execution time, run the script `timeMeasure.m` 
to calculate DL computation time, where each processing time value represents the average of 100 algorithm executions.

## File Table List:

| Folder             				|              Description			      |
|-------------------------------------------------------|-----------------------------------------------------|
| `<signal-type>_<snr-level>dB`	|Raw data and script to format dataset|
| `Deep_Learning_<signal-type>`	| Script for traning and excecution time measurment|
| File             				|              Description			      |
|-------------------------------------------------------|-----------------------------------------------------|
| `<signal>_1D_CNN_HPO.m`						| Training network script     |
| `timeMeasure.m`				| algorithm excecution time measurement|	
| `<signal-type>_gauss1_25dB_testElement`                | raw signal element (signal amplitude and time) to test timeMeasure |


## Author

- Guillermo H. Bustos 	(ghernanbustos@gmail.com)
- Héctor H. Segnorile 	(segnoh@gmail.com)
- **Institution**: Instituto de Física Enrique Gaviola (IFEG CONICET)- Universidad Nacional de Córdoba - FAMAF































