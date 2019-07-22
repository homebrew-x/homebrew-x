require "language/node"
require "json"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://github.com/zeit/now-cli/archive/15.8.5.tar.gz"
  sha256 "74ac225083767df56153127d2c479b1f983cafc0b17d757a07f3e2012b64c0fb"

  depends_on "node"

  def install
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["scripts"].delete("postinstall") # don't run postinstall
    IO.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "run", "build"

    # create release package.json (set main entry point, install only the release bundle)
    pkg_json["bin"]["now"] = "index.js"
    pkg_json.delete("dependencies")
    pkg_json.delete("files")
    IO.write("dist/package.json", JSON.pretty_generate(pkg_json))

    # add shebang + pretend to be packaged via pkg + change update notification
    inreplace "dist/index.js" do |s|
      s.gsub! "require('./sourcemap-register.js');", "#!/usr/bin/env node\n\nrequire('./sourcemap-register.js');"
      s.gsub! "process.pkg", "true"
      s.gsub! /(\w+).getUpgradeCommand=getUpgradeCommand;/,
              "\\1.getUpgradeCommand=async()=>'Please run `brew upgrade now-cli` to update Now CLI.';"
    end

    cd "dist" do
      system "npm", "install", *Language::Node.std_npm_install_args(libexec)
      bin.install_symlink Dir["#{libexec}/bin/*"]
    end
  end

  test do
    system "#{bin}/now", "init", "markdown"
    assert_predicate testpath/"markdown/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"markdown/package.json", :exist?, "package.json must exist"
    assert_predicate testpath/"markdown/README.md", :exist?, "README.md must exist"
  end
end