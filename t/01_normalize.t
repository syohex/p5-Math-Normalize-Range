use strict;
use warnings;
use Test::More;

use Math::Normalize::Range;

subtest 'constructor' => sub {
    my $num = Math::Normalize::Range->new();
    ok $num;
    isa_ok $num, 'Math::Normalize::Range';
};

subtest 'normalize(default range)' => sub {
    my $num = Math::Normalize::Range->new();
    my $got = $num->normalize(5, {min => 0, max => 100});
    is $got, 0.05, 'normalize default';
};

subtest 'normalize(specified range)' => sub {
    my $num = Math::Normalize::Range->new(target_min => 0, target_max=>1000);
    my $got = $num->normalize(5, {min => 0, max => 100});
    is $got, 50, 'normalize specified range';
};

subtest 'normalize(ArrayRef)' => sub {
    my $num = Math::Normalize::Range->new(target_min => 0, target_max=>1000);
    my @gots = $num->normalize([0, 25, 50]);
    is $gots[0], 0, 'minimum number';
    is $gots[1], 500, 'middle number';
    is $gots[2], 1000, 'maximum number';
};

subtest 'invalid constructor' => sub {
    eval {
        Math::Normalize::Range->new(target_min => 1, target_max => 0);
    };
    like $@, qr/greater than/, 'target_min > target_max';
};

subtest 'invalid normalize' => sub {
    my $num = Math::Normalize::Range->new();
    eval {
        $num->normalize(5, {max => 10});
    };
    like $@, qr/missing mandatory parameter 'min'/, "missing 'min' parameter";

    eval {
        $num->normalize(5, {min => 10});
    };
    like $@, qr/missing mandatory parameter 'max'/, "missing 'max' parameter";

    eval {
        $num->normalize(5, {min => 10, max => 5});
    };
    like $@, qr/greater than/, "min > max";

    eval {
        my $num = Math::Normalize::Range->new();
        $num->normalize(10, {min => 20, max => 100});
    };
    like $@, qr/Number should be min/, "num below range min";

    eval {
        my $num = Math::Normalize::Range->new();
        $num->normalize(200, {min => 20, max => 100});
    };
    like $@, qr/Number should be min/, "num over range max";
};

done_testing;
