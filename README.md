# rchictr
An R package to extract data from the Chinese Clinical Trial Repository (ChiCTR).


## Usage

1. Install package.

    ```r
    devtools::install_github("serghiou/rchictr")
    ```

2. Navigate to [ChiCTR](http://www.chictr.org.cn/searchproj.aspx), build a query and click on "Filter". For the purposes of this vignette, I will enter "COVID" in the "Registratio topic" text box. Then, copy the URL obtained as soon as you click on "Filter".

3. Download the results table corresponding to the copied link.

    ```r
    library(rchictr)
    results <- chictr_read_results("http://www.chictr.org.cn/searchproj.aspx?title=COVID&officialname=&subjectid=&secondaryid=&applier=&studyleader=&ethicalcommitteesanction=&sponsor=&studyailment=&studyailmentcode=&studytype=0&studystage=0&studydesign=0&minstudyexecutetime=&maxstudyexecutetime=&recruitmentstatus=0&gender=0&agreetosign=&secsponsor=&regno=&regstatus=0&country=&province=&city=&institution=&institutionlevel=&measure=&intercode=&sourceofspends=&createyear=0&isuploadrf=&whetherpublic=&btngo=btn&verifycode=&page=1")
    ```

4. Extract all data of interest for the trials obtained in the results.

    ```r
    library(pbapply)
    trials_list <- pbapply::pblapply(results$trial_urls, chictr_read_trial, cl = 7)
    trials <- dplyr::bind_rows(trials_list)
    ```

5. Save as CSV in a folder called "data".

    ```r
    write_csv(trials, "../data/chictr-covid.csv")
    ```


## Alternatives

* A list of clinincal trial registry scrapers can be found in the [opentrials/registers GitHub repository](https://github.com/opentrials/registers).

* I have another package for ClinicalTrials.gov [here](https://github.com/serghiou/clinicaltrialr).


## Acknowledgements

* This package would not have been possible without the [xml2 package](https://github.com/r-lib/xml2).

* All I know about building packages I owe to Hadley Wickham and Jennifer Bryan's [book](https://r-pkgs.org/)!


## TODO

This release only contains the basic functions to download and extract basic fields of studies - the ability to download a lot more fields is coming soon.

</div>

