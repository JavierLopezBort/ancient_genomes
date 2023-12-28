sys.setrecursionlimit(10000)


STEPSMSA=["0","10","20","30","40","50","100","150","200","300","400","500","600"]
LENGTHS=["30","35","40","45","50","55","60","65","75","85","100","150","200","400"]
RATES=["0.00010","0.00015","0.00020","0.00025","0.0003","0.00035","0.0004","0.00045","0.0005","0.0006","0.0007","0.0008","0.0009","0.001","0.003","0.005","0.007","0.009","0.01","0.03","0.05","0.07","0.09","0.1","0.3","0.5","0.7","0.9"]
DAMAGE=["dhigh","dmid","single","none"]
ALIGNERS=["mem","aln","aln_anc","bowtie2","shrimp","vg","bb"]
NUMFRAGS=1000000

rule all:
    input:
        expand("stat/numtS_and_gen_{step}_n{nfrags}_l{fraglen}_d{dam}_s{rate}_{align}.stat",step=STEPSMSA,nfrags=NUMFRAGS,fraglen=LENGTHS,dam=DAMAGE,rate=RATES,align=ALIGNERS)

rule stat:
    input: "alignments/numtS_and_gen_{step}_n{nfrags}_l{fraglen}_d{dam}_s{rate}_{align}.bam"
    output: "stat/numtS_and_gen_{step}_n{nfrags}_l{fraglen}_d{dam}_s{rate}_{align}.stat"
    shell: "python3 parseBamMito.py {input} > {output}"


