#!/usr/bin/perl
use Switch;

## Get File Name and open file ---------------------------------------------------
sub getFileLines {
  print "Please enter the name of the file containing the template strand of the DNA:  \n";
  $filename = <STDIN>;
  print "Searching for ", "$filename \n";
  open(DATA, "<$filename") or die "Couldn't open file $filename, $!";
  @lines = <DATA>;
  close DATA;
  return @lines;
}

## Transcription -----------------------------------------------------------------
sub transcribe {
  my $dna = $_[0];
  print "DNA: $dna \n" ;
  print '-' x 180, "\n";
  $mRNA = "";
  for $i (0..length($dna)-1) {
    $base = substr($dna,$i,1);
    switch($base) {
      case "t" {$base = "a"}
      case "a" {$base = "u"}
      case "c" {$base = "g"}
      case "g" {$base = "c"}
    }
    $mRNA = $mRNA.$base
  }
  return $mRNA;
}

## Translation --------------------------------------------------------------------
sub translate {
  my %codonsToAA;
  $codonsToAA{$_} = "STOP" for qw(uaa uag uga);
  $codonsToAA{$_} = "Phe" for qw(uuu uuc);
  $codonsToAA{$_} = "Leu" for qw(uua uug cuu cuc cua cug);
  $codonsToAA{$_} = "Ile" for qw(auu,auc,aua);
  $codonsToAA{"aug"} = "Met";
  $codonsToAA{$_} = "Val" for qw(guu guc gua gug);
  $codonsToAA{$_} = "Ser" for qw(ucu ucc uca ucg agu agc);
  $codonsToAA{$_} = "Pro" for qw(ccu ccc cca ccg);
  $codonsToAA{$_} = "Thr" for qw(acu acc aca acg);
  $codonsToAA{$_} = "Ala" for qw(gcu gcc gca gcg);
  $codonsToAA{$_} = "Tyr" for qw(uau uac);
  $codonsToAA{$_} = "His" for qw(cau cac);
  $codonsToAA{$_} = "Gln" for qw(caa cag);
  $codonsToAA{$_} = "Asn" for qw(aau aac);
  $codonsToAA{$_} = "Lys" for qw(aaa aag);
  $codonsToAA{$_} = "Asp" for qw(gau gac);
  $codonsToAA{$_} = "Glu" for qw(gaa gag);
  $codonsToAA{$_} = "Cys" for qw(ugu ugc);
  $codonsToAA{"ugg"} = "Trp";
  $codonsToAA{$_} = "Arg" for qw(cgu cgc cga cgg aga agg);
  $codonsToAA{$_} = "Gly" for qw(ggu ggc gga ggg);
  my $mRNA = $_[0];
  $shortmRNA = substr $mRNA, index($mRNA,'aug');
  @codonArray = ( $shortmRNA =~ m/.../g );
  my $idx = 0;
  my @aaSequence;
  foreach (@codonArray) {
    print $codonsToAA{$_};
    if ($_ eq 'uag' or $_ eq 'uaa' or $_ eq 'uga') {
      @codonArray = @codonArray[0..$idx];
      last;
    }
    $idx += 1;
  }

  return @aaSequence;
}


@lines = getFileLines();
chomp @lines;

$DNA = "";
foreach (@lines) {
  $DNA = $DNA."$_";
}

$mRNA = transcribe($DNA);
print "new mRNA: $mRNA, \n";
print '-' x 180, "\n";
$aaSequence = translate($mRNA);