package Math::Normalize::Range;
use strict;
use warnings;
use 5.008_001;

our $VERSION = '0.01';

use Carp ();
use List::MoreUtils qw/minmax/;

sub new {
    my ($class, %args) = @_;

    my $target_min = $args{target_min} || 0;
    my $target_max = $args{target_max} || 1;

    _validate_min_max($target_min, $target_max);

    bless {
        target_min => $target_min,
        target_max => $target_max,
    }, $class;
}

sub normalize {
    my ($self, $num, $args) = @_;

    unless (defined $num) {
        Carp::croak("number is not defined");
    }

    my ($min, $max);
    my @nums;
    if (ref $num eq 'ARRAY' && !defined $args) {
        ($min, $max) = minmax(@{$num});
        @nums = @{$num};
    } else {
        for my $key (qw/min max/) {
            unless (exists $args->{$key}) {
                Carp::croak("missing mandatory parameter '$key'");
            }
        }

        ($min, $max) = @{$args}{'min', 'max'};
        _validate_min_max($min, $max);

        @nums = ref $num eq 'ARRAY' ? @{$num} : ($num);
        for my $n (@nums) {
            unless ($n >= $min && $n <= $max) {
                Carp::croak("Number should be min($min) < $num < max($max)");
            }
        }
    }

    my @retvals;
    my ($target_min, $target_max) = @{$self}{'target_min', 'target_max'};
    for my $n (@nums) {
        my $unit = ($n - $min) / ($max - $min);
        push @retvals, ($unit * ($target_max - $target_min) + $target_min);
    }

    if (wantarray) {
        return @retvals;
    } else {
        return $retvals[0];
    }
}

sub _validate_min_max {
    my ($min, $max) = @_;
    unless ($min < $max) {
        Carp::croak("'min'($min) greater than 'max'($max)");
    }
}

1;
__END__

=encoding utf-8

=for stopwords

=head1 NAME

Math::Normalize::Range - Normalize within specified range

=head1 SYNOPSIS

  use Math::Normalize::Range;

  my $num = Math::Normalize::Range->new(
      target_min => 1000, target_max => 10000
  );

  $num->normalize(10, {min => 5, max => 20});
  $num->normalize([2, 14, 27, 9]);

=head1 DESCRIPTION

Math::Normalize::Range normalizes number to specified range
Default range is 0.0 .. 1.0. You can normalize any range.

=head1 METHOD

=head2 Class Method

=head3 C<< Math::Normalize::Range->new(%args) >>

I<%args> is:

=over

=item target_min

Target minimum number. Default is 0.

=item target_max

Target maximum number. Default is 1.

=back

=head2 Instance Method

=head3 C<< $number->normalize($num, {min => $min, max => $max}) >>

Normalize C<$num> in range(C<$min>..C<$max>) to target range.

=head3 C<< $number->normalize(\@nums) >>

Same as above except C<$min> and C<$max> are chosen from C<@nums>.

=head1 AUTHOR

Syohei YOSHIDA E<lt>syohex@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2012- Syohei YOSHIDA

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
