# buscopainter
Painting chromosomes using BUSCOs 

## Running the scripts

### Assigning to chromosomes
`buscopainter.py` takes the `full_table.tsv` output file for two species, along with an optional prefix (specified with -p, default "buscopainter"), e.g.:
```
python3 buscopainter.py -r test_data/ilAglIoxx1_full_table.tsv -q test_data/ilApoTurb1_full_table.tsv
```

It will write two TSV files:

`[PREFIX]_summary.tsv` which contains a summary of the chromosomal assignments

`[PREFIX]_location.tsv` which contains locations of all shared BUSCOs. This file can be plotted using `plot_locations.R`

### Plotting
The `[PREFIX]_location.tsv` can be plotted as follows:
```
Rscript --vanilla plot_locations.R buscopainter_location.tsv
```
