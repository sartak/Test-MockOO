package Test::MockOO::Class;
use Moose;

extends 'Moose::Meta::Class';

sub set_true {
    my $self   = shift;
    my $method = shift;

    confess "set_true does not work on multiple method names" if @_;

    $self->add_method($method => sub { 1 });

    return $self;
}

sub set_false {
    my $self   = shift;
    my $method = shift;

    confess "set_false does not work on multiple method names" if @_;

    $self->add_method($method => sub { return });

    return $self;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

