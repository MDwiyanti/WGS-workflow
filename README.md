# WGS-workflow

This is a workflow to map whole genome resequencing raw reads to a reference genome using bwa mem and picard.
In this tutorial, soybean reference genome Williams82 (Gmax_275_v2.0.fa) is used.
The sequence can be obtained from Phytozome database (https://phytozome.jgi.doe.gov/pz/portal.html).

Citation and installation
1. bwa : Li H and Durbin R (2009) Fast and accurate short read alignment with Burrows-Wheeler Transform.
          Bioinformatics, 25:1754-60. [PMID: 19451168]
          (http://bio-bwa.sourceforge.net)
2. picard : http://broadinstitute.github.io/picard/
3. GATK:  McKenna A, Hanna M, Banks E, Sivachenko A, Cibulskis K, Kernytsky A, Garimella K, Altshuler D, Gabriel S, Daly M,        
          DePristo MA (2010) The Genome Analysis Toolkit: a MapReduce framework for analyzing next-generation DNA sequencing 
          data. GENOME RESEARCH 20:1297-303
          (http://gatk.broadinstitute.org/hc/en-us)

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



4.  Run mapping using wgs.sh (start from mapping by bwa mem to fixmate-markduplicate by picard.jar).
    
    For example:
    
          sh wgs.sh 3 Sample01_1.fq.gz Sample01_2.fq.gz Sample01

   
     usage: sh wgs.sh <number_of_threads> <raw_reads_pair1> <raw_reads_pair2> <sample_name>
     
     Before running, edit <path_to_folder> in wgs.sh so it directs to the location of picard.jar and reference genome.
     This can be done in text editor.
     
     For example, if the reference genome is located in 'Desktop/reference' directory, set <path_to_folder> as:
          ~/Desktop/reference/Gmax_275_v2.0.fa
        
        
          
5. wgs.sh will give outputs : out.sam, sorted.bam, fixmate.bam, and Sample01.bam.

   Sample01.bam will be input for subsequent analyses such as SNP/indel calling using GATK. 
   
6. Optional: 
   add readgroup ID to sample using picard.jar. This is useful when we plan to do variant calling of multiple samples.
   
          java –jar <path_to_folder>/picard.jar AddOrReplaceReadGroups I=Sample01.bam O=Sample01.addrep.bam RGID=S01 RGLB=001 RGPU=001 RGSM=S01 RGPL=illumina VALIDATION_STRINGENCY=LENIENT CREATE_INDEX=TRUE & 
          
   
   RGID : sample name
   
   RGSM : sample name
  
   RGPL : sequencing platform
  
   RGPU : read group run barcode (arbitrary)
   
   RGLB : sequencing library (arbitrary)
          
          
        
6. RealignerTargetCreator, IndelRealigner, and variant calling using GATK3.8. 
   
   RealignerTargetCreator-IndelRealigner detects small misalignment around indel and adjust the alignment.
   
   Here, we use UnifiedGenotyper for variant calling.
   
   However, newer GATK4 does not utilize these options to call variants (will be added later).


          java -jar <path_to_folder>/GenomeAnalysisTK.jar -T RealignerTargetCreator -R <path_to_folder>/Gmax_275_v2.0.fa -I Sample01.addrep.bam –o realn.list &

          java –jar <path_to_folder>/GenomeAnalysisTK.jar -T IndelRealigner –R <path_to_folder>/Gmax_275_v2.0.fa -I Sample01.addrep.bam -targetIntervals realn.list -o Sample01.realigned.bam &

          java -jar <path_to_folder>/GenomeAnalysisTK.jar -T UnifiedGenotyper –R <path_to_folder>/Gmax_275_v2.0.fa -I Sample01.realigned.bam -o Sample01.vcf -glm SNP -mbq 20 -out_mode EMIT_VARIANTS_ONLY &
          
          
    Options:
    
    -glm            BOTH, SNP, INDEL
    
    -mbq            integer (minimum base quality)
    
    -out_mode       EMIT_VARIANTS_ONLY, EMIT_ALL_CONFIDENT_SITES, EMIT_ALL_SITES                                        
    
          
          


          


   


   
   
   
   
