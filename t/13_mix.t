use Test::More;
use Plass;

my $human = plass hello => sub { "Hi. My name is ".shift->name."." };

my $baker = $human->plass( bake => sub { bless {}, 'Bread' } );
my $programmer = $human->plass( code => sub { bless { work => $_[1] }, 'Code' } );
my $hacker = $programmer->plass( code => sub { bless { work => $_[1] }, 'SuperCode' } );
my $singer = $human->plass( sing => sub { shift->name. ' sing a song.' } );
my $superguy = mix $human, $baker, $hacker;

my $jelemy = $superguy->plass( name => 'jelemy' );

isa_ok $jelemy, 'Plass';
is $jelemy->hello, 'Hi. My name is jelemy.';
isa_ok $jelemy->bake, 'Bread';
isa_ok $jelemy->code, 'SuperCode';
is $jelemy->sing, undef;

$jelemy = $jelemy->mix( $singer );

isa_ok $jelemy, 'Plass';
is $jelemy->hello, 'Hi. My name is jelemy.';
isa_ok $jelemy->bake, 'Bread';
isa_ok $jelemy->code, 'SuperCode';
is $jelemy->sing, 'jelemy sing a song.';

my $cat = plass play => sub { '"Purr..." '.shift->name.' got playful.' };
my $mimi = $cat->plass( name => 'mimi', gender => 'female' );

isa_ok $mimi, 'Plass';
is $mimi->play, '"Purr..." mimi got playful.';

$jelemy = $jelemy->mix( $mimi );

isa_ok $jelemy, 'Plass';
is $jelemy->hello, 'Hi. My name is mimi.';
isa_ok $jelemy->bake, 'Bread';
isa_ok $jelemy->code, 'SuperCode';
is $jelemy->sing, 'mimi sing a song.';
is $jelemy->play, '"Purr..." mimi got playful.';

done_testing();
