# WGS-workflow

This is a workflow to map whole genome resequencing raw reads to a reference genome using bwa mem and picard.
In this tutorial, soybean reference genome Williams82 (Gmax_275_v2.0.fa) is used.
The sequence can be obtained from Phytozome database (https://phytozome.jgi.doe.gov/pz/portal.html).

Citation and installation
1. bwa : Li H. and Durbin R. (2009) Fast and accurate short read alignment with Burrows-Wheeler Transform.
          Bioinformatics, 25:1754-60. [PMID: 19451168]
          (http://bio-bwa.sourceforge.net)
2. picard : http://broadinstitute.github.io/picard/


Before starting analysis, reference genome index should be prepared for both bwa and picard.

Create bwa index:
      
      bwa index Gmax_275_v2.0.fa &


Create sequence dictionary:
      
      java -jar picard.jar CreateSequenceDictionary REFERENCE=Gmax_275_v2.0.fa OUTPUT=Gmax_275_v2.0.dict &
      

