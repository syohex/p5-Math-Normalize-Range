use strict;
use warnings;
use Test::More;

use Math::Normalize::Range;

subtest 'constructor' => sub {
    my $num = Math::Normalize::Range->new(10);
    ok $num;
    isa_ok $num, 'Math::Normalize::Range';
};

subtest 'normalize(default range)' => sub {
    my $num = Math::Normalize::Range->new(5);
    my $got = $num->normalize(min => 0, max => 100);
    is $got, 0.05, 'normalize default';
};

subtest 'normalize(specified range)' => sub {
    my $num = Math::Normalize::Range->new(5, {target_min => 0, target_max=>1000});
    my $got = $num->normalize(min => 0, max => 100);
    is $got, 50, 'normalize specified range';
};

subtest 'invalid constructor' => sub {
    eval {
        Math::Normalize::Range->new;
    };
    like $@, qr/Undefined number/, 'not defined number';

    eval {
        Math::Normalize::Range->new(1, {target_min => 1, target_max => 0});
    };
    like $@, qr/greater than/, 'target_min > target_max';
};

subtest 'invalid normalize' => sub {
    my $num = Math::Normalize::Range->new(5);
    eval {
        $num->normalize(max => 10);
    };
    like $@, qr/missing mandatory parameter 'min'/, "missing 'min' parameter";

    eval {
        $num->normalize(min => 10);
    };
    like $@, qr/missing mandatory parameter 'max'/, "missing 'max' parameter";

    eval {
        $num->normalize(min => 10, max => 5);
    };
    like $@, qr/greater than/, "min > max";

    eval {
        my $num = Math::Normalize::Range->new(10);
        $num->normalize(min => 20, max => 100);
    };
    like $@, qr/Number should be min/, "num below range min";

    eval {
        my $num = Math::Normalize::Range->new(200);
        $num->normalize(min => 20, max => 100);
    };
    like $@, qr/Number should be min/, "num over range max";
};

done_testing;