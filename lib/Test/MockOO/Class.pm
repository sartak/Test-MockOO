package Test::MockOO::Class;
use Moose;

extends 'Moose::Meta::Class';

sub mock {
    my $self = shift;
    my $name = shift;
    my $code = shift;

    confess "Too many arguments for mock" if @_;

    $self->add_method($name => $code);

    return $self;
}

sub set_true {
    my $self = shift;
    my $name = shift;

    confess "set_true does not work on multiple method names" if @_;

    $self->mock($name => sub { 1 });
}

sub set_false {
    my $self = shift;
    my $name = shift;

    confess "set_false does not work on multiple method names" if @_;

    $self->mock($name => sub { return });
}

sub set_always {
    my $self  = shift;
    my $name  = shift;
    my $value = shift;

    confess "Too many values for set_always, which takes a scalar" if @_;

    $self->mock($name => sub { $value });
}

sub set_series {
    my $self   = shift;
    my $name   = shift;
    my @values = @_;

    $self->mock($name => sub {
        return shift @values if @values;
        return;
    });
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

