use ExtUtils::MakeMaker;

#use Cwd qw(abs_path); 
use Carp;

my $cmd_out = "";
my $pkgcmd = 'pkg-config ';
my $allopt = $pkgcmd.' --list-all';
my $vfscmd = 'gnome-vfs-config ';

my ($LIBS, $INCS, $DEFINE);
if (`pkg-config --modversion gnome-vfs-2.0`){
     $DEFINE = '-DGNOMEVFS2';
  ($LIBS, $INCS) = gnome_vfs_2x();
} elsif (`which $pkgcmd` && 
     grep(/gnome\-vfs\-module\-2/, split(/\n/, run_cmd($allopt))) ){
     $DEFINE = '-DGNOMEVFS2';
  ($LIBS, $INCS) = gnome_vfs_2();
} elsif (`which $vfscmd`){
  ($LIBS, $INCS) = gnome_vfs_1();
} else {
  croak "can't figure out how to locate vfs library\n";
}


WriteMakefile(
    clean => { 'FILES'	=> '*~ *.inl core test*.txt *.tar.gz _Inline ' },
    dist => { 'TARFLAGS'	=> 'cvf',
              'COMPRESS'        => 'gzip -9f',
    		'SUFFIX'	=> '.tgz'},
    'NAME'	=> 'VFS::Gnome',
    'VERSION_FROM' => 'Gnome.pm',
    'DEFINE'	=> $DEFINE,   
    'LIBS'	=> $LIBS,   
    'INC'	=> $INCS,
);



#=============================================================================
sub gnome_vfs_1 {
  my ($LIBS, $INCS);
  my $incopts =  $vfscmd.'--cflags';
  my $libopts =  $vfscmd.'--libs';

  croak "Cannot determine INC path for gnome-vfs: $incopts\n $cmd_out\n"
      unless $INCS =  run_cmd($incopts);
  croak "Cannot determine LIB path for gnome-vfs: $libopts\n $cmd_out\n"
      unless $LIBS = run_cmd($libopts);
  return ($LIBS, $INCS);
}


sub gnome_vfs_2 {
  my ($LIBS, $INCS);
  my $incopts =  $pkgcmd.'--cflags gnome-vfs-2.0';
  my $libopts =  $pkgcmd.'--libs gnome-vfs-2.0';

  croak "Cannot determine your gnome-vfs package from: $allopt\n $cmd_out"
      unless  grep(/gnome\-vfs\-module\-2/, split(/\n/, run_cmd($allopt)));
  croak "Cannot determine INC path for gnome-vfs: $incopts\n $cmd_out\n"
      unless $INCS =  run_cmd($incopts);
  croak "Cannot determine LIB path for gnome-vfs: $libopts\n $cmd_out\n"
      unless $LIBS = run_cmd($libopts);
  return ($LIBS, $INCS);
}


sub gnome_vfs_2x {
  my ($LIBS, $INCS);
  my $incopts =  $pkgcmd.'--cflags gnome-vfs-2.0';
  my $libopts =  $pkgcmd.'--libs gnome-vfs-2.0';
  #warn "incopts = $incopts\n";
  #warn "libopts = $libopts\n";
#  croak "Cannot determine your gnome-vfs package from: $allopt\n $cmd_out"
#      unless  grep(/gnome\-vfs\-module\-2/, split(/\n/, run_cmd($allopt)));
  croak "Cannot determine INC path for gnome-vfs: $incopts\n $cmd_out\n"
      unless $INCS =  run_cmd($incopts);
  croak "Cannot determine LIB path for gnome-vfs: $libopts\n $cmd_out\n"
      unless $LIBS = run_cmd($libopts);
  return ($LIBS, $INCS);
}


sub run_cmd {

  my $cmd = shift;
  $cmd .= ' 2>&1 ';
  return $cmd_out =  `$cmd`;

}
