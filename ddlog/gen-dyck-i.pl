#!/usr/bin/perl

use strict;

my $para_num = 2;
my %node_map;
my %edge_map;
my $edge_num=0;
my $n=0;
my $size=0; #number of edges

if ($#ARGV != 1 and $#ARGV != 2){
    die "Usage: ./gendyck.pl mode path_seq [path_init]\nmode=1 means write to dyck.dl\nmode=2 means dump incremental graph\nmode=3 means read init graph from path_init and perform the operations in path_seq with timestamp for each operation\nmode=4 means read init graph from path_init and perform the operations in path_seq with only a total timestamp\n";
}

my $path = $ARGV[1];
my $mode = $ARGV[0];
my $path_init = $ARGV[2];

open (FH, $path) or die "cannot open file $path!";
open (FHINIT, $path_init) or die "cannot open file $path_init!" if ($mode == 3 or $mode == 4);
#open (FH, "/nethome/yli3240/share/tal/incremental/btree_inc.seq") or die "cannot open file!";


sub gen_dl {
#    $size=2000;
    open(FHDL, '>', "dyck.dl");





    print FHDL "typedef node = u32\n";

#    for (my $i=0; $i<$size; $i++){
#	print FHDL "input relation A$i(s: node, t: node)\n";
#	print FHDL "input relation B$i(s: node, t: node)\n";
	
	print FHDL "input relation RA(idx: u16, s: node, t: node)\n";
	print FHDL "input relation RB(idx: u16, s: node, t: node)\n";
#    }

    print FHDL "input relation EMPTY(s: node, t: node)\n";
    print FHDL "output relation S(s: node, t: node)\n";




    print FHDL "S(x, y) :- S(x,z), S(z,y).\n";
#    for (my $i=0; $i<$size; $i++){
#	print FHDL "S(x, z) :- A$i(x, a), S(a, b), B$i(b, z).\n";
	print FHDL "S(x, z) :- RA(i, x, a), S(a, b), RB(i, b, z).\n";
#    }

    print FHDL "S(x, y) :- EMPTY(x, y).\n";

    close(FHDL);

}

sub print_node_init {
    foreach my $line (<FHINIT>){
    if($line =~ /^A (\d+) (\d+)/ or $line =~ /^D (\d+) (\d+)/){
	my $s = $1;
	my $t = $2;

	if (!exists $node_map{$s}){
	    $node_map{$s} = $n;
	    print "insert EMPTY($node_map{$s}, $node_map{$s});\n";
	    $n++;
	}
	if (!exists $node_map{$t}){
	    $node_map{$t} = $n;
	    print "insert EMPTY($node_map{$t}, $node_map{$t});\n";
	    $n++;
	}

	my $edgeid;
	if($line =~ /op--(\d+)/){
	    $edgeid=$1;
	}elsif($line =~ /cp--(\d+)/){
	    $edgeid=$1;
	}else{
	    die "cannot file edge index for $line";
	}
	if (!exists $edge_map{$edgeid}){
	    $edge_map{$edgeid} = $size;
	    $size++;
	}
	

    }else{
	die "cannot recogize nodes in $line\n"
    }
}
    
}

#open (FH, "files/test.seq") or die "cannot open file!";
sub print_node_seq {
    # A 821121444 445708996 op--5520
    foreach my $line (<FH>){
	if($line =~ /^A (\d+) (\d+)/ or $line =~ /^D (\d+) (\d+)/){
	    my $s = $1;
	    my $t = $2;

	    if (!exists $node_map{$s}){
		$node_map{$s} = $n;
		print "insert EMPTY($node_map{$s}, $node_map{$s});\n";
		$n++;
	    }
	    if (!exists $node_map{$t}){
		$node_map{$t} = $n;
		print "insert EMPTY($node_map{$t}, $node_map{$t});\n";
		$n++;
	    }

	    my $edgeid;
	    if($line =~ /op--(\d+)/){
		$edgeid=$1;
	    }elsif($line =~ /cp--(\d+)/){
		$edgeid=$1;
	    }else{
		die "cannot file edge index for $line";
	    }
	    if (!exists $edge_map{$edgeid}){
		$edge_map{$edgeid} = $size;
		$size++;
	    }
	    
	    
	}else{
	    die "cannot recogize nodes in $line\n"
	}
	$edge_num++;
    }    
}

