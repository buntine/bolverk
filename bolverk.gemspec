Gem::Specification.new do |s|
  
  s.name = "bolverk"
  s.version = "0.0.4"
  s.date = "2009-02-28"
  s.summary = "Bolverk is a basic machine emulator for educational purposes"
  s.homepage = "https://bolverk.andrewbuntine.com"
  s.email = "info@andrewbuntine.com"
  s.authors = ["Andrew Buntine"]
  
  s.description = <<-END
    Bolverk is an emulator for a typical machine language. I have developed it in an attempt to
    better understand the way machines work at a low-level and potentially as an educational tool
    for students who prefer to see a machine language in action in a virtual environment.

    With Bolverk, you can write a machine language program, and then step through the operation one
    "machine cycle" at time. At each point, you can dissect main memory and all registers. This is a
    great way to see how the program effects memory in realtime.

    Programs are written in base-16 (hexadecimal). The language design is based on the one described
    in J. Glenn Brookshears textbook -- Computer Science: An Overview (3rd edition, 1991).
  END
  
  s.files = FileList["{lib}/**/*", "Rakefile", "bolverk.gemspec"].to_a
  s.test_files = FileList["{spec}/**/*spec.rb", "{spec}/**/*helper.rb"].to_a

  s.platform = Gem::Platform::RUBY

end
