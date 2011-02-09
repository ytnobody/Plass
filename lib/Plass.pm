package Plass;
use strict;
use warnings;
use parent qw/ Hash::AsObject /;
use Clone qw/ clone /;
use Object::Method;
our $VERSION = '0.02';
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
    *{"$caller\::mix"} = sub (@) {
        my $c = clone( ${__PACKAGE__."\::univ"} );
        my %mixed = _mix( @_ );
        _plass( $c, %mixed );
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

sub mix {
    my $self = shift;
    my %mixed = _mix( @_ );
    $self->plass( _mix( @_ ) );
}

sub _mix {
    my %mixed = ();
    for my $ins ( @_ ) {
        %mixed = ( %mixed, $ins->feature );
    }
    return %mixed;
}

sub feature {
    no strict 'refs';
    my $self = shift;
    my $class = ref $self;
    my %f = %{ "$class\::" };
    my %features;
    my $val;
    for my $key ( keys %f ) {
        next if $key =~ /^(AUTOLOAD|DESTROY|ISA|isa|feature|plass|method|mix|::ISA::CACHE::)$/;
        $val = $f{ $key };
        $features{ $key } = defined $self->{ $key } ? $self->{ $key } : *{ $val }{ CODE };
    }
    return %features;
}

1;
__END__

=head1 NAME

Plass - Instance based OOP

=head1 INSTALL

  $ git clone git://github.com/ytnobody/Plass.git
  $ cpanm ./Plass

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
  
  my $bird = plass
      fly => sub { print $_[0]->name. ' flew to '. $_[1]. "\n" };
  
  $talkcat = $talkcat->mix( $bird );
  
  $talkcat->fly( 'mountain' ); ### "Jiji flew to mountain.";

=head1 DESCRIPTION

An aim of Plass is to present environment of instance-based-OOP.

=head1 COMMANDS

Plass imports follow commands.

=head2 plass

 my $instance = plass key => $anyval, key2 => $anyval2 ... ;

Cloning universal instance of Plass. And, Specified parameters to a cloned instance.

=head2 mix

 my $instance = mix $plass_instance_1, $plass_instance_2, $plass_instance_3 ... ;

Mixing Plass based instances. But, non-recursive slot inheritance.

=head1 METHOD

Instance of Plass can call follow method.

=head2 plass

 my $child = $parent->plass( key => $anyval, key2 => $anyval2 ... );

Cloning parent instance of Plass. And, Specified parameters ( calls "trait" ) to a child instance.

=head2 mix

 my $child = $parent->mix( $plass_instance1, $plass_instance2 ... );

Cloning parent instance of Plass. And, Mixed-parameters of specified instances to a child instance.

=head2 feature

 my %trait = $instance->feature;

Returns trait of instance. Following codes are equal among they.

 my $child = $parent->plass;

 my %trait = $parent->feature;
 my $child = plass %trait;

=head1 PHILOSOPHY

=head2 SIMPLIFICATION OF CODING

Plass aims destroy partition among class and object. 

Specifically, class-name contained in Plass-object is nonsense.

Because Plass-object's class-name is "Plass".

To generate an instance in instance-based-OOP means make clone from an universal instance.

=head2 ABLE TO EXTEND EASY

In Plass, inherits is superseded by trait.

Trait is expressed by Hash that contains some-values and/or coderef.

=head2 USABILITY OVER SPEED

In developing Plass, please priority over usability than speed.

=head1 TODO

- performance benchmark.

- more friendly trait.

=head1 AUTHOR

satoshi azuma E<lt>ytnobody@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
