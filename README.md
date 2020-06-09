# WGS-workflow

This is a workflow to map whole genome resequencing raw reads to a reference genome using bwa mem and picard.
In this tutorial, soybean reference genome Williams82 (Gmax_275_v2.0.fa) is used.
The sequence can be obtained from Phytozome database (https://phytozome.jgi.doe.gov/pz/portal.html).

Citation and installation
1. bwa : Li H. and Durbin R. (2009) Fast and accurate short read alignment with Burrows-Wheeler Transform.
          Bioinformatics, 25:1754-60. [PMID: 19451168]
          (http://bio-bwa.sourceforge.net)
2. picard : http://broadinstitute.github.io/picard/

Steps:
1. One time action: Prepare reference genome indexes for both bwa and picard. 
   In directory containing Gmax_275_v2.0.fa,
   Create bwa index:
      
          bwa index Gmax_275_v2.0.fa &


   Create sequence dictionary:
      
          java -jar picard.jar CreateSequenceDictionary REFERENCE=Gmax_275_v2.0.fa OUTPUT=Gmax_275_v2.0.dict &


2. Create directory for each sample. For example, creating directory for Sample01

          mkdir Sample01
  
  
3. In Sample directory, create link to raw reads (paired-end data of Sample01 : Sample01_fq.gz and Sample01_2.fq.gz)

          ln -s <path_to_folder>/Sample01_1.fq.gz Sample01_1.fq.gz
          ln -s <path_to_folder>/Sample01_2.fq.gz Sample01_2.fq.gz


4.  Run mapping using wgs.sh (start from mapping by bwa mem to fixmate-markduplicate by picard.jar)
    Example:
    
          sh wgs.sh 3 Sample01_1.fq.gz Sample01_2.fq.gz Sample01

   
     usage: sh wgs.sh <number_of_threads> <raw_reads_pair1> <raw_reads_pair2> <sample_name>
     Before running, edit <path_to_folder> in wgs.sh so it directs to the location of picard.jar and reference genome.
     This can be done in text editor.
     
     For example, if the reference genome is located in 'Desktop/reference' directory, set <path_to_folder> as:
     ~/Desktop/reference/Gmax_275_v2.0.fa
          
          
5. wgs.sh will give outputs : out.sam, sorted.bam, fixmate.bam, and Sample01.bam
   Sample01.bam will be input for subsequent analysis such as SNV calling by GATK. 
   
   
   
   
