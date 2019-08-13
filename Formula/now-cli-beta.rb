require "language/node"

class NowCliBeta < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-16.1.2-canary.2.tgz"
  sha256 "f519c0f7fe4cdc833711c95ca7a7619b0310ed09e5afdf04b1b4af8f89c74570"

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
