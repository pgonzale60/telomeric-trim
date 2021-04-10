require "../lib/klib"

include Klib

# default motif (nematodes)
motif = "TTAGGC"
min_occur = 3

if ARGV.size < 1
  puts "Usage: trim <in.fasta> [motif] [min_number_of_contiguous_occurrences]"
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
    if read.index(motif, -motif.size * 3)
        motifOccur = read.index(motif * min_occur)
        if motifOccur
            puts ">#{fx.name.to_s}"
            puts read[0, motifOccur]
        end
    elsif read.rindex(rev_motif, motif.size * 3)
        motifOccur = read.rindex(rev_motif * min_occur)
        if motifOccur
            puts ">#{fx.name.to_s}"
            puts read[motifOccur + rev_motif.size * min_occur, read.size].reverse.tr("ATGC","TACG")
        end
    end
end

raise "ERROR: malformatted FASTX" if r != -1
fp.close