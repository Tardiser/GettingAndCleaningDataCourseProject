### This codebook explains the variables used in the run_analysis script.

- **X_train, X_test, y_train, y_test**: Original imported text files with the same name.

- **train, test**: X and y's merged into their appropriate tables.

- **mergedSamsung**: *train* and *test* variables combined into one table.

- **features**: imported text file with the same name.

- **means**: Observations from the *features* table that contains the word "mean". (Not case sensitive)

  - **meanIndex**: Index numbers of the observations mentioned above.

- **stds**: Observations from the *features* table that contains the word "std". (Not case sensitive)

  - **stdIndex**: Index numbers of the observations mentioned above.

- **meanandstdIndex**: Sorted and combined *meanIndex* and *stdIndex* into one variable.

- **mergedSamsungFiltered**: *mergedSamsung* table filtered by using the indexes from the *meanandstdIndex* variable.

- **factorized**: A new variable created by factorizing the outcome column of the *mergedSamsungFiltered*.

- **groupedDF**: Wanted tidy dataset created by grouping the *mergedSamsungFiltered* variable.
