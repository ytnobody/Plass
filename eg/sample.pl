use warnings;
use strict;
use FindBin;
use lib ( "$FindBin::Bin/../lib" );
use Plass;

  my $cat = plass 
      meow => sub { print shift->voice."\n" },
      look => sub { print shift->profile->name. " looking ". shift. "\n" },
      voice => 'Meow...',
      profile => { name => "Kiki", age => 4 },
      surface => [ 'Black', 'Talkable' ];
  
  $cat->meow; ### say "Meow..."
  
  $cat->look( "you" ); ### say "Kiki looking you"

  my %trait = (
      voice => "I'm hungry...",
      look => sub { print shift->profile->name. " not looking ". shift. "\n" },
  );
  
  my $talkcat = $cat->plass( %trait );
  $talkcat->profile->name( "Jiji" );

  $talkcat->meow; ### say "I'm hungry..."
  
  $talkcat->look( "you" ); ### say "Jiji not looking you"

