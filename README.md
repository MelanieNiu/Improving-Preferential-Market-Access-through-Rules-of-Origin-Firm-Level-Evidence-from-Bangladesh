# Term-paper-2
## Overview
This repo is for the paper "Assessing the Impact". This article was replicated from the article "Improving Preferential Market Access through Rules of Origin: Firm-Level Evidence from Bangladesh" by Tobias Sytsma in 2022. The doi for the original paper is https://doi.org/10.1257/pol.20200257. This README document explains the files and data required for replicating this article. 

## File Structure
The repo is structured as follows: 

-   `main_folder` contains all folders listed below:
-   `data` contains all the data used in this study including `analysis_data`, `raw_data`, and `simulated_data`.
-   `other` contains `llm`, which contain the LLM statement; and `sketches`, which contain preliminary sketches of the dataset before the actual analysis. 
-   `paper` contains the qmd document used to generate the paper,the pdf document of the paper, and the bib.txt file for bibliography. 
-   `scripts` contains the R scripts used to simulate, clean, test data. It also contains the R script to replicate Figure 1, Figure 3 and Figure 4 from the paper "Improving Preferential Market Access through Rules of Origin: Firm-Level Evidence from Bangladesh" by Tobias Sytsma in 2022.

## Data Availability Statment
There are two main data sources used to produce the results in this article. Both of the data sources are publicly available and can be accessed after registering an account online. Below I described how each dataset was used in the analysis and how a replicator can access them. 

- Eurostat's Adjusted extra-EU imports since 2000 by tariff regime, by HS2-4-6 and CN8

  The data can be downloaded from the Eurostat Database at the URL https://ec.europa.eu/eurostat/comext/newxtweb/, by clicking on the purple button "Search datasets", then under "search by labels", enter "Adjusted extra-EU imports since 2000 by tariff regime", then click on "search" then from the generated results select the dataset with the name "Adjusted extra-EU imports since 2000 by tariff regime". Once the database is selected, move on to select all available countries under Reporter, select LDC countries categorized by United Nations at https://www.un.org/ohrlls/content/list-ldcs under Partner, select all products with 62 and 61 as Product, select Normal under Stat_procedure, select Only GSP under Eligibility, select all available for Import_regime, select 2001 to 2018 for Period, and select 'Value in Euros' for Indicators. 
  This dataset was reproduced in the replication package for "Improving Preferential Market Access through Rules of Origin: Firm-Level Evidence from Bangladesh". I have replicated this dataset in the folder `raw data`. 
  
- UN Comtrade
  This dataset can be downloaded from United Nation’s Comtrade database by accessing the World Bank’s WITS query tool. Dissemination of the raw Comtrade data is not permitted. After creating an account with WITS at here https://wits.worldbank.org/ WITS/WITS/Restricted/Login.aspx, one can access the database by selecting 'Advanced Query', and 'Trade Data (UN Comtrade)'. After naming your query, selecting China and LDC countriesas select LDC countries (categorized by United Nations at https://www.un.org/ohrlls/content/list-ldcs) under Reporters. For products, select HS 2002 classification then 61 and 62 under product codes. For partners select World and EU27. For years, select 2002 - 2020, and for Trade Flow select Exports. This raw dataset was reproduced in the the replication package for "Improving Preferential Market Access through Rules of Origin: Firm-Level Evidence from Bangladesh". I have replicated this dataset in the folder `raw data`. 


## Statement on LLM Usage
Statement on LLM usage: Aspects of the code were written with the help of the autocomplete tool, Chat-GPT3.5. Some part of the discussion was written with the help of Chat-GPT3.5 for prompts.  The entire chat history documented at others/llm/usage.txt.
