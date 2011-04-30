# -*- coding: utf-8; mode: ruby; -*-

begin
  YARD::Rake::YardocTask.new do |t|
    t.files   = ['app/**/*.rb', 'lib/**/*.rb']
    t.options = ['-m', 'markdown']
  end
rescue LoadError => e
  puts "YARD not installed: #{e}"
rescue => e
  puts "NOTICE: yard error: #{e}"
end
