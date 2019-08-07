require "language/node"

class NowCliBeta < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-16.1.0.tgz"
  sha256 "c089f0add1a4652f01f945d7fed75c811e6268b7c1c180e96876581480f59242"

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
