<div align='center'>
    <a href='https://tula.org'><img height='75px' src=docs/logos/tula-logo.png /></a>
    &nbsp;&nbsp;&nbsp;&nbsp;
    <a href='https://hakai.org'><img height='75px' src=docs/logos/hakai-logo.png /></a>
</div>

# Hakai Institute Nearshore Program - Nereocystis kelp canopy productivity data from BC Central Coast, v1.3.0 

The nereocystis canopy production dataset is a component of Hakai Institute’s Nearshore research and monitoring program. This dataset documents seasonal changes in Nereocystis luetkeana density, size structure and growth parameters at multiple locations near Calvert Island on the Central Coast of British Columbia (BC) since 2016.  Each year, sites were visited 1 - 5 times over the summer months (April-September) and 0 - 2 times over the winter months. Fifteen plants were tagged at each site to measure individual stipe growth, blade elongation, blade erosion, change in number of blades and plant survival. Additional plants (up to 45 per site) were measured for stipe and blade size structure distributions. Three permanent transect lines were used to track change in plant density and relocate the tagged plants. Blade growth rate ranged from 0 to 15 cm per day through the summer months and stipe growth ranged from 0 to 12 cm a day, depending on site and time of year. Based on these data we can determine which field parameters best correlate with overall kelp productivity and biomass, to refine metrics for long-term assessments of Nereocystis luetkeana status in BC and ultimately find what environment factors are driving these local temporal and spatial trends.

  This data package is freely available to everyone, following the principles of equitable access and benefit sharing. However, we expect all data users to give attribution to the data providers (read our data license) and the use of these data should happen in the light of fair use, i.e.: 1) respect the data providers, and provide helpful feedback on data quality, and 2) communicate and/or collaborate with the providers if you are considering using this dataset for manuscripts or other forms of reporting.



```
 Pontier, O., Burt, J., Okamoto, D., and Hessing-Lewis, M.(2025). Nereocystis kelp canopy productivity data from BC Central Coast, v1.3.0. [Date accesed]. Hakai Institute. https://doi.org/10.21966/d1s2-s530
```


##Documents

- R scripts:
Convert raw data (nereo_metrics.csv) into long form (metrics_long.csv) - metrics_long.R
Calculate rates: blade growth, stipe growth, erosion and blade - metrics_rates.R
Amalgamate all tagged plants into one dataframe - tag_loss.R
Estimates biomass per m2 per plot based on morphometrics relationships and density - nereo_biomass_estimates.R

## Resources

- Package Changes: Changelog for additions and changes done to this data package. (Changelog.txt)
- Description of field survey methods and site information. (Protocols.pdf)
- Data Dictionary for a description of all variables contained in this package. (Data_dictionary.csv)

# Scripts 
- Convert raw data (nereo_metrics.csv) into long form (metrics_long.csv) - metrics_long.R
- Calculate rates: blade growth, stipe growth, erosion and blade - metrics_rates.R
Amalgamate all tagged plants into one dataframe - tag_loss.R
- Estimates biomass per m2 per plot based on morphometrics relationships and density - nereo_biomass_estimates.R

# Raw data documents
- Underwater Nereocystis luetkeana adult (>1m) stipe counts (nereo_density.csv)
- Underwater N. luetkeana adult sub-bulb diameter (mm) measurements (nereo_size.csv)
- Additional underwater morphometric measurements taken on N. luetkeana plants in permanent plots inter- and intra-annually including stipe and blade elongation (nereo_metrics.csv) 
- Out of water measurements taken on harvested N. luetkeana plants inter-annually (nereo_harvest.csv) 
- Dried N. luetkeana tissue (nereo_wet_dry.csv) 
- Additional plants tagged for plant loss (tag_additional.csv)

#Compiled data documents:
- Long form version of underwater morphometrics measurement file (metrics_long.csv) 
- Summarized growth rates (metrics_rates.csv)
- Amalgamation of all tag data sources (tag_loss.csv)
- Plot level based summary estimates in regards to biomass (nereo_plot_estimates.csv)

#Link to any associated resources:

- Previous versions are archived [here](https://drive.google.com/drive/u/0/folders/14EWU0zY1prKYkoXglIMxtnjuHt6XyYTa)
- Data Management Plan
- CIOOS CKAN record
- ERDDAP Dataset
- External Data Repositories
- Publications

*This repository is generated via the [Hakai dataset repository template](https://github.com/HakaiInstitute/hakai-dataset-repository-template)*
