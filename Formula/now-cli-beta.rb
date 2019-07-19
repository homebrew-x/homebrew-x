require "language/node"

class NowCliBeta < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://github.com/zeit/now-cli/archive/15.9.0-canary.13.tar.gz"
  sha256 "7511281b69aac029111306ce9402017c4918f42e22940bc2b21c40b77c8fb463"

  depends_on "node" => :build

  def install
    # don't run postinstall
    inreplace("package.json") { |s| s.gsub! /^.*"postinstall".*$/, "" }

    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "run", "build"

    # Read the target node version from package.json
    target = IO.read("package.json").match(/\"(node\d+(\.\d+){2})-[^"]+\"/)[1]

    # This packages now-cli together with a patched version of node
    pkg_args = %W[
      --c=package.json
      --o=now
      --options=no-warnings
      --targets=#{target}
    ]
    system "node_modules/.bin/pkg", "bin/now.js", *pkg_args

    bin.install "now"
  end

  test do
    system "#{bin}/now", "init", "bash"
    assert_predicate testpath/"bash/index.sh", :exist?, "index.sh must exist"
    assert_predicate testpath/"bash/now.json", :exist?, "now.json must exist"
    assert_predicate testpath/"bash/README.md", :exist?, "README.md must exist"
    system "echo", "handler >> bash/index.sh"
    system "bash", "bash/index.sh"
  end
end
