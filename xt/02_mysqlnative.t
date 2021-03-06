use v6;
use Test;
use NativeCall::TypeDiag;
use DBDish::mysql::Native;

my @headers = <mysql/mysql.h>;
my @libs = <-lmysqlclient>;
my @fun;
my %typ;

#Turn this False if something fail
$NativeCall::TypeDiag::silent = True;

for DBDish::mysql::Native::EXPORT::DEFAULT::.keys -> $export {
  if ::($export).REPR eq 'CStruct' {
    %typ{$export} = ::($export);
  }
  if ::($export).does(Callable) and ::($export).^roles.perl ~~ /NativeCall/ {
     @fun.push(::($export));
  }
}

plan 2;

ok diag-cstructs(:cheaders(@headers), :types(%typ), :clibs(@libs)), "CStruct definition are correct";
ok diag-functions(:functions(@fun)), "Functions signature are good";
