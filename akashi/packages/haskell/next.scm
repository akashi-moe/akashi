;;; GNU Guix --- Functional package management for GNU
;;;
;;; Copyright © 2022 purefunctor <functor@akashi.moe>
;;;
;;; This file is not part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (akashi packages haskell next)
  #:use-module (gnu packages)
  #:use-module (gnu packages haskell)
  #:use-module (guix build-system haskell)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module ((guix licenses)
                #:prefix license:))

;;; Section --- Shake

(define-public ghc-next-splitmix
  (package
    (name "ghc-next-splitmix")
    (version "0.1.0.4")
    (source (origin
              (method url-fetch)
              (uri (hackage-uri "splitmix" version))
              (sha256
               (base32
                "1apck3nzzl58r0b9al7cwaqwjhhkl8q4bfrx14br2yjf741581kd"))))
    (build-system haskell-build-system)
    (arguments
     `(#:haskell ,ghc-9.0
       #:tests? #f
       #:cabal-revision ("1"
                         "1iqlg2d4mybqwzwp67c5a1yxzd47cbp4f7mrpa6d0ckypis2akl0")))
    (home-page "http://hackage.haskell.org/package/splitmix")
    (synopsis "Fast Splittable PRNG")
    (description
     "Pure Haskell implementation of SplitMix described in .  Guy L. Steele, Jr., Doug
Lea, and Christine H. Flood.  2014.  Fast splittable pseudorandom number
generators.  In Proceedings of the 2014 ACM International Conference on Object
Oriented Programming Systems Languages & Applications (OOPSLA 14).  ACM, New
York, NY, USA, 453-472.  DOI: <https://doi.org/10.1145/2660193.2660195> .  The
paper describes a new algorithm /SplitMix/ for /splittable/ pseudorandom number
generator that is quite fast: 9 64 bit arithmetic/logical operations per 64 bits
generated. . /SplitMix/ is tested with two standard statistical test suites
(DieHarder and TestU01, this implementation only using the former) and it
appears to be adequate for \"everyday\" use, such as Monte Carlo algorithms and
randomized data structures where speed is important. .  In particular, it
__should not be used for cryptographic or security applications__, because
generated sequences of pseudorandom values are too predictable (the mixing
functions are easily inverted, and two successive outputs suffice to reconstruct
the internal state).")
    (license license:bsd-3)))

(define-public ghc-next-random
  (package
    (name "ghc-next-random")
    (version "1.2.1.1")
    (source (origin
              (method url-fetch)
              (uri (hackage-uri "random" version))
              (sha256
               (base32
                "0xlv1k4sj87akwvj54kq4nrfkzi6qcz1941bf78pnkbaxpvp44iy"))))
    (build-system haskell-build-system)
    (inputs (list ghc-next-splitmix))
    (arguments
     `(#:haskell ,ghc-9.0
       #:tests? #f))
    (home-page "http://hackage.haskell.org/package/random")
    (synopsis "Pseudo-random number generation")
    (description
     "This package provides basic pseudo-random number generation, including the
ability to split random number generators. . == \"System.Random\": pure
pseudo-random number interface .  In pure code, use System.Random.uniform and
System.Random.uniformR from \"System.Random\" to generate pseudo-random numbers
with a pure pseudo-random number generator like System.Random.StdGen'. .  As an
example, here is how you can simulate rolls of a six-sided die using
System.Random.uniformR': . >>> let roll = uniformR (1, 6) :: RandomGen g => g ->
(Word, g) >>> let rolls = unfoldr (Just .  roll) :: RandomGen g => g -> [Word]
>>> let pureGen = mkStdGen 42 >>> take 10 (rolls pureGen) :: [Word]
[1,1,3,2,4,5,3,4,6,2] .  See \"System.Random\" for more details. . ==
\"System.Random.Stateful\": monadic pseudo-random number interface .  In monadic
code, use System.Random.Stateful.uniformM and System.Random.Stateful.uniformRM
from \"System.Random.Stateful\" to generate pseudo-random numbers with a monadic
pseudo-random number generator, or using a monadic adapter. .  As an example,
here is how you can simulate rolls of a six-sided die using
System.Random.Stateful.uniformRM': . >>> let rollM = uniformRM (1, 6) ::
StatefulGen g m => g -> m Word >>> let pureGen = mkStdGen 42 >>> runStateGen_
pureGen (replicateM 10 .  rollM) :: [Word] [1,1,3,2,4,5,3,4,6,2] .  The monadic
adapter System.Random.Stateful.runStateGen_ is used here to lift the pure
pseudo-random number generator @@pureGen@@ into the
System.Random.Stateful.StatefulGen context. .  The monadic interface can also be
used with existing monadic pseudo-random number generators.  In this example, we
use the one provided in the <https://hackage.haskell.org/package/mwc-random
mwc-random> package: . >>> import System.Random.MWC as MWC >>> let rollM =
uniformRM (1, 6) :: StatefulGen g m => g -> m Word >>> monadicGen <- MWC.create
>>> replicateM 10 (rollM monadicGen) :: IO [Word] [2,3,6,6,4,4,3,1,5,4] .  See
\"System.Random.Stateful\" for more details.")
    (license license:bsd-3)))

(define-public ghc-next-quickcheck
  (package
    (name "ghc-next-quickcheck")
    (version "2.14.2")
    (source (origin
              (method url-fetch)
              (uri (hackage-uri "QuickCheck" version))
              (sha256
               (base32
                "1wrnrm9sq4s0bly0q58y80g4153q45iglqa34xsi2q3bd62nqyyq"))))
    (build-system haskell-build-system)
    (inputs (list ghc-next-random ghc-next-splitmix))
    (arguments
     `(#:haskell ,ghc-9.0
       #:tests? #f))
    (home-page "https://github.com/nick8325/quickcheck")
    (synopsis "Automatic testing of Haskell programs")
    (description
     "QuickCheck is a library for random testing of program properties.  The
programmer provides a specification of the program, in the form of properties
which functions should satisfy, and QuickCheck then tests that the properties
hold in a large number of randomly generated cases.  Specifications are
expressed in Haskell, using combinators provided by QuickCheck.  QuickCheck
provides combinators to define properties, observe the distribution of test
data, and define test data generators. .  Most of QuickCheck's functionality is
exported by the main \"Test.QuickCheck\" module.  The main exception is the
monadic property testing library in \"Test.QuickCheck.Monadic\". .  If you are new
to QuickCheck, you can try looking at the following resources: . * The
<http://www.cse.chalmers.se/~rjmh/QuickCheck/manual.html official QuickCheck
manual>.  It's a bit out-of-date in some details and doesn't cover newer
QuickCheck features, but is still full of good advice. *
<https://begriffs.com/posts/2017-01-14-design-use-quickcheck.html>, a detailed
tutorial written by a user of QuickCheck. .  The
<https://hackage.haskell.org/package/quickcheck-instances quickcheck-instances>
companion package provides instances for types in Haskell Platform packages at
the cost of additional dependencies.")
    (license license:bsd-3)))

(define-public ghc-next-js-dgtable
  (package
    (name "ghc-next-js-dgtable")
    (version "0.5.2")
    (source (origin
              (method url-fetch)
              (uri (hackage-uri "js-dgtable" version))
              (sha256
               (base32
                "1b10kx703kbkb5q1ggdpqcrxqjb33kh24khk21rb30w0xrdxd3g2"))))
    (build-system haskell-build-system)
    (arguments
     `(#:haskell ,ghc-9.0
       #:tests? #f))
    (home-page "https://github.com/ndmitchell/js-dgtable#readme")
    (synopsis "Obtain minified jquery.dgtable code")
    (description
     "This package bundles the minified <https://github.com/danielgindi/jquery.dgtable
jquery.dgtable> code into a Haskell package, so it can be depended upon by Cabal
packages.  The first three components of the version number match the upstream
jquery.dgtable version.  The package is designed to meet the redistribution
requirements of downstream users (e.g. Debian).")
    (license license:expat)))

(define-public ghc-next-heaps
  (package
    (name "ghc-next-heaps")
    (version "0.4")
    (source (origin
              (method url-fetch)
              (uri (hackage-uri "heaps" version))
              (sha256
               (base32
                "1zbw0qrlnhb42v04phzwmizbpwg21wnpl7p4fbr9xsasp7w9scl9"))))
    (build-system haskell-build-system)
    (arguments
     `(#:haskell ,ghc-9.0
       #:tests? #f))
    (home-page "http://github.com/ekmett/heaps/")
    (synopsis "Asymptotically optimal Brodal/Okasaki heaps.")
    (description
     "Asymptotically optimal Brodal\\/Okasaki bootstrapped skew-binomial heaps from the
paper <http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.48.973 \"Optimal
Purely Functional Priority Queues\">, extended with a Foldable interface.")
    (license license:bsd-3)))

(define-public ghc-next-clock
  (package
    (name "ghc-next-clock")
    (version "0.8.3")
    (source (origin
              (method url-fetch)
              (uri (hackage-uri "clock" version))
              (sha256
               (base32
                "1l850pf1dxjf3i15wc47d64gzkpzgvw0bq13fd8zvklq9kdyap44"))))
    (build-system haskell-build-system)
    (arguments
     `(#:haskell ,ghc-9.0
       #:tests? #f))
    (home-page "https://github.com/corsis/clock")
    (synopsis "High-resolution clock functions: monotonic, realtime, cputime.")
    (description
     "This package provides a package for convenient access to high-resolution clock
and timer functions of different operating systems via a unified API. .  POSIX
code and surface API was developed by Cetin Sert in 2009. .  Windows code was
contributed by Eugene Kirpichov in 2010. .  FreeBSD code was contributed by Finn
Espen Gundersen on 2013-10-14. .  OS X code was contributed by Gerolf Seitz on
2013-10-15. .  Derived @@Generic@@, @@Typeable@@ and other instances for
@@Clock@@ and @@TimeSpec@@ was contributed by Mathieu Boespflug on 2014-09-17. .
 Corrected dependency listing for @@GHC < 7.6@@ was contributed by Brian McKenna
on 2014-09-30. .  Windows code corrected by Dimitri Sabadie on 2015-02-09. .
Added @@timeSpecAsNanoSecs@@ as observed widely-used by Chris Done on
2015-01-06, exported correctly on 2015-04-20. .  Imported Control.Applicative
operators correctly for Haskell Platform on Windows on 2015-04-21. .  Unit tests
and instance fixes by Christian Burger on 2015-06-25. .  Removal of fromInteger
: Integer -> TimeSpec by Cetin Sert on 2015-12-15. .  New Linux-specific Clocks:
MonotonicRaw, Boottime, MonotonicCoarse, RealtimeCoarse by Cetin Sert on
2015-12-15. .  Reintroduction fromInteger : Integer -> TimeSpec by Cetin Sert on
2016-04-05. .  Fixes for older Linux build failures introduced by new
Linux-specific clocks by Mario Longobardi on 2016-04-18. .  Refreshment release
in 2019-04 after numerous contributions. .  Refactoring for Windows, Mac
implementation consistence by Alexander Vershilov on 2021-01-16. . [Version
Scheme] Major-@@/R/@@-ewrite .  New-@@/F/@@-unctionality .
@@/I/@@-mprovementAndBugFixes . @@/P/@@-ackagingOnly . * @@PackagingOnly@@
changes are made for quality assurance reasons.")
    (license license:bsd-3)))

(define-public ghc-next-extra
  (package
    (name "ghc-next-extra")
    (version "1.7.12")
    (source (origin
              (method url-fetch)
              (uri (hackage-uri "extra" version))
              (sha256
               (base32
                "0g5h8fp0nq4k9asiknw0bhvb10zpfnsixfp0n3xz0rc83pnajwg5"))))
    (build-system haskell-build-system)
    (inputs (list ghc-next-clock))
    (arguments
     `(#:haskell ,ghc-9.0
       #:tests? #f))
    (home-page "https://github.com/ndmitchell/extra#readme")
    (synopsis "Extra functions I use.")
    (description
     "This package provides a library of extra functions for the standard Haskell
libraries.  Most functions are simple additions, filling out missing
functionality.  A few functions are available in later versions of GHC, but this
package makes them available back to GHC 7.2. .  The module \"Extra\" documents
all functions provided by this library.  Modules such as \"Data.List.Extra\"
provide extra functions over \"Data.List\" and also reexport \"Data.List\".  Users
are recommended to replace \"Data.List\" imports with \"Data.List.Extra\" if they
need the extra functionality.")
    (license license:bsd-3)))

(define-public ghc-next-filepattern
  (package
    (name "ghc-next-filepattern")
    (version "0.1.3")
    (source (origin
              (method url-fetch)
              (uri (hackage-uri "filepattern" version))
              (sha256
               (base32
                "0dlnwnwhsfdkwm69z66wj5d2x9n3la55glq4fsn5rxm2kr1msi6c"))))
    (build-system haskell-build-system)
    (inputs (list ghc-next-extra))
    (arguments
     `(#:haskell ,ghc-9.0
       #:tests? #f))
    (home-page "https://github.com/ndmitchell/filepattern#readme")
    (synopsis "File path glob-like matching")
    (description
     "This package provides a library for matching files using patterns such as
@@\\\"src\\/**\\/*.png\\\"@@ for all @@.png@@ files recursively under the @@src@@
directory.  Features: . * All matching is /O(n)/.  Most functions precompute
some information given only one argument. . * See \"System.FilePattern\" and
@@?==@@ simple matching and semantics. . * Use @@match@@ and @@substitute@@ to
extract suitable strings from the @@*@@ and @@**@@ matches, and substitute them
back into other patterns. . * Use @@step@@ and @@matchMany@@ to perform bulk
matching of many patterns against many paths simultaneously. . * Use
\"System.FilePattern.Directory\" to perform optimised directory traverals using
patterns. .  Originally taken from the
<https://hackage.haskell.org/package/shake Shake library>.")
    (license license:bsd-3)))

(define-public ghc-next-js-flot
  (package
    (name "ghc-next-js-flot")
    (version "0.8.3")
    (source (origin
              (method url-fetch)
              (uri (hackage-uri "js-flot" version))
              (sha256
               (base32
                "0yjyzqh3qzhy5h3nql1fckw0gcfb0f4wj9pm85nafpfqp2kg58hv"))))
    (build-system haskell-build-system)
    (arguments
     `(#:haskell ,ghc-9.0
       #:tests? #f))
    (home-page "https://github.com/ndmitchell/js-flot#readme")
    (synopsis "Obtain minified flot code")
    (description
     "This package bundles the minified <http://www.flotcharts.org/ Flot> code (a
jQuery plotting library) into a Haskell package, so it can be depended upon by
Cabal packages.  The first three components of the version number match the
upstream flot version.  The package is designed to meet the redistribution
requirements of downstream users (e.g. Debian).")
    (license license:expat)))

(define-public ghc-next-js-jquery
  (package
    (name "ghc-next-js-jquery")
    (version "3.3.1")
    (source (origin
              (method url-fetch)
              (uri (hackage-uri "js-jquery" version))
              (sha256
               (base32
                "16q68jzbs7kp07dnq8cprdcc8fd41rim38039vg0w4x11lgniq70"))))
    (build-system haskell-build-system)
    (arguments
     `(#:haskell ,ghc-9.0
       #:tests? #f))
    (home-page "https://github.com/ndmitchell/js-jquery#readme")
    (synopsis "Obtain minified jQuery code")
    (description
     "This package bundles the minified <http://jquery.com/ jQuery> code into a
Haskell package, so it can be depended upon by Cabal packages.  The first three
components of the version number match the upstream jQuery version.  The package
is designed to meet the redistribution requirements of downstream users (e.g.
Debian).")
    (license license:expat)))

(define-public ghc-next-primitive
  (package
    (name "ghc-next-primitive")
    (version "0.7.4.0")
    (source (origin
              (method url-fetch)
              (uri (hackage-uri "primitive" version))
              (sha256
               (base32
                "1mddh42i6xg02z315c4lg3zsxlr3wziwnpzh2nhzdcifh716sbav"))))
    (build-system haskell-build-system)
    (arguments
     `(#:haskell ,ghc-9.0
       #:tests? #f))
    (home-page "https://github.com/haskell/primitive")
    (synopsis "Primitive memory-related operations")
    (description
     "This package provides various primitive memory-related operations.")
    (license license:bsd-3)))

(define-public ghc-next-utf8-string
  (package
    (name "ghc-next-utf8-string")
    (version "1.0.2")
    (source (origin
              (method url-fetch)
              (uri (hackage-uri "utf8-string" version))
              (sha256
               (base32
                "16mh36ffva9rh6k37bi1046pgpj14h0cnmj1iir700v0lynxwj7f"))))
    (build-system haskell-build-system)
    (arguments
     `(#:haskell ,ghc-9.0
       #:tests? #f))
    (home-page "https://github.com/glguy/utf8-string/")
    (synopsis "Support for reading and writing UTF8 Strings")
    (description
     "This package provides a UTF8 layer for Strings.  The utf8-string package
provides operations for encoding UTF8 strings to Word8 lists and back, and for
reading and writing UTF8 without truncation.")
    (license license:bsd-3)))

(define-public ghc-next-shake
  (package
    (name "ghc-next-shake")
    (version "0.19.7")
    (source (origin
              (method url-fetch)
              (uri (hackage-uri "shake" version))
              (sha256
               (base32
                "1lcr6q53qwm308bny6gfawcjhxsmalqi3dnwckam02zp2apmcaim"))))
    (build-system haskell-build-system)
    (inputs (list ghc-next-extra
                  ghc-next-filepattern
                  ghc-next-hashable
                  ghc-next-heaps
                  ghc-next-js-dgtable
                  ghc-next-js-flot
                  ghc-next-js-jquery
                  ghc-next-primitive
                  ghc-next-random
                  ghc-next-unordered-containers
                  ghc-next-utf8-string))
    (arguments
     `(#:haskell ,ghc-9.0
       #:tests? #f))
    (home-page "https://shakebuild.com")
    (synopsis
     "Build system library, like Make, but more accurate dependencies.")
    (description
     "Shake is a Haskell library for writing build systems - designed as a replacement
for @@make@@.  See \"Development.Shake\" for an introduction, including an
example.  The homepage contains links to a user manual, an academic paper and
further information: <https://shakebuild.com> .  To use Shake the user writes a
Haskell program that imports \"Development.Shake\", defines some build rules, and
calls the Development.Shake.shakeArgs function.  Thanks to do notation and infix
operators, a simple Shake build system is not too dissimilar from a simple
Makefile.  However, as build systems get more complex, Shake is able to take
advantage of the excellent abstraction facilities offered by Haskell and easily
support much larger projects.  The Shake library provides all the standard
features available in other build systems, including automatic parallelism and
minimal rebuilds.  Shake also provides more accurate dependency tracking,
including seamless support for generated files, and dependencies on system
information (e.g. compiler version).")
    (license license:bsd-3)))

(define-public ghc-next-base-orphans
  (package
    (name "ghc-next-base-orphans")
    (version "0.8.7")
    (source (origin
              (method url-fetch)
              (uri (hackage-uri "base-orphans" version))
              (sha256
               (base32
                "0iz4v4h2ydncdwfqzs8fd2qwl38dx0n94w5iymw2g4xy1mzxd3w8"))))
    (build-system haskell-build-system)
    (arguments
     `(#:haskell ,ghc-9.0
       #:tests? #f))
    (home-page "https://github.com/haskell-compat/base-orphans#readme")
    (synopsis "Backwards-compatible orphan instances for base")
    (description
     "@@base-orphans@@ defines orphan instances that mimic instances available in
later versions of @@base@@ to a wider (older) range of compilers.
@@base-orphans@@ does not export anything except the orphan instances themselves
and complements @@<http://hackage.haskell.org/package/base-compat
base-compat>@@. .  See the README for what instances are covered:
<https://github.com/haskell-compat/base-orphans#readme>.  See also the
<https://github.com/haskell-compat/base-orphans#what-is-not-covered what is not
covered> section.")
    (license license:expat)))

(define-public ghc-next-hashable
  (package
    (name "ghc-next-hashable")
    (version "1.4.1.0")
    (source (origin
              (method url-fetch)
              (uri (hackage-uri "hashable" version))
              (sha256
               (base32
                "11sycr73821amdz8g0k8c97igi4z7f9xdvgaxlkxhsp6h310bcz1"))))
    (build-system haskell-build-system)
    (inputs (list ghc-next-base-orphans))
    (arguments
     `(#:haskell ,ghc-9.0
       #:tests? #f))
    (home-page "http://github.com/haskell-unordered-containers/hashable")
    (synopsis "A class for types that can be converted to a hash value")
    (description
     "This package defines a class, Hashable', for types that can be converted to a
hash value.  This class exists for the benefit of hashing-based data structures.
 The package provides instances for basic types and a way to combine hash
values.")
    (license license:bsd-3)))

(define-public ghc-next-unordered-containers
  (package
    (name "ghc-next-unordered-containers")
    (version "0.2.19.1")
    (source (origin
              (method url-fetch)
              (uri (hackage-uri "unordered-containers" version))
              (sha256
               (base32
                "1li8s6qw8mgv6a7011y7hg0cn2nllv2g9sr9c1xb48nmw32vw9qv"))))
    (build-system haskell-build-system)
    (inputs (list ghc-next-hashable))
    (arguments
     `(#:haskell ,ghc-9.0
       #:tests? #f
       #:cabal-revision ("1"
                         "0fcax3apnpxxy9maymclr6s2b4c28d3pkl3plbg0lv1mn0mh84fv")))
    (home-page
     "https://github.com/haskell-unordered-containers/unordered-containers")
    (synopsis "Efficient hashing-based container types")
    (description
     "Efficient hashing-based container types.  The containers have been optimized for
performance critical use, both in terms of large data quantities and high speed.
.  The declared cost of each operation is either worst-case or amortized, but
remains valid even if structures are shared. . /Security/ .  This package
currently provides no defenses against hash collision attacks such as HashDoS.
Users who need to store input from untrusted sources are advised to use
@@Data.Map@@ or @@Data.Set@@ from the @@containers@@ package instead.")
    (license license:bsd-3)))

;;; Section --- Hadrian

(define-public ghc-hadrian-9.4.2
  (package
    (name "ghc-hadrian")
    (version "9.4.2")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://gitlab.haskell.org/ghc/ghc/-/archive/ghc-9.4.2-release/ghc-ghc-9.4.2-release.tar.gz?path=hadrian"))
              (sha256
               (base32
                "19b6shils2h1y2rs64sclxhjsp1fgb3p282s63lrzqxqcbsq1f1k"))))
    (build-system haskell-build-system)
    (inputs (list ghc-next-quickcheck ghc-next-extra ghc-next-shake
                  ghc-next-unordered-containers))
    (arguments
     `(#:haskell ,ghc-9.0
       #:phases (modify-phases %standard-phases
                  (add-after 'unpack 'keep-hadrian-only
                    (lambda _
                      (copy-recursively "./hadrian" "./")
                      (delete-file-recursively "./hadrian") #t)))))
    (home-page (string-append
                "https://gitlab.haskell.org/ghc/ghc/-/tree/ghc-9.4.2-release/hadrian"))
    (synopsis "GHC build system")
    (description "GHC build system")
    (license license:bsd-3)))
