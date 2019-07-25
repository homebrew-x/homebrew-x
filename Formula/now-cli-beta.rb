require "language/node"

class NowCliBeta < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-15.9.0-canary.21.tgz"
  sha256 "2173eaadc11c84fddae196f3e2cdcbbf4789d4a333dbac5e2ece88d26cef1a13"

  depends_on "node"

  def install
    rm Dir["dist/{*.exe,xsel}"]
    inreplace "dist/index.js" do |s|
      s.gsub! /(\w+).(\w+)=getUpdateCommand/, "\\1.\\2=async()=>'Please run `brew upgrade now-cli` to update Now CLI.'"
      s.gsub! '"now update"', '"brew upgrade now-cli"'
    end
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/now", "init", "markdown"
    assert_predicate testpath/"markdown/now.json", :exist?, "now.json must exist"
    assert_predicate testpath/"markdown/README.md", :exist?, "README.md must exist"
  end
end