sub print_edge_init {

    seek FHINIT, 0, 0;  #rewind

    foreach my $line (<FHINIT>){
	if($line =~ /^A /){
	    if($line =~ /^A (\d+) (\d+)/){
		my $s = $1;
		my $t = $2;
		my $ty; my $idx;
		if($line =~ /op--(\d+)/){
		    $idx = $1;
		    $ty = "RA";
		    #RA(i, x, a)
		    #	print "insert $ty($node_map{$s}, $node_map{$t});\n";
		    print "insert $ty($edge_map{$idx},$node_map{$s}, $node_map{$t});\n";
		    $ty = "RB";
		    print "insert $ty($edge_map{$idx},$node_map{$t}, $node_map{$s});\n";
		    
		}elsif($line =~ /cp--(\d+)/){
		    $idx = $1;
		    $ty = "RB";
		    print "insert $ty($edge_map{$idx},$node_map{$s}, $node_map{$t});\n";
		    $ty = "RA";
		    print "insert $ty($edge_map{$idx},$node_map{$t}, $node_map{$s});\n";
		}else{
		    die "cannot handle this line: $line\n"
		}
	    }
	    
	}elsif($line =~ /^D /){
	    die "We do not expect edge deletion in the init graph: $line";
	}
    }
    print "commit;\nstart;\ntimestamp;\n" if ($mode == 3);
}


sub print_edge_seq {
    seek FH, 0, 0;  #rewind
    my $ii = 1;
    my $edge_count=0;
    foreach my $line (<FH>){
	if($line =~ /^A /){
	    if($line =~ /^A (\d+) (\d+)/){
		my $s = $1;
		my $t = $2;
		my $ty; my $idx;
		if($line =~ /op--(\d+)/){
		    $idx = $1;
		    $ty = "RA";
		    print "insert $ty($edge_map{$idx},$node_map{$s}, $node_map{$t});\n";
		    $ty = "RB";
		    print "insert $ty($edge_map{$idx},$node_map{$t}, $node_map{$s});\n";

		    
		}elsif($line =~ /cp--(\d+)/){
		    $idx = $1;
		    $ty = "RB";
		    print "insert $ty($edge_map{$idx},$node_map{$s}, $node_map{$t});\n";
		    $ty = "RA";
		    print "insert $ty($edge_map{$idx},$node_map{$t}, $node_map{$s});\n";

		}else{
		    die "cannot handle this line: $line\n"
		}
		if($edge_count == int($ii * $edge_num / 10) and $ii <= 9){
		    print "timestamp;\n";
		    $ii++;
		}

		if($mode == 2 or $mode == 3){	    print "commit;\nstart;\n";}
	    }
	    $edge_count++;
	}elsif($line =~ /^D /){
	    if($line =~ /^D (\d+) (\d+)/){
		my $s = $1;
		my $t = $2;
		my $ty; my $idx;
		if($line =~ /op--(\d+)/){
		    $idx = $1;
		    $ty = "RA";
		    print "delete $ty($edge_map{$idx},$node_map{$s}, $node_map{$t});\n";
		    $ty = "RB";
		    print "delete $ty($edge_map{$idx},$node_map{$t}, $node_map{$s});\n";
		}elsif($line =~ /cp--(\d+)/){
		    $idx = $1;
		    $ty = "RB";
		    print "delete $ty($edge_map{$idx},$node_map{$s}, $node_map{$t});\n";
		    $ty = "RA";
		    print "delete $ty($edge_map{$idx},$node_map{$t}, $node_map{$s});\n";
		}else{
		    die "cannot handle this line: $line\n"
		}
		if($mode == 2 or $mode == 3){	    print "commit;\nstart;\n";}
		if($edge_count == int($ii * $edge_num / 10) and $ii <= 9){
		    print "timestamp;\n";
		    $ii++;
		}
	    }
	    $edge_count++;
	}
    }
    
}











print "start;\n";


#print "timestamp;\n";
#print "edge is $size\n";


#should build node map first before calling gen_dl;
print_node_init() if ($mode == 3 or $mode == 4);
print_node_seq();
gen_dl() if ($mode == 1);
print_edge_init() if ($mode == 3 or $mode == 4);
print_edge_seq();



#die




# insert A1(1, 2),
# insert B1(2, 3),
# insert CC(1, 1),
# insert CC(2, 2),
# insert CC(3, 3),
# insert AA1(3, 4),
# insert BB1(4, 5),
# insert AA(3, 9),
# insert BB(9, 5),
# insert CC(4, 4),
# insert CC(5, 5),
# insert AA(2, 5),
# insert BB(5, 9),
# insert AA1(9, 3),
# insert BB1(3, 2),
# insert CC(9, 9);




print "commit;\ntimestamp;\n";
close(FH)
