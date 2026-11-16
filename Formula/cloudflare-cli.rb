require "language/node"

class CloudflareCli < Formula
  include Language::Node::Shebang

  desc "Command-line interface for the Cloudflare API and Workers"
  homepage "https://developers.cloudflare.com/cf/"
  url "https://registry.npmjs.org/cf/-/cf-1.0.0-rc.0.tgz"
  sha256 "02c74e5bf1cbc528a0cf2c992f8912c392bc44c5a8c9148cc896107129035d6c"
  license any_of: ["Apache-2.0", "MIT"]

  # This tap follows the RC channel as well as the eventual stable release.
  livecheck do
    url :stable
    strategy :npm
  end

  depends_on "node"

  conflicts_with "cf", because: "both install `cf` binaries"
  conflicts_with "cloudfoundry-cli", because: "both install `cf` binaries"

  def install
    system "npm", "install", *std_npm_args
    rewrite_shebang detected_node_shebang, libexec/"lib/node_modules/cf/bin/cf"
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    ENV["CF_SEND_TELEMETRY"] = "false"
    ENV["XDG_CONFIG_HOME"] = testpath/"config"

    assert_match version.to_s, shell_output("#{bin}/cf --version")
    assert_match version.to_s, shell_output("#{bin}/cloudflare --version")

    database_id = "00000000-0000-4000-8000-000000000042"
    output = shell_output("#{bin}/cloudflare d1 raw #{database_id} --local " \
                          "--persist-to=#{testpath}/state --sql='SELECT 42 AS answer' --json")
    result = JSON.parse(output).first.fetch("results")
    assert_equal ["answer"], result.fetch("columns")
    assert_equal [[42]], result.fetch("rows")
  end
end
