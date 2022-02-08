## Creating a Data Package for NES-LTER EIMS-TOI and NCP-GOP Cruise Data

This repository displays the workflow used to process NES-LTER Transect cruise data in preparation for publication of multiple packages to the Environmental Data Initiative repository. The eims-toi transect package contains oxygen-argon dissolved gas ratios and triple oxygen isotopes, ongoing since 2018. The ncp-gop transect packages contain net community production and gross oxygen production, based on oxygen-argon ratios and triple oxygen isotopes. 

**Acronym Descriptions:** *EIMS:* equilibration inlet mass spectrometer. *TOI:* triple oxygen isotope. *NCP:* net community production. *GOP:* gross oxygen production.

This workflow includes the following:
1) compiles data from provided files and supplies useful fields from the [REST API](https://github.com/WHOIGit/nes-lter-ims/wiki/Using-REST-API-to-access-NES-LTER-data) for the end user
2) cleans the provided data
3) performs quality assurance on the data
4) assembles and outputs the final XML file for submission to EDI

**Base Requirements:**
- Microsoft Excel
- R and R studio (*packages:* here, tidyverse, readxl, lubridate, devtools, EMLassemblyline, EML, maps, xml2)

### Collaborators:
Rachel Stanley (creator; PI), Arshia Mehta (creator), (Kevin Cahill (technician), Stace Beaulieu (associate; co-PI for the NES-LTER project), Jaxine Wolfe (metadata provider), Kate Morkeski (metadata provider)

### Package Status:
The first versions of these packages have been published. Refer to the [Releases](https://github.com/WHOIGit/nes-lter-eims-toi-ncp-gop/releases) page for links to individual published data packages.

