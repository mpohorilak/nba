use Array::Unique;
use Time::Piece;
use Data::Dumper qw(Dumper);
use DateTime;
use POSIX;

use Sport::Analytics::SimpleRanking;
my $stats = Sport::Analytics::SimpleRanking->new();




use constant
{
away_team_game_number => 0,	
home_team_game_number => 1,	
home_team_home_game_number => 2,	
away_team_away_game_number => 3,	
ID => 4,	
day_season => 5,	
key => 6,
time => 7,
date=> 8,
month => 9,
day => 10,	
year => 11,
cont_day => 12,
away_team =>13,
away_team_number=>14,
home_team=>15,
home_team_number =>16,
away_team_pts=>17,
home_team_pts=>18
};

$filename='games_simple_rankings.txt';

print $filename;
print "\n";
 
open (myfile1, '>>game_results.txt');
open (myfile2, '>>game_results_1.txt');


open (MYFILE, $filename);
my $day_season=1;


while (<MYFILE>)
{
   $linecount++;
   chomp;
   
   if($linecount>1)
   {
	   
	#split line 
    my @fields = split /\,/ , $_; 
 
	#create game string 
    $key=$fields[key];
    $awayteam=$fields[away_team];
		
	$awaypoints=$fields[17];
	$awaypoints=~ s/^ //;
		
	$hometeam=$fields[home_team];
    
	$homepoints=$fields[18];
	$homepoints=~  s/^ //;
	
	$game = $awayteam.",".$awaypoints.",".$hometeam.",".$homepoints;
	
	#must get 2 games for each team to run 
	if($day_season==$fields[day_season] && $day_season<8)
	{
		push @games2, $game;	
	}
	#second games array after initial load
	elsif($day_season==$fields[day_season])
	{
		push @games3, $game;
	}
	
	else
	{
	 if($day_season==7)
	 {			
		$len_games=scalar @games2;
	    print myfile1 $day_season;
	    print myfile1 "\n";
	  
		for ($z=0; $z<($len_games); $z++)
	    {
			print myfile1 $games2[$z];
			print myfile1 "\n";
						
	    }		
		print myfile1 "\n";
	 
		$stats->load_data( \@games2 );
		my  $srs = $stats->simpleranking( verbose => 1 );
		my $mov = $stats->mov;
		my $sos = $stats->sos;
		for ( keys %$srs ) 
		{
			#get_teamcode($_);
			#save
			#addup
			#$srs[$fields2[10]][$gamecount-1]
			#p4in6
			#$save_[dayseason][get_teamcode($_)]=$srs->{$_};
			$save_srs[get_teamcode($_)][$day_season]= $srs->{$_};
			#$save[dayseason][$_]=$mov->{$_};
			#$save[dayseason][$_]=$sos->{$_};
			print myfile1 $_,",",get_teamcode($_),",",$srs->{$_},",",$mov->{$_},",",$sos->{$_},"\n";
		    print myfile1 $save[dayseason][get_teamcode($_)]; 
		    #print myfile1 "\n";
		}
		print myfile1 "\n";	 
		#print myfile1 "test:",$save[7][1];
	 }
		
	 elsif($day_season>7)
	 {
	    $len_games2=scalar @games3;
		
		print myfile1 $day_season;
	    print myfile1 "\n";
	       
		for ($z=0; $z<($len_games2); $z++)
	    {			
			print myfile1 $games3[$z];
			print myfile1 "\n";
						
	    }		
			print myfile1 "\n";
			
	    $stats->add_data(\@games3);
		
		my $srs = $stats->simpleranking( verbose => 1 );
		my $mov = $stats->mov;
		my $sos = $stats->sos;
		for ( keys %$srs ) 
		{
			#$save[dayseason][get_teamcode($_)]=$srs->{$_};
			$save_srs[get_teamcode($_)][$day_season]= $srs->{$_};
			#$save[dayseason][$_]=$mov->{$_};
			#$save[dayseason][$_]=$sos->{$_};
			print myfile1 $_,",",$srs->{$_},",",$mov->{$_},",",$sos->{$_},"\n";
		}
		
		print myfile1 "\n";
					
		@games3=();
		 
	 }
	
		$day_season+=1;
	 }#end else 
	 
   } #end if linecount>1  
   #print 
} #end while loop 


open (MYFILE, $filename);
while (<MYFILE>)
{
   $linecount++;
   chomp;
   my @fields = split /\,/ , $_; 
   
   print myfile2 $_;
 
#away_team_game_number => 0,	
#home_team_game_number => 1,	
#home_team_home_game_number => 2,	
#away_team_away_game_number => 3,	
#ID => 4,	
#day_season => 5,	

#print 
if($linecount>1)
{
	
for ($y=1; $y<100; $y++)
{		
for ($z=1; $z<31; $z++)
{
	
if($fields[5]==$y && get_teamcode($fields[13])==$z)
{
	print myfile2 "test";#$fields[5];
	print myfile2 " ";
	print myfile2 $fields[5];
	print myfile2 " ";
	print myfile2 get_teamcode($fields[13]);
	print myfile2 " ";	
	print myfile2 $save_srs[get_teamcode($fields[13])][$fields[5]];
	print myfile2 "\n";
}
	
}
}
}

}

sub get_teamcode
{
	 
    if  ($_[0]=~/TOR/){$t=1;}
    elsif  ($_[0]=~/BRK/){$t=2;}
    elsif  ($_[0]=~/BOS/){$t=3;}
    elsif  ($_[0]=~/NYK/){$t=4;}
    elsif  ($_[0]=~/PHI/){$t=5;}
    elsif  ($_[0]=~/CHI/){$t=6;}
    elsif  ($_[0]=~/CLE/){$t=7;}
    elsif  ($_[0]=~/MIL/){$t=8;}
    elsif  ($_[0]=~/IND/){$t=9;}
    elsif  ($_[0]=~/DET/){$t=10;}
	elsif  ($_[0]=~/ATL/){$t=11;}
	elsif  ($_[0]=~/WAS/){$t=12;}
    elsif  ($_[0]=~/MIA/){$t=13;}
    elsif  ($_[0]=~/ORL/){$t=14;}
    elsif  ($_[0]=~/CHO/){$t=15;}
    elsif  ($_[0]=~/POR/){$t=16;}
    elsif  ($_[0]=~/OKC/){$t=17;}
    elsif  ($_[0]=~/DEN/){$t=18;}
    elsif  ($_[0]=~/UTA/){$t=19;}
    elsif  ($_[0]=~/MIN/){$t=20;}
    elsif  ($_[0]=~/GSW/){$t=21;}
    elsif  ($_[0]=~/LAC/){$t=22;}
    elsif  ($_[0]=~/PHO/){$t=23;}
    elsif  ($_[0]=~/SAC/){$t=24;}
    elsif  ($_[0]=~/LAL/){$t=25;}
    elsif  ($_[0]=~/MEM/){$t=26;}
    elsif  ($_[0]=~/HOU/){$t=27;}
    elsif  ($_[0]=~/DAL/){$t=28;}
    elsif  ($_[0]=~/SAS/){$t=29;}
    elsif  ($_[0]=~/NOP/){$t=30;}

	return $t;

}
	