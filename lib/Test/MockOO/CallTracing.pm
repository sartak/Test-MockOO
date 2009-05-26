package Test::MockOO::CallTracing;
use Moose::Role;
use Scalar::Util 'refaddr';

use Test::MockOO::Calls;
use Test::MockOO::Call;

my %calls;

sub calls_for {
    my $self     = shift;
    my $instance = shift;

    return $calls{refaddr $instance} ||= Test::MockOO::Calls->new(instance => $instance);
}

around mock => sub {
    my $next = shift;
    my $self = shift;
    my $name = shift;
    my $code = shift;

    my $traced = sub {
        my $call = Test::MockOO::Call->new(
            name      => $name,
            arguments => [@_],
        );
        $self->calls_for($_[0])->_add_call($call);

        goto $code;
    };

    return $next->($self, $name, $traced);
};

no Moose::Role;

1;
