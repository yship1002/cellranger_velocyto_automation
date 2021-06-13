#!/bin/bash
#This script is used to get user's specified parameter and run main.sh using those parameters
#User can save the parameters for future use and these parameters will be saved in save.sh
#When user run this script they will be asked whether they want to process their data using their previous parameters
#If yes the data will be processed immediately otherwise this script will ask user to input all necessary new parameters


echo "Hello! Thank you for using this automated script to process your data!"
echo ""
echo "Did you want to process data using your previous parameters?"
echo "Input 1 if you want to use previous set of parameters, or input 0 if you want to use a new set of parameters!"
echo ""
read import

#Read user's intention to run using previous parameters or want to use new set of parameters
if [ ${import} == 1 ]
then
    #User wants to process data using previous set of parameters
    #import user's previous set of parameters from save.sh and  run the data immediately
    source save.sh
    echo 'Sidenote: If you want to take a peek into the progress of your job do this: cat onscreenoutput.out'
    echo 'If your job exceeds time limit just rerun this script again by'
    echo 'bash run_me.sh'
    sbatch main.sh ${email} ${data} ${transcriptome} ${ID} ${sample_name} ${maskfile1} ${maskfile2} ${outputloom}
    exit
fi

#User wants to provide new set of parameters
echo "Before we can process your data we need you to give us some parameters in order to run!"
echo ""




##########################################################
#            Start of user inputting parameters
##########################################################





#Get user's email address
echo "Please input your tulane email address, you will get notification when the job is finished"
echo ""
echo "For example: jyang10@tulane.edu"
read email
echo ""
echo "This is the email address you have entered"
echo ${email}
echo ""
echo ""




#Get user's data folder path
echo "Input your data folder path you want to process!"
echo "This directory is also where fastq files are:"
echo "For example: /lustre/project/wdeng7/jyang10/data"
read data
echo ""
echo "Your fastq files are in this below folder"
echo ${data}
echo ""
echo ""




#Get user's transcriptome folder path
echo "Input transcriptome folder absolute path here!"
echo "For example: /lustre/project/wdeng7/deep/CellRangerData/refgenome4cellranger"
read transcriptome
echo ""
echo "This is the transcriptome folder you have entered:"
echo ${transcriptome}
echo ""
echo ""



#Get user's specification of what the name of subfolder will be
echo "Input your ID for cellranger here!"
echo "A subfolder with the name you specified here will be created in 'data' folder"
echo "For example: samplePF"
read ID
echo ""
echo "This is the name of the subfolder you have entered"
echo ${ID}
echo ""
echo ""




#Get user's specification of what samples he wants to run
echo "Include Sample names you want to analyze! "
echo "For example: PF_1,PF_2"
read sample_name
echo ""
echo "These are the names of the sample you want to analyze"
echo ${sample_name}
echo ""
echo ""




#Get user's maskfile1 and maskfile2
echo "Input your transcriptomic sequence with certain regions masked (maskfile1) and nmasked transcriptome in gtf file format (maskfile2)"
echo "Input your maskfile1!"
echo "For example: /lustre/project/wdeng7/deep/dm6/dm6_rmsk.gtf"
read maskfile1
echo ""
echo ""



echo "Input your maskfile2!"
echo "For example: /lustre/project/wdeng7/deep/dm6/genes/Drosophila_melanogaster.BDGP6.28.100.chr_filtered.GAL4.EGFP.gtf"
read maskfile2
echo ""




echo "These are the two mask files you have entered"
echo ""
echo "Maskfile1 is:"
echo ${maskfile1}
echo ""
echo ""
echo "Maskfile2 is"
echo ${maskfile2}
echo ""
echo ""





#Get user's specification on which folder he wants to store the output
echo "Where do you want to store your loom file from velocyto?"
echo "For example: /lustre/project/wdeng7/jyang10/result"
read outputloom
echo ""
echo ""
echo "This is the location where you want to store your output of loom file"
echo ${outputloom}
echo ""
echo ""



##########################################################
#            End of user inputting parameters
##########################################################





#User can choose to process data right now or save for future use
echo "That is all you need to do for now!"
echo "Do you want to run now?"
echo ""
echo "Input 1 to run now or input 0 to save your parameters and exit!"
read sign


if [ ${sign} == 1 ]
then
    #User selected to run now
    echo 'Sidenote: If you want to take a peek into the progress of your job do this: cat onscreenoutput.out'
    echo 'If your job exceeds time limit just rerun this script again by'
    echo 'bash run_me.sh'
    sbatch main.sh ${email} ${data} ${transcriptome} ${ID} ${sample_name} ${maskfile1} ${maskfile2} ${outputloom}
else
    #User wants to save the parameters for future use
    #These lines below are writing user's set of parameters into save.sh
    echo "#!/bin/bash" > save.sh
    echo email=${email} >> save.sh
    echo data=${data} >> save.sh
    echo transcriptome=${transcriptome} >> save.sh
    echo ID=${ID} >> save.sh
    echo sample_name=${sample_name} >> save.sh
    echo maskfile1=${maskfile1} >> save.sh
    echo maskfile2=${maskfile2} >> save.sh
    echo outputloom=${outputloom} >> save.sh
    echo "Your parameter has been saved to the file:"
    echo "save.txt"
    echo ""
    echo "You will be prompted to use your previous paramters to run next time you run this script!"
    exit
fi

