The script <b>run_analysis.R</b> does the following things, in order, assuming we're in a directory where the provided zip file has been extracted.
1. Read feature names from _features.txt_, and stores them in a character vector _features_.
2. Preprocess and process the training and test datasets separately, and then combines them into one dataframe called _biometricData_.
3. Read in the subject ID's and add them to the dataframe.
4. Read in the activity labels and add them to the dataframe.
5. Create a new dataframe, grouping _biometricData_ by subject ID's and activity labels, and calculating the average for each group.
6. Writing the resulting dataframe into a text file.
  
