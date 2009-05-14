package Test::MockOO::Calls;
use Moose;
use MooseX::AttributeHelpers;

use Test::MockOO::Call;

has calls => (
    metaclass => 'Collection::Array',
    isa       => 'ArrayRef[Test::MockOO::Call]',
    default   => sub { [] },
    provides  => {
        push     => '_add_call',
        clear    => 'clear',
        elements => 'calls',
    },
);

sub called {
    my $self = shift;
    my $name = shift;

    for my $call ($self->calls) {
        return $call if $call->name eq $name;
    }

    return;
}

sub called_ok {
    my $self = shift;
    my $name = shift;
    my $desc = shift || "called the $name method";

    my $call = $self->called($name);
    Test::More::ok($call, $desc);
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
