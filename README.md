## Creating a Data Package for NES-LTER EIMS-TOI and NCP-GOP Cruise Data

This repository displays the workflow used to process NES-LTER Transect cruise data in preparation for publication of two packages to the Environmental Data Initiative repository. The eims-toi transect package contains oxygen-argon dissolved gas ratios and triple oxygen isotopes, ongoing since 2018. The ncp-gop transect package contains net community production and gross oxygen production, based on oxygen-argon ratios and triple oxygen isotopes for cruise EN617 (summer 2018). 

**Acronym Descriptions:** *EIMS:* equilibration inlet mass spectrometer. *TOI:* triple oxygen isotope. *NCP:* net community production. *GOP:* gross oxygen production.

This workflow includes the following:
1) compiles data from provided MATLAB files and supplies useful fields for the end user
2) cleans the provided data
3) performs quality assurance on the data
4) assembles and outputs the final XML file for submission to EDI

**Base Requirements:**
- Microsoft Excel
- R and R studio (*packages:* tidyverse, readxl, R.matlab, lubridate, devtools, EMLassemblyline, EML, maps, xml2)

### Collaborators:
Rachel Stanley (creator), Kevin Cahill (technician), Zoe Sandwith (technician), Stace Beaulieu (associate; co-PI for the NES-LTER project), Jaxine Wolfe (associate; metadata provider)

### Package Status:
Not published.