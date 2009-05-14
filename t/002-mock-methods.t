use strict;
use warnings;
use Test::More tests => 3;
use Test::MockOO;

my ($class, $object) = Test::MockOO->create;
$class->set_true('true')
      ->set_false('false');

can_ok($object, qw(true false));
ok($object->true, 'true');
ok(!$object->false, 'false');

