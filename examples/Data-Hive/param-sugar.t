#!perl

use strict;
use warnings;

use Test::More 'no_plan';

use ok 'Data::Hive';
use ok 'Data::Hive::Store::Param';

do {
    package Mock;
    use Test::MockOO::Declare;
    use MooseX::ClassAttribute;
    use MooseX::AttributeHelpers;

    class_has info => (
        metaclass => 'Collection::Hash',
        reader    => '_get_info',
        isa       => 'HashRef',
        default   => sub {
            return {
                foo => 1,
                'bar/baz' => 2,
            };
        },
        provides  => {
            accessor => 'info',
            exists   => 'info_exists',
            delete   => 'info_delete',
        },
    );
};

my $obj = Test::MockOO->create('Mock');

my $hive = Data::Hive->NEW({
  store_class => 'Param',
  store_args  => [ $obj, {
    method => 'info',
    separator => '/',
    exists => 'info_exists',
    delete => 'info_delete',
  } ],
});

is $hive->bar->baz, 2, 'GET';
$hive->foo->SET(3);
is_deeply $obj->_get_info, { foo => 3, 'bar/baz' => 2 }, 'SET';

is $hive->bar->baz->NAME, 'bar/baz', 'NAME';

ok ! $hive->not->EXISTS, "non-existent key doesn't EXISTS";
ok   $hive->foo->EXISTS, "existing key does EXISTS";

$hive->ITEM("and/or")->SET(17);

is_deeply $obj->_get_info, { foo => 3, 'bar/baz' => 2, 'and%2for' => 17 },
  'SET (with escape)';
is $hive->ITEM("and/or"), 17, 'GET (with escape)';

is $hive->bar->baz->DELETE, 2, "delete returns old value";
is_deeply $obj->_get_info, { foo => 3, 'and%2for' => 17 }, "delete removed item";
