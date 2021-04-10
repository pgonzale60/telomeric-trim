# Telomeric trim

I needed to identify the end of chromosomes and I am working with PacBio HiFi reads. These are stranded. This simple linux executable will take as fasta file (can be compressed) and will see if it starts or ends with the telomeric repeat. If it does, it will trim the first occurence of the motif with X contiguous times: `./telomeric-trim <reads.fa> [motif] [X]`.

I compiled the binary with static links using the following command.

```
singularity run --bind $(pwd):/workspace --workdir /workspace crystal_latest-alpine.sif crystal build src/telomeric-trim.cr --static
```