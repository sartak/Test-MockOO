use strict;
use warnings;
use Test::More tests => 10;
use Test::MockObject;
use Test::Exception;

use NetHack::Menu;

do {
    package Mock::VT102;
    use Test::MockOO::Declare;
    use MooseX::AttributeHelpers;
    extends 'Term::VT102'; # this should really fake an isa VT102

    has rows_returned => (
        metaclass => 'Collection::Array',
        isa     => 'ArrayRef',
        default => sub { [] },
        provides  => {
            push     => 'add_return_rows',
            shift    => '_return_row',
            elements => 'rows_returned',
        },
    );

    has rows_checked => (
        metaclass => 'Collection::Array',
        isa       => 'ArrayRef',
        default   => sub { [] },
        provides  => {
            push     => '_add_row_checked',
            clear    => '_clear_rows_checked',
            elements => 'rows_checked',
        },
    );

    always rows => 24;

    override row_plaintext => sub {
        my $self = shift;
        my $row  = shift;

        $self->_add_row_checked($row);

        return '' if $row == 0;
        $self->_return_row;
    };

    sub checked_ok {
        my $self = shift;
        my $rows = shift;
        my $name = shift;
        local $Test::Builder::Level = $Test::Builder::Level + 1;

        Test::More::is_deeply([$self->rows_checked], $rows, $name);
        $self->_clear_rows_checked;
    }
};

my $vt = Test::MockOO->create('Mock::VT102');
my $menu = NetHack::Menu->new(vt => $vt);

is($vt->rows_checked, 0, "No rows checked yet.");

$vt->add_return_rows(
    split /\n/, (<< '    MENU') x 3
                     Weapons
                     a - a blessed +1 quarterstaff (weapon in hands)
                     Armor
                     X - an uncursed +0 cloak of magic resistance (being worn)
                     (end) 
    MENU
);

ok($menu->has_menu, "we has a menu");
$vt->checked_ok([0, 1, 2, 3, 4, 5], "rows 0-5 checked for finding the end");

ok($menu->at_end, "it knows we're at the end here");
$vt->checked_ok([0, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4], "rows 0-5 checked for finding the end, 0-4 checked for items");

dies_ok { $menu->next } "next dies if menu->at_end";
$vt->checked_ok([], "no rows checked");

my @items_selectable;
my @selectors;
$menu->select(sub {
    push @items_selectable, $_;
    push @selectors, $_[0];
    /quarterstaff/;
});

is_deeply(\@items_selectable, ["a blessed +1 quarterstaff (weapon in hands)", "an uncursed +0 cloak of magic resistance (being worn)"], "the quarterstaff and [oMR showed up, but not the Weapons and Armor headers");

is_deeply(\@selectors, ['a', 'X'], "our two selectors were passed in as arguments");

is($menu->commit, '^a ', "first page, selected the quarterstaff, ended the menu");
