Gem::Specification.new do |s|
  
  s.name = "bolverk"
  s.version = "0.0.1"
  s.date = "2009-02-23"
  s.summary = "Bolverk is a basic machine emulator for educational purposes"
  s.homepage = "https://bolverk.andrewbuntine.com"
  s.email = "info@andrewbuntine.com"
  s.authors = ["Andrew Buntine"]
  
  s.description = <<-END
Hackless generates CMS driven websites from unique designs. We aim to make this possible for
non-programmers.

Hackless makes ruby on rails sites. A template site is available from the website in
'examples/template'.

Plugins include:
  ActiveScaffold: Generates the admin interface.
  File Column: Handles file uploads. It uses rMagic to resize images.
  Restful Authentication: Admin area authentication.
  Will Paginate: Pagenation on pagenated listing pages.
  Hackless: Provides a model generator that'll create the appropriate admin area.
END
  
  s.files = FileList["{lib}/**/*", "Rakefile", "bolverk.gemspec"].to_a
  s.test_files = FileList["{spec}/**/*spec.rb", "{spec}/**/*helper.rb"].to_a

  s.platform = Gem::Platform::RUBY

end
