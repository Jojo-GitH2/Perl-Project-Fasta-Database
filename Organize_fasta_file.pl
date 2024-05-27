#!/usr/bin/perl
use strict;
use warnings;

# Check if the user provided an input file
unless (@ARGV) {
    die "Usage: $0 <input.fasta>\n";
}

my $input_file = shift @ARGV;
open my $fh, '<', $input_file or die "Cannot open file $input_file: $!";

my ($header, $sequence, $protein_count) = ('', '', 0);
while (my $line = <$fh>) {
    chomp $line;
    if ($line =~ /^>/) {
        # Print information for the previous protein (if any)
        if ($header && $sequence) {
            $protein_count++;
            print "Protein $protein_count:\n";
            print "ID: $header\n";
            print "Length: " . length($sequence) . " amino acids\n";
            print "Sequence:\n$sequence\n\n";
        }
        # Start processing the next protein
        ($header) = $line =~ /^>(\S+)/;
        $sequence = '';
    } else {
        # Accumulate sequence
        $sequence .= $line;
    }
}

# Print information for the last protein
if ($header && $sequence) {
    $protein_count++;
    print "Protein $protein_count:\n";
    print "ID: $header\n";
    print "Length: " . length($sequence) . " amino acids\n";
    print "Sequence:\n$sequence\n";
}

close $fh;

