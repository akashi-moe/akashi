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

(define-module (akashi packages haskell)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages haskell)
  #:use-module (gnu packages haskell-check)
  #:use-module (gnu packages haskell-web)
  #:use-module (gnu packages haskell-xyz)
  #:use-module (gnu packages libffi)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages python)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system haskell)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module ((guix licenses)
                #:prefix license:))

;;; Section --- Shake

(define-public ghc-js-dgtable
  (package
    (name "ghc-js-dgtable")
    (version "0.5.2")
    (source (origin
              (method url-fetch)
              (uri (hackage-uri "js-dgtable" version))
              (sha256
               (base32
                "1b10kx703kbkb5q1ggdpqcrxqjb33kh24khk21rb30w0xrdxd3g2"))))
    (build-system haskell-build-system)
    (home-page "https://github.com/ndmitchell/js-dgtable#readme")
    (synopsis "Obtain minified jquery.dgtable code")
    (description
     "This package bundles the minified <https://github.com/danielgindi/jquery.dgtable
jquery.dgtable> code into a Haskell package, so it can be depended upon by Cabal
packages.  The first three components of the version number match the upstream
jquery.dgtable version.  The package is designed to meet the redistribution
requirements of downstream users (e.g. Debian).")
    (license license:expat)))

(define-public ghc-heaps
  (package
    (name "ghc-heaps")
    (version "0.4")
    (source (origin
              (method url-fetch)
              (uri (hackage-uri "heaps" version))
              (sha256
               (base32
                "1zbw0qrlnhb42v04phzwmizbpwg21wnpl7p4fbr9xsasp7w9scl9"))))
    (build-system haskell-build-system)
    (home-page "http://github.com/ekmett/heaps/")
    (synopsis "Asymptotically optimal Brodal/Okasaki heaps.")
    (description
     "Asymptotically optimal Brodal\\/Okasaki bootstrapped skew-binomial heaps from the
paper <http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.48.973 \"Optimal
Purely Functional Priority Queues\">, extended with a Foldable interface.")
    (license license:bsd-3)))

(define-public ghc-shake
  (package
    (name "ghc-shake")
    (version "0.19.7")
    (source (origin
              (method url-fetch)
              (uri (hackage-uri "shake" version))
              (sha256
               (base32
                "1lcr6q53qwm308bny6gfawcjhxsmalqi3dnwckam02zp2apmcaim"))))
    (build-system haskell-build-system)
    (inputs (list ghc-extra
                  ghc-filepattern
                  ghc-hashable
                  ghc-heaps
                  ghc-js-dgtable
                  ghc-js-flot
                  ghc-js-jquery
                  ghc-primitive
                  ghc-random
                  ghc-unordered-containers
                  ghc-utf8-string))
    (native-inputs (list ghc-quickcheck))
    (arguments
     '(#:tests? #f ;Too much wizardry...
       #:phases (modify-phases %standard-phases
                  (add-before 'configure 'replace-bin-sh
                    (lambda _
                      (substitute* (list "src/Development/Shake/Command.hs"
                                         "src/Test/Manual.hs")
                        (("/bin/sh")
                         (which "sh"))) #t)))))
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

;;; Section --- Hadrian

(define-public ghc-hadrian-9.2.4
  (package
    (name "ghc-hadrian")
    (version "9.2.4")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://gitlab.haskell.org/ghc/ghc/-/archive/ghc-9.2.4-release/ghc-ghc-9.2.4-release.tar.gz?path=hadrian"))
              (sha256
               (base32
                "1w61g6mdays471kw6d1axgv2ayq7nfs6wvwj73pxvpsd4v3z1l2q"))))
    (build-system haskell-build-system)
    (inputs (list ghc-quickcheck ghc-extra ghc-shake ghc-unordered-containers))
    (arguments
     `(#:haskell ,ghc-8.10
       #:phases (modify-phases %standard-phases
                  (add-after 'unpack 'keep-hadrian-only
                    (lambda _
                      (copy-recursively "./hadrian" "./")
                      (delete-file-recursively "./hadrian") #t)))))
    (home-page (string-append
                "https://gitlab.haskell.org/ghc/ghc/-/tree/ghc-9.2.4-release/hadrian"))
    (synopsis "GHC build system")
    (description "GHC build system")
    (license license:bsd-3)))

;;; Section --- GHC

(define-public ghc-9.2
  (package
    (name "ghc")
    (version "9.2.4")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://www.haskell.org/ghc/dist/" version
                                  "/ghc-" version "-src.tar.xz"))
              (sha256
               (base32
                "0n34k7ga6ypg8j5xawqphph8qrvsp0qmy1rxfbkw83ja0s43h88m"))))
    (inputs (list autoconf
                  automake
                  bash-minimal
                  gcc-toolchain
                  gmp
                  libffi
                  ncurses
                  python-3
                  ghc-8.10
                  ghc-alex
                  ghc-happy
                  ghc-hadrian-9.2.4))
    (native-search-paths
     (list (search-path-specification
            (variable "GHC_PACKAGE_PATH")
            (files (list (string-append "lib/ghc-" version)))
            (file-pattern ".*\\.conf\\.d$")
            (file-type 'directory))))
    (arguments
     (list #:tests? #f
           #:configure-flags #~(list (string-append "--with-gmp-libraries="
                                                    (assoc-ref %build-inputs
                                                               "gmp") "/lib/")
                                     (string-append "--with-gmp-includes="
                                                    (assoc-ref %build-inputs
                                                               "gmp")
                                                    "/include/")
                                     "--with-system-libffi"
                                     (string-append "--with-ffi-libraries="
                                                    (assoc-ref %build-inputs
                                                               "libffi")
                                                    "/lib/")
                                     (string-append "--with-ffi-includes="
                                                    (assoc-ref %build-inputs
                                                               "libffi")
                                                    "/include/")
                                     (string-append "--with-curses-libraries="
                                      (assoc-ref %build-inputs "ncurses")
                                      "/lib/")
                                     (string-append "--with-curses-includes="
                                                    (assoc-ref %build-inputs
                                                               "ncurses")
                                                    "/include/"))
           #:phases #~(modify-phases %standard-phases
                        (add-before 'configure 'configure-programs
                          (lambda* (#:key inputs #:allow-other-keys)
                            (let ((bash-minimal (assoc-ref inputs
                                                           "bash-minimal"))
                                  (gcc-toolchain (assoc-ref inputs
                                                            "gcc-toolchain"))
                                  (alex (assoc-ref inputs "ghc-alex"))
                                  (happy (assoc-ref inputs "ghc-happy")))
                              (setenv "SH"
                                      (string-append bash-minimal "/bin/sh"))
                              (setenv "CC"
                                      (string-append gcc-toolchain "/bin/gcc"))
                              (setenv "LD"
                                      (string-append gcc-toolchain "/bin/ld"))
                              (setenv "AR"
                                      (string-append gcc-toolchain "/bin/ar"))
                              (setenv "NM"
                                      (string-append gcc-toolchain "/bin/nm"))
                              (setenv "ALEX"
                                      (string-append alex "/bin/alex"))
                              (setenv "HAPPY"
                                      (string-append happy "/bin/happy")))))
                        (add-before 'configure 'boot-hadrian
                          (lambda _
                            (invoke "./boot" "--hadrian")))
                        (add-before 'build 'fix-environment
                          (lambda _
                            (unsetenv "GHC_PACKAGE_PATH")
                            (setenv "CONFIG_SHELL"
                                    (which "bash"))))
                        (replace 'build
                          (lambda _
                            (invoke (which "hadrian") "-j" "--docs=none"
                                    "--flavour=Quick" "binary-dist")))
                        (replace 'install
                          (lambda _
                            (invoke (which "hadrian")
                                    (string-append "--prefix="
                                                   #$output) "-j"
                                    "--docs=none" "install"))))))
    (home-page "https://www.haskell.org/ghc")
    (build-system gnu-build-system)
    (synopsis "The Glasgow Haskell Compiler")
    (description
     "The Glasgow Haskell Compiler (GHC) is a state-of-the-art compiler and
interactive environment for the functional language Haskell.")
    (license license:bsd-3)))
