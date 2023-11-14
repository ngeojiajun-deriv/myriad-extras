# Parameterized PERL test suite
 use Test::More;
 use Myriad;

 ok($ENV{MODULE_TO_LOAD}, "Required parameters are set");
 use_ok($ENV{MODULE_TO_LOAD}, "$ENV{MODULE_TO_LOAD} is loaded!");
 done_testing();
