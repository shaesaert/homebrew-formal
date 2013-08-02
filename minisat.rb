require 'formula'

class Minisat < Formula
  homepage 'http://minisat.se'
  url 'https://github.com/niklasso/minisat/archive/releases/2.2.0.tar.gz'
  sha1 '28c14eed485f4adb8dde9e26f05476f7eedc8f77'

  def patches
    DATA
  end

  def install
    ENV['MROOT'] = Dir.pwd
    Dir.chdir 'simp' do
      system "make", "r", "libr"
      bin.install 'minisat_release' => 'minisat'
      lib.install 'lib_release.a' => 'libminisat.a'
    end
    (include/'minisat').install 'core/Solver.h', 'core/SolverTypes.h',
                                 Dir['mtl/*.h'], 'simp/SimpSolver.h',
                                 Dir['utils/*.h']
    ln_s include/'minisat', include/'minisat/core'
    ln_s include/'minisat', include/'minisat/mtl'
    ln_s include/'minisat', include/'minisat/simp'
    ln_s include/'minisat', include/'minisat/utils'
  end
end

__END__
diff --git a/utils/System.cc b/utils/System.cc
index a7cf53f..feeaf3c 100644
--- a/utils/System.cc
+++ b/utils/System.cc
@@ -78,16 +78,17 @@ double Minisat::memUsed(void) {
     struct rusage ru;
     getrusage(RUSAGE_SELF, &ru);
     return (double)ru.ru_maxrss / 1024; }
-double MiniSat::memUsedPeak(void) { return memUsed(); }
+double Minisat::memUsedPeak(void) { return memUsed(); }
 
 
 #elif defined(__APPLE__)
 #include <malloc/malloc.h>
 
-double Minisat::memUsed(void) {
+double Minisat::memUsed() {
     malloc_statistics_t t;
     malloc_zone_statistics(NULL, &t);
     return (double)t.max_size_in_use / (1024*1024); }
+double Minisat::memUsedPeak() { return memUsed(); }
 
 #else
 double Minisat::memUsed() { 