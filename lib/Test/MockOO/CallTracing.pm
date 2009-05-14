package Test::MockOO::CallTracing;
use Moose::Role;
use Scalar::Util 'refaddr';

use Test::MockOO::Calls;

my %calls;

sub calls_of {
    my $self     = shift;
    my $instance = shift;

    return $calls{refaddr $instance} ||= Test::MockOO::Calls->new(instance => $instance);
}

no Moose::Role;

1;
