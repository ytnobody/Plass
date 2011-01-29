package Plass;
use strict;
use warnings;
use parent qw/ Hash::AsObject /;
use Clone qw/ clone /;
use Object::Method;
our $VERSION = '0.01';
our $univ = bless {}, __PACKAGE__;

sub import {
    my $class = shift;
    my $caller = caller();
    no strict 'refs';
    no warnings 'redefine';
    *{"$caller\::plass"} = sub (%) { 
        my %args = @_;
        my $c = clone( ${__PACKAGE__."\::univ"} );
        _plass( $c, %args );
        return $c;
    };
}

sub plass {
    my ( $self, %args ) = @_;
    my $c = clone( $self );
    _plass( $c, %args );
    return $c;
}

sub _plass {
    my ( $c, %args ) = @_;
    for my $key ( keys %args ) {
        $c->$key( $args{ $key } ) unless ref $args{ $key } eq 'CODE';
        $c->method( $key => $args{ $key } ) if ref $args{ $key } eq 'CODE';
    }
}

1;
__END__

=head1 NAME

Plass - Instance based OOP

=head1 SYNOPSIS

  my $cat = plass 
      meow => sub { print shift->voice."\n" },
      look => sub { print shift->profile->name. " looking ". shift. "\n" },
      voice => 'Meow...',
      profile => { name => "Kiki", age => 4 },
      surface => [ 'Black', 'Talkable' ];
  
  $cat->meow; ### say "Meow..."
  
  $cat->look( "you" ); ### say "Kiki looking you"
  
  my $talkcat = $cat->plass( 
      voice => "I'm hungry...",
      look => sub { print shift->profile->name. " not looking ". shift. "\n" },
  );
  $talkcat->profile->name( "Jiji" );
  
  $talkcat->meow; ### say "I'm hungry..."
  
  $talkcat->look( "you" ); ### say "Jiji not looking you"

=head1 DESCRIPTION

An aim of Plass is to present environment of instance-based-OOP.

=head1 Philosophy of Plass

=head2 simplification of coding

Plass aims destroy partition among class and object. 

Specifically, class-name contained in Plass-object is nonsense.

Because Plass-object's class-name is "Plass".

To generate an instance in instance-based-OOP means make clone from an universal instance.

=head2 extendable easy

In Plass, inherits is superseded by trait.

Trait is expressed by Hash that contains some-values and/or coderef.

=head2 usability over speed

In developing Plass, please priority over usability than speed.

=head1 AUTHOR

satoshi azuma E<lt>ytnobody@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
