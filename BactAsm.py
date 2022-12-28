#!/usr/bin/python3

import argparse
import os
import yaml
import sys

def get_arg(argv=None):
    parser=argparse.ArgumentParser(description="Fetch SRA records from NCBI and perform de novo assemble & read alignments to reference genome")

    parser.add_argument('-s', '--sra',metavar='', help= "SRA accession ID you would like to download", default="", required=False)
    parser.add_argument('-b', '--sampleID',metavar='',  help= "sampleID of the sample (this can be same as the SRA ID)", default="", required=False)
    parser.add_argument('-l', '--list', metavar='', help = "input list (provide each sample' SampleID and sraID in a row, separated by TAB)", default="", required=False)
    parser.add_argument('-f', '--ref', metavar='', help="reference genome (if not provided, no mapping action will perform in the pipeline)", default="", required=False)
    parser.add_argument('-o', '--output',metavar='',  help="output directory", default="", required=False)
    parser.add_argument('-t', '--thread', metavar='',type= int, help="number of threads to use", default=1, required=False)
    parser.add_argument('-k', '--kingdom',metavar='',  help="which kingdom the genome is from, default is Bacteria", default="Bacteria", required=False)
    parser.add_argument('-g', '--genus', metavar='', help="which genus the genome is from, default is Leptospira", default="Leptospira", required=False)
    return parser.parse_args()

def _get_samples(arguments):
    sample_dict={}
    if arguments.sra == "" and arguments.sampleID == "" and arguments.list != "": # if a list a provided for sample ID
        with open(arguments.list) as slist:
            for line in slist:
                ln_ls = line.strip("\n").split("\t")
                ln_ls_1 = [x.strip() for x in ln_ls][0:2]
                sample_dict[ln_ls_1[0]]= ln_ls_1[1]
    elif arguments.sra != "" and arguments.sampleID == "" and arguments.list == "": # if only sra is given, sra ID use as sampleID
        sample_dict[arguments.sra] = arguments.sra
    elif arguments.sra != "" and arguments.sampleID != "" and arguments.list == "":
        sample_dict[arguments.sampleID] = arguments.sra
    elif arguments.sra != "" and arguments.sra != "":
        sys.exit("Error: Input either take a single SRA accession (-s) or take a list of accession (-l), cannot do both")
    elif arguments.sra == "" and arguments.sampleID != "":
        sys.exit("Error: Please provid SRA accession ID")
    else:
        sys.exit("Error: Wrong input format. Input either take a single SRA accession (-s) or take a list of accession (-l)")
        
    return sample_dict
                
     
def generate_config(arguments):
    config_dict={
        'output_dir': arguments.output,
        'subworkflow': 'rules/',
        'threads_num' : arguments.thread,
        'kingdom': arguments.kingdom,
        'genus': arguments.genus,
        'reference': arguments.ref,
        'samples': _get_samples(arguments)
    }
    return config_dict
    
def main():    
    BactPrep_path = os.path.abspath(os.path.dirname(__file__))
    arguments=get_arg()
    config=generate_config(arguments)
    thread=arguments.thread
    config.update(config)     
    with open(os.path.join(BactPrep_path,arguments.config), "w") as configfile:
        yaml.dump(config,configfile)
    os.chdir(BactPrep_path)
    os.system ("snakemake --conda-frontend mamba --cores %d --use-conda --nolock --rerun-incomplete"%thread)

if __name__ == '__main__':
    main()
    