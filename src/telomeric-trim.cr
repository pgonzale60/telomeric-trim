require "../lib/klib"
include Klib

# Trim telomeric repeats from reads
# Reads containing telomere will be returned beggining with
# the position where the telomere was found

# default motif (nematodes)
motif = "TTAGGC"
min_occur = 3

if ARGV.size < 1
  puts "Usage: telomeric-trim <in.fasta> [motif] [min_number_of_contiguous_occurrences]"
  puts ""
  exit(0)
end

if ARGV.size > 1
  motif = ARGV[1]
end

if ARGV.size > 2 && ARGV[2].to_i.is_a?(Number)
  min_occur = ARGV[2].to_i
end

# Create the reverse motif sequence
rev_motif = motif.reverse.tr("ATGC","TACG")

# Trim reads
fp = GzipReader.new(ARGV[0])
fx = FastxReader.new(fp)
while (r = fx.read) >= 0
    read = fx.seq.to_s
    # Search telomere
    # in the end of the read in a space of 3 times the length of the motif
    if read.index(motif, -motif.size * 3)
        motifOccur = read.index(motif * min_occur)
        if motifOccur
            puts ">#{fx.name.to_s}"
            # Remove the telomere and reverse complement the read
            puts read[0, motifOccur].reverse.tr("ATGC","TACG")
        end
    # Search for reverse telomere in 
    # the beggining of the read in a space of 3 times the length of the motif
    elsif read.rindex(rev_motif, motif.size * 3)
        motifOccur = read.rindex(rev_motif * min_occur)
        if motifOccur
            puts ">#{fx.name.to_s}"
            puts read[motifOccur + rev_motif.size * min_occur, read.size]
        end
    end
end

raise "ERROR: malformatted FASTX" if r != -1
fp.close
