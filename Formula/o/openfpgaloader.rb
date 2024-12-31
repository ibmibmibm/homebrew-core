class Openfpgaloader < Formula
  desc "Universal utility for programming FPGA"
  homepage "https://github.com/trabucayre/openFPGALoader"
  url "https://github.com/trabucayre/openFPGALoader/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "372f1942dec8a088bc7475f94ccf5a86264cb74e9154d8a162b8d4d26d3971e3"
  license "Apache-2.0"
  head "https://github.com/trabucayre/openFPGALoader.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "614633e045dc77fbb66ff74b8f78e4aab0fc0377a14c422e950f3c8b773b0387"
    sha256 arm64_sonoma:  "5b4852971a5effba612e9a40291973d35c75f89bdc0c9ceaf2d063ae4c62c35d"
    sha256 arm64_ventura: "be740ac62e83b806eb846c338816a12f1e2478d455563a5780a6f9fc3d969839"
    sha256 sonoma:        "84f0db4d940f6c3f6f5bb1869af990705403ecf7833b1f34aa2fb84e88ba34c8"
    sha256 ventura:       "af3ee5c7e8d80e72056595a0d9d3a0e7bd5cd680eda413814b8140ff45adacc3"
    sha256 x86_64_linux:  "cf465f7b777eaefd161a31f44759c0aff094734a220979f01d5b5d005133b525"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libftdi"
  depends_on "libusb"

  uses_from_macos "zlib"

  on_linux do
    depends_on "systemd"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    version_output = shell_output("#{bin}/openFPGALoader -V 2>&1")
    assert_match "openFPGALoader v#{version}", version_output

    error_output = shell_output("#{bin}/openFPGALoader --detect 2>&1 >/dev/null", 1)
    assert_includes error_output, "JTAG init failed"
  end
end
